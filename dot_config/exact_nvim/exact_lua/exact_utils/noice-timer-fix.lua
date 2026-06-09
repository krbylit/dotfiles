-- Patch noice.nvim's timer-lifecycle leaks.
-- Upstream noice/util/init.lua calls :stop() on libuv timers without :close(),
-- leaving thousands of zombie handles after long sessions.
-- This module replaces the two offending functions in `noice.util` with versions
-- that pair every :stop() with a :close().

local util = require("noice.util")

function util.interval(ms, fn, opts)
  opts = opts or {}
  local timer = nil
  local T = {}

  local function close_timer()
    if timer and not timer:is_closing() then
      pcall(timer.close, timer)
    end
    timer = nil
  end

  function T.keep()
    if util.is_exiting() then
      return false
    end
    return opts.enabled == nil or opts.enabled()
  end

  function T.running()
    return timer and not timer:is_closing()
  end

  function T.stop()
    if T.running() then
      timer:stop()
      close_timer()
    end
  end

  function T.fn()
    pcall(fn)
    if T.running() and not T.keep() then
      timer:stop()
      close_timer()
    elseif T.keep() and not T.running() then
      timer = vim.defer_fn(T.fn, ms)
    end
  end

  function T.__call()
    if not T.running() and T.keep() then
      timer = vim.defer_fn(T.fn, ms)
    end
  end

  return setmetatable(T, T)
end

return true
