-- ================================================================
-- Runtime Performance Profiler
-- ================================================================
-- Helps identify what's making nvim slow during normal operation
--
-- Usage:
--   :lua require("utils.debug.profile-runtime").start()  -- Start profiling
--   :lua require("utils.debug.profile-runtime").stop()   -- Stop profiling
--   :lua require("utils.debug.profile-runtime").report() -- Show report
--   :lua require("utils.debug.profile-runtime").reset()  -- Clear data
--
-- After profiling, check:
--   - /tmp/nvim-runtime-profile.log (detailed log)
--   - :messages (in-editor report)

local M = {}

local log_file = "/tmp/nvim-runtime-profile.log"
local start_time = vim.loop.hrtime()
local profiling_active = false

-- Tracking data
local data = {
  autocmds = {},
  slow_operations = {},
  lsp_requests = {},
  buffer_operations = {},
  plugin_calls = {},
}

-- Configuration
local config = {
  slow_threshold_ms = 10, -- Operations slower than this are logged
  autocmd_threshold_ms = 5, -- Autocmds slower than this are logged
  sample_interval_ms = 1000, -- How often to sample system state
}

local function log_msg(msg, level)
  vim.fn.writefile(vim.split(msg, "\n"), log_file, "a")
  if level then
    vim.notify(msg, level)
  end
end

local function get_elapsed_ms(start_ns)
  return (vim.loop.hrtime() - start_ns) / 1000000
end

local function format_time(ms)
  if ms < 1 then
    return string.format("%.2fms", ms)
  elseif ms < 1000 then
    return string.format("%.1fms", ms)
  else
    return string.format("%.2fs", ms / 1000)
  end
end

-- Track slow autocmds
local function profile_autocmds()
  local augroup = vim.api.nvim_create_augroup("RuntimeProfiler_Autocmds", { clear = true })

  -- Get all autocmds and wrap them with profiling
  local events = {
    "BufEnter",
    "BufLeave",
    "BufWritePre",
    "BufWritePost",
    "InsertEnter",
    "InsertLeave",
    "TextChanged",
    "TextChangedI",
    "CursorMoved",
    "CursorMovedI",
    "CursorHold",
    "CursorHoldI",
    "FileType",
    "LspAttach",
    "LspNotify",
  }

  for _, event in ipairs(events) do
    vim.api.nvim_create_autocmd(event, {
      group = augroup,
      callback = function(ev)
        if not profiling_active then
          return
        end

        local event_start = vim.loop.hrtime()

        -- Count existing handlers for this event
        local handlers = vim.api.nvim_get_autocmds({ event = event })

        vim.schedule(function()
          local elapsed = get_elapsed_ms(event_start)
          if elapsed >= config.autocmd_threshold_ms then
            local key = string.format("%s (%d handlers)", event, #handlers)
            data.autocmds[key] = (data.autocmds[key] or 0) + elapsed

            if elapsed >= config.slow_threshold_ms then
              table.insert(data.slow_operations, {
                type = "autocmd",
                name = event,
                duration_ms = elapsed,
                handlers = #handlers,
                timestamp = os.date("%H:%M:%S"),
              })
            end
          end
        end)
      end,
    })
  end
end

-- Track LSP requests
local function profile_lsp()
  local original_request = vim.lsp.buf_request
  vim.lsp.buf_request = function(bufnr, method, params, handler)
    if not profiling_active then
      return original_request(bufnr, method, params, handler)
    end

    local request_start = vim.loop.hrtime()
    local request_method = method

    local wrapped_handler = function(err, result, ctx, config)
      local elapsed = get_elapsed_ms(request_start)
      data.lsp_requests[request_method] = (data.lsp_requests[request_method] or 0) + elapsed

      if elapsed >= config.slow_threshold_ms then
        table.insert(data.slow_operations, {
          type = "lsp",
          name = request_method,
          duration_ms = elapsed,
          timestamp = os.date("%H:%M:%S"),
        })
      end

      if handler then
        return handler(err, result, ctx, config)
      end
    end

    return original_request(bufnr, method, params, wrapped_handler)
  end
end

-- Track buffer operations
local function profile_buffers()
  local augroup = vim.api.nvim_create_augroup("RuntimeProfiler_Buffers", { clear = true })

  local ops = {
    { event = "BufReadPost", name = "buffer_read" },
    { event = "BufWritePost", name = "buffer_write" },
    { event = "BufDelete", name = "buffer_delete" },
  }

  for _, op in ipairs(ops) do
    vim.api.nvim_create_autocmd(op.event, {
      group = augroup,
      callback = function()
        if not profiling_active then
          return
        end
        data.buffer_operations[op.name] = (data.buffer_operations[op.name] or 0) + 1
      end,
    })
  end
end

-- Sample system state periodically
local sample_timer = nil
local function start_sampling()
  if sample_timer then
    return
  end

  local sample_count = 0
  sample_timer = vim.loop.new_timer()
  sample_timer:start(
    0,
    config.sample_interval_ms,
    vim.schedule_wrap(function()
      if not profiling_active then
        return
      end

      sample_count = sample_count + 1

      -- Sample every 5 seconds
      if sample_count % 5 == 0 then
        local mem_kb = vim.loop.resident_set_memory() / 1024
        local plugins_loaded = 0

        local lazy_ok, lazy = pcall(require, "lazy")
        if lazy_ok then
          plugins_loaded = #vim.tbl_filter(function(p)
            return p._.loaded
          end, lazy.plugins())
        end

        log_msg(
          string.format(
            "[SAMPLE %ds] Memory: %.1f MB | Plugins: %d | Buffers: %d",
            sample_count,
            mem_kb / 1024,
            plugins_loaded,
            #vim.api.nvim_list_bufs()
          )
        )
      end
    end)
  )
end

local function stop_sampling()
  if sample_timer then
    sample_timer:stop()
    sample_timer:close()
    sample_timer = nil
  end
end

-- Public API
function M.start()
  if profiling_active then
    log_msg("Profiling already active", vim.log.levels.WARN)
    return
  end

  profiling_active = true
  start_time = vim.loop.hrtime()

  -- Clear previous log
  vim.fn.writefile(
    { "=== RUNTIME PROFILE SESSION " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===" },
    log_file
  )

  -- Reset data
  M.reset()

  -- Start profiling subsystems
  profile_autocmds()
  profile_lsp()
  profile_buffers()
  start_sampling()

  log_msg("Runtime profiling started. Threshold: " .. config.slow_threshold_ms .. "ms", vim.log.levels.INFO)
  log_msg("Use :lua require('utils.debug.profile-runtime').stop() to finish and see report")
end

function M.stop()
  if not profiling_active then
    log_msg("Profiling not active", vim.log.levels.WARN)
    return
  end

  profiling_active = false
  stop_sampling()

  local elapsed = get_elapsed_ms(start_time)
  log_msg(string.format("\n=== PROFILING STOPPED (ran for %s) ===", format_time(elapsed)))

  M.report()
end

function M.reset()
  data = {
    autocmds = {},
    slow_operations = {},
    lsp_requests = {},
    buffer_operations = {},
    plugin_calls = {},
  }
end

function M.report()
  local report = {}

  table.insert(report, "\n=== RUNTIME PERFORMANCE REPORT ===\n")

  -- Top slow operations
  table.insert(report, "## SLOW OPERATIONS (>" .. config.slow_threshold_ms .. "ms):")
  if #data.slow_operations > 0 then
    -- Sort by duration
    table.sort(data.slow_operations, function(a, b)
      return a.duration_ms > b.duration_ms
    end)

    for i, op in ipairs(data.slow_operations) do
      if i > 20 then
        break
      end -- Top 20
      table.insert(
        report,
        string.format("  [%s] %s: %s (%s)", op.timestamp, op.type, op.name, format_time(op.duration_ms))
      )
    end
  else
    table.insert(report, "  (none)")
  end

  -- Autocmds summary
  table.insert(report, "\n## AUTOCMD TOTAL TIME:")
  local autocmd_sorted = {}
  for event, total_ms in pairs(data.autocmds) do
    table.insert(autocmd_sorted, { event = event, time = total_ms })
  end
  table.sort(autocmd_sorted, function(a, b)
    return a.time > b.time
  end)

  for i, item in ipairs(autocmd_sorted) do
    if i > 15 then
      break
    end -- Top 15
    table.insert(report, string.format("  %s: %s", item.event, format_time(item.time)))
  end

  -- LSP requests summary
  table.insert(report, "\n## LSP REQUEST TOTAL TIME:")
  local lsp_sorted = {}
  for method, total_ms in pairs(data.lsp_requests) do
    table.insert(lsp_sorted, { method = method, time = total_ms })
  end
  table.sort(lsp_sorted, function(a, b)
    return a.time > b.time
  end)

  for i, item in ipairs(lsp_sorted) do
    if i > 15 then
      break
    end
    table.insert(report, string.format("  %s: %s", item.method, format_time(item.time)))
  end

  -- Buffer operations
  table.insert(report, "\n## BUFFER OPERATIONS:")
  for op, count in pairs(data.buffer_operations) do
    table.insert(report, string.format("  %s: %d times", op, count))
  end

  -- System info
  table.insert(report, "\n## SYSTEM INFO:")
  local mem_kb = vim.loop.resident_set_memory() / 1024
  table.insert(report, string.format("  Memory: %.1f MB", mem_kb / 1024))
  table.insert(report, string.format("  Buffers: %d", #vim.api.nvim_list_bufs()))

  local lazy_ok, lazy = pcall(require, "lazy")
  if lazy_ok then
    local loaded = vim.tbl_filter(function(p)
      return p._.loaded
    end, lazy.plugins())
    table.insert(report, string.format("  Loaded plugins: %d / %d", #loaded, #lazy.plugins()))
  end

  table.insert(report, "\n📄 Full log: " .. log_file)
  table.insert(report, "")

  local report_text = table.concat(report, "\n")
  log_msg(report_text)
  print(report_text)
end

-- Configuration helpers
function M.set_threshold(ms)
  config.slow_threshold_ms = ms
  log_msg("Slow operation threshold set to " .. ms .. "ms", vim.log.levels.INFO)
end

function M.set_autocmd_threshold(ms)
  config.autocmd_threshold_ms = ms
  log_msg("Autocmd threshold set to " .. ms .. "ms", vim.log.levels.INFO)
end

-- Create user commands
vim.api.nvim_create_user_command("ProfileRuntimeStart", function()
  M.start()
end, { desc = "Start runtime performance profiling" })

vim.api.nvim_create_user_command("ProfileRuntimeStop", function()
  M.stop()
end, { desc = "Stop runtime performance profiling and show report" })

vim.api.nvim_create_user_command("ProfileRuntimeReport", function()
  M.report()
end, { desc = "Show runtime performance report" })

vim.api.nvim_create_user_command("ProfileRuntimeReset", function()
  M.reset()
  log_msg("Profile data reset", vim.log.levels.INFO)
end, { desc = "Reset profiling data" })

return M
