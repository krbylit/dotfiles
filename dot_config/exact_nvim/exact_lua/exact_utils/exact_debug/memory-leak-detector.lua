-- ================================================================
-- Memory Leak Detector
-- ================================================================
-- Monitors memory growth, autocmd accumulation, and timer leaks over time
-- Helps diagnose the "longer runtime = more lag" symptom
--
-- Usage:
--   :lua require("utils.debug.memory-leak-detector").start()
--   (use nvim for 15-30 minutes)
--   :lua require("utils.debug.memory-leak-detector").report()
--
-- This addresses the symptom: lag increases as nvim instance runs longer

local M = {}

local config = {
  enabled = false,
  sample_interval_ms = 30000, -- Sample every 30 seconds
  alert_threshold_mb = 100, -- Alert if memory grows by this much
}

local state = {
  samples = {},
  start_time = nil,
  baseline = nil,
  timer = nil,
}

local log_file = "/tmp/nvim-memory-leak-detector.log"

local function log_msg(msg)
  vim.fn.writefile(vim.split(msg, "\n"), log_file, "a")
end

local function format_time(ms)
  if ms < 60000 then
    return string.format("%.1fs", ms / 1000)
  else
    return string.format("%.1fm", ms / 60000)
  end
end

local function format_memory(bytes)
  local mb = bytes / (1024 * 1024)
  return string.format("%.1f MB", mb)
end

local function count_autocmds()
  local total = 0
  local by_event = {}

  -- Get all autocmds
  for _, event in ipairs({
    "BufEnter",
    "BufLeave",
    "BufWritePre",
    "BufWritePost",
    "CursorMoved",
    "CursorMovedI",
    "InsertEnter",
    "InsertLeave",
    "TextChanged",
    "TextChangedI",
    "WinEnter",
    "WinLeave",
    "VimResized",
    "FileType",
    "LspAttach",
  }) do
    local autocmds = vim.api.nvim_get_autocmds({ event = event })
    by_event[event] = #autocmds
    total = total + #autocmds
  end

  return total, by_event
end

local function count_timers()
  -- This is a heuristic - we can't directly count active timers,
  -- but we can check for common timer-creating plugins
  local timer_count = 0

  -- Check if various plugins that use timers are loaded
  local timer_plugins = {
    "noice",
    "snacks",
    "lualine",
    "bufferline",
    "nvim-treesitter",
    "which-key",
  }

  for _, plugin in ipairs(timer_plugins) do
    local ok, _ = pcall(require, plugin)
    if ok then
      timer_count = timer_count + 1
    end
  end

  return timer_count
end

local function count_buffers()
  local listed = 0
  local unlisted = 0
  local loaded = 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      if vim.api.nvim_buf_is_loaded(buf) then
        loaded = loaded + 1
      end
      if vim.bo[buf].buflisted then
        listed = listed + 1
      else
        unlisted = unlisted + 1
      end
    end
  end

  return { total = listed + unlisted, listed = listed, unlisted = unlisted, loaded = loaded }
end

local function get_plugin_count()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then
    return 0, 0
  end

  local loaded = vim.tbl_filter(function(p)
    return p._.loaded
  end, lazy.plugins())

  return #lazy.plugins(), #loaded
end

local function take_sample()
  if not config.enabled then
    return
  end

  local elapsed_ms = vim.loop.hrtime() / 1000000 - state.start_time

  local memory_kb = vim.loop.resident_set_memory() / 1024
  local autocmd_total, autocmd_by_event = count_autocmds()
  local timer_count = count_timers()
  local buffer_counts = count_buffers()
  local plugin_total, plugin_loaded = get_plugin_count()

  local sample = {
    timestamp = os.date("%H:%M:%S"),
    elapsed_ms = elapsed_ms,
    memory_mb = memory_kb / 1024,
    autocmd_total = autocmd_total,
    autocmd_by_event = autocmd_by_event,
    timer_count = timer_count,
    buffers = buffer_counts,
    plugins = { total = plugin_total, loaded = plugin_loaded },
  }

  -- Set baseline on first sample
  if not state.baseline then
    state.baseline = sample
  end

  table.insert(state.samples, sample)

  -- Log sample
  log_msg(
    string.format(
      "[%s] t=%s | mem=%s (+%s) | autocmds=%d (+%d) | bufs=%d/%d (+%d) | plugins=%d/%d",
      sample.timestamp,
      format_time(elapsed_ms),
      format_memory(sample.memory_mb * 1024 * 1024),
      format_memory((sample.memory_mb - state.baseline.memory_mb) * 1024 * 1024),
      sample.autocmd_total,
      sample.autocmd_total - state.baseline.autocmd_total,
      sample.buffers.listed,
      sample.buffers.total,
      sample.buffers.total - state.baseline.buffers.total,
      sample.plugins.loaded,
      sample.plugins.total
    )
  )

  -- Alert on significant memory growth
  local memory_growth_mb = sample.memory_mb - state.baseline.memory_mb
  if memory_growth_mb > config.alert_threshold_mb then
    vim.notify(
      string.format(
        "⚠️  Memory leak detected: +%s since start (%.1f min ago)",
        format_memory(memory_growth_mb * 1024 * 1024),
        elapsed_ms / 60000
      ),
      vim.log.levels.WARN
    )
  end

  -- Alert on autocmd accumulation
  local autocmd_growth = sample.autocmd_total - state.baseline.autocmd_total
  if autocmd_growth > 50 then
    vim.notify(
      string.format("⚠️  Autocmd accumulation: +%d autocmds since start", autocmd_growth),
      vim.log.levels.WARN
    )
  end
end

-- Public API
function M.start()
  if config.enabled then
    vim.notify("Memory leak detector already running", vim.log.levels.INFO)
    return
  end

  config.enabled = true
  state.samples = {}
  state.baseline = nil
  state.start_time = vim.loop.hrtime() / 1000000

  -- Initialize log
  vim.fn.writefile(
    { "=== MEMORY LEAK DETECTOR SESSION " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===" },
    log_file
  )

  -- Take initial sample
  take_sample()

  -- Start periodic sampling
  state.timer = vim.loop.new_timer()
  state.timer:start(
    config.sample_interval_ms,
    config.sample_interval_ms,
    vim.schedule_wrap(function()
      take_sample()
    end)
  )

  vim.notify(
    string.format("🔍 Memory leak detector started (sampling every %ds)", config.sample_interval_ms / 1000),
    vim.log.levels.INFO
  )
end

function M.stop()
  if not config.enabled then
    vim.notify("Memory leak detector not running", vim.log.levels.INFO)
    return
  end

  config.enabled = false

  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end

  -- Take final sample
  take_sample()

  vim.notify("Memory leak detector stopped", vim.log.levels.INFO)

  if #state.samples > 1 then
    M.report()
  end
end

function M.toggle()
  if config.enabled then
    M.stop()
  else
    M.start()
  end
end

function M.report()
  if #state.samples == 0 then
    vim.notify("No samples collected", vim.log.levels.INFO)
    return
  end

  local latest = state.samples[#state.samples]
  local baseline = state.baseline

  local report = {}
  table.insert(report, "\n=== MEMORY LEAK DETECTOR REPORT ===")
  table.insert(
    report,
    string.format("Session duration: %s (%d samples)\n", format_time(latest.elapsed_ms), #state.samples)
  )

  -- Memory analysis
  table.insert(report, "MEMORY USAGE:")
  table.insert(
    report,
    string.format(
      "  Baseline: %s | Current: %s | Growth: %s (%.1f%%)",
      format_memory(baseline.memory_mb * 1024 * 1024),
      format_memory(latest.memory_mb * 1024 * 1024),
      format_memory((latest.memory_mb - baseline.memory_mb) * 1024 * 1024),
      ((latest.memory_mb - baseline.memory_mb) / baseline.memory_mb) * 100
    )
  )

  -- Autocmd analysis
  table.insert(report, "\nAUTOCMD ACCUMULATION:")
  table.insert(
    report,
    string.format(
      "  Baseline: %d | Current: %d | Growth: +%d",
      baseline.autocmd_total,
      latest.autocmd_total,
      latest.autocmd_total - baseline.autocmd_total
    )
  )

  if latest.autocmd_total - baseline.autocmd_total > 0 then
    table.insert(report, "  Events with growth:")
    for event, count in pairs(latest.autocmd_by_event) do
      local baseline_count = baseline.autocmd_by_event[event] or 0
      local growth = count - baseline_count
      if growth > 0 then
        table.insert(report, string.format("    %s: %d -> %d (+%d)", event, baseline_count, count, growth))
      end
    end
  end

  -- Buffer analysis
  table.insert(report, "\nBUFFER ACCUMULATION:")
  table.insert(
    report,
    string.format(
      "  Baseline: %d listed, %d total | Current: %d listed, %d total | Growth: +%d",
      baseline.buffers.listed,
      baseline.buffers.total,
      latest.buffers.listed,
      latest.buffers.total,
      latest.buffers.total - baseline.buffers.total
    )
  )

  -- Plugin analysis
  table.insert(report, "\nPLUGIN LOADING:")
  table.insert(
    report,
    string.format(
      "  Baseline: %d loaded | Current: %d loaded | Growth: +%d",
      baseline.plugins.loaded,
      latest.plugins.loaded,
      latest.plugins.loaded - baseline.plugins.loaded
    )
  )

  -- Memory growth trend
  if #state.samples > 2 then
    table.insert(report, "\nMEMORY GROWTH TREND:")
    local growth_rates = {}
    for i = 2, #state.samples do
      local prev = state.samples[i - 1]
      local curr = state.samples[i]
      local time_diff_min = (curr.elapsed_ms - prev.elapsed_ms) / 60000
      local mem_growth_mb = curr.memory_mb - prev.memory_mb
      local rate = mem_growth_mb / time_diff_min -- MB per minute
      table.insert(growth_rates, rate)
    end

    local avg_rate = 0
    for _, rate in ipairs(growth_rates) do
      avg_rate = avg_rate + rate
    end
    avg_rate = avg_rate / #growth_rates

    table.insert(
      report,
      string.format("  Average growth rate: %s/minute", format_memory(avg_rate * 1024 * 1024))
    )

    if avg_rate > 1 then
      table.insert(report, "  ⚠️  WARNING: Memory is growing at a concerning rate!")
    elseif avg_rate > 0.1 then
      table.insert(report, "  ⚠️  CAUTION: Steady memory growth detected")
    else
      table.insert(report, "  ✓ Memory growth appears normal")
    end
  end

  -- Recommendations
  table.insert(report, "\nRECOMMENDATIONS:")
  local memory_growth_pct = ((latest.memory_mb - baseline.memory_mb) / baseline.memory_mb) * 100
  local autocmd_growth = latest.autocmd_total - baseline.autocmd_total

  if memory_growth_pct > 50 then
    table.insert(report, "  • Consider restarting nvim - significant memory growth detected")
  end

  if autocmd_growth > 50 then
    table.insert(report, "  • Autocmds are accumulating - check for plugins that register autocmds repeatedly")
  end

  if latest.buffers.total - baseline.buffers.total > 20 then
    table.insert(report, "  • Many buffers opened - use :bufdo bd to clean up unlisted buffers")
  end

  table.insert(report, "\n📄 Detailed log: " .. log_file)

  local report_text = table.concat(report, "\n")
  print(report_text)
  log_msg("\n" .. report_text)
end

function M.set_interval(seconds)
  config.sample_interval_ms = seconds * 1000
  vim.notify(string.format("Sample interval set to %ds", seconds), vim.log.levels.INFO)

  if config.enabled then
    vim.notify("Restart the detector for the new interval to take effect", vim.log.levels.INFO)
  end
end

function M.set_threshold(mb)
  config.alert_threshold_mb = mb
  vim.notify(string.format("Alert threshold set to %d MB", mb), vim.log.levels.INFO)
end

-- Create user commands
vim.api.nvim_create_user_command("MemoryLeakDetectorStart", function()
  M.start()
end, { desc = "Start memory leak detector" })

vim.api.nvim_create_user_command("MemoryLeakDetectorStop", function()
  M.stop()
end, { desc = "Stop memory leak detector" })

vim.api.nvim_create_user_command("MemoryLeakDetectorToggle", function()
  M.toggle()
end, { desc = "Toggle memory leak detector" })

vim.api.nvim_create_user_command("MemoryLeakDetectorReport", function()
  M.report()
end, { desc = "Show memory leak detector report" })

return M
