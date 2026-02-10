# Neovim Performance Debugging Utilities

Collection of tools to diagnose performance issues in Neovim.

## Quick Start

### For Real-Time Lag Detection (Recommended First Step)

```vim
:LagDetectorEnable
" Use nvim normally, it will notify you when lag occurs
:LagDetectorReport
:LagDetectorDisable
```

### For Comprehensive Profiling

```vim
:ProfileRuntimeStart
" Use nvim for a while (30 seconds to a few minutes)
:ProfileRuntimeStop  " Shows detailed report
```

### For Exit Performance Issues

The exit profiler runs automatically on quit and logs to `/tmp/nvim-quit-profile.log`.

---

## Available Tools

### 1. Lag Detector (`lag-detector.lua`)

**Purpose**: Detects and reports lag spikes as they happen during normal usage.

**When to use**: When nvim feels sluggish but you don't know why.

**Commands**:
```vim
:LagDetectorEnable      " Start monitoring
:LagDetectorDisable     " Stop monitoring
:LagDetectorToggle      " Toggle on/off
:LagDetectorReport      " Show summary of detected lag
:LagDetectorClear       " Clear collected data
```

**Lua API**:
```lua
local lag = require("utils.debug.lag-detector")

lag.enable()                  -- Start monitoring
lag.disable()                 -- Stop monitoring
lag.toggle()                  -- Toggle
lag.report()                  -- Show report
lag.set_threshold(100)        -- Only report lags > 100ms
lag.clear()                   -- Clear data
```

**What it monitors**:
- Autocmd execution time (CursorMoved, TextChanged, etc.)
- LSP request duration
- Window resize/redraw operations
- Any operation taking >50ms (configurable)

**Output**:
- Real-time notifications when lag occurs
- Log file: `/tmp/nvim-lag-detector.log`
- Summary report showing worst offenders

---

### 2. Runtime Profiler (`profile-runtime.lua`)

**Purpose**: Comprehensive profiling of nvim operations over time.

**When to use**: When you want detailed statistics about what's slowing down nvim.

**Commands**:
```vim
:ProfileRuntimeStart    " Begin profiling
:ProfileRuntimeStop     " Stop and show report
:ProfileRuntimeReport   " Show current report
:ProfileRuntimeReset    " Clear collected data
```

**Lua API**:
```lua
local profiler = require("utils.debug.profile-runtime")

profiler.start()                      -- Start profiling
profiler.stop()                       -- Stop and show report
profiler.report()                     -- Show current report
profiler.reset()                      -- Clear data
profiler.set_threshold(15)            -- Report operations >15ms
profiler.set_autocmd_threshold(5)     -- Report autocmds >5ms
```

**What it profiles**:
- Autocmd total execution time by event type
- LSP request total time by method
- Buffer operations (read, write, delete)
- Memory usage samples
- Plugin load status
- Slow operation timeline

**Output**:
- Detailed breakdown by subsystem
- Top 20 slowest operations
- Cumulative time spent in each event type
- Log file: `/tmp/nvim-runtime-profile.log`

---

### 3. Quit Profiler (`profile-quit.lua`)

**Purpose**: Diagnose slow nvim exit/quit.

**When to use**: When `:q` or `:wq` takes a long time to exit.

**How it works**: Automatically runs on every quit, no commands needed.

**What it logs**:
- Time from QuitPre to VimLeave
- Active LSP clients and their shutdown time
- Loaded plugins count
- VimLeavePre/VimLeave event handlers
- Buffer deletion timing

**Output**:
- Log file: `/tmp/nvim-quit-profile.log` (check after exiting nvim)

**To disable**: Comment out the loader in `lua/plugins/_debug.lua`

---

### 4. Indentation Change Tracker (`indentation-change.lua`)

**Purpose**: Track when and what changes indentation settings.

**When to use**: When indentation settings mysteriously change.

**How it works**: Automatically tracks changes (currently disabled by default).

**To enable**: Uncomment the `track_indent_changes()` call in the file.

**What it monitors**:
- Changes to tabstop, shiftwidth, softtabstop, expandtab
- Events: BufEnter, FileType, OptionSet, LspAttach, etc.
- Stack traces showing what triggered the change

**Output**: Real-time notifications when indentation changes

---

## Troubleshooting Workflows

### "Nvim is generally slow/sluggish"

1. Start with lag detector:
   ```vim
   :LagDetectorEnable
   ```
2. Use nvim normally for 2-5 minutes
3. Check the report:
   ```vim
   :LagDetectorReport
   ```
4. Look for patterns (e.g., "CursorMoved with 15 handlers took 85ms")
5. If needed, run comprehensive profiler for more detail:
   ```vim
   :ProfileRuntimeStart
   " ... use nvim for a while ...
   :ProfileRuntimeStop
   ```

### "Specific actions are slow (e.g., entering insert mode, saving files)"

1. Start runtime profiler:
   ```vim
   :ProfileRuntimeStart
   ```
2. Perform the slow action several times
3. Stop and review:
   ```vim
   :ProfileRuntimeStop
   ```
4. Look at the "SLOW OPERATIONS" section to see what triggered

### "Quitting nvim takes forever"

1. Quit nvim normally (it profiles automatically)
2. Check the log:
   ```bash
   cat /tmp/nvim-quit-profile.log
   ```
3. Look for:
   - LSP clients not shutting down
   - Slow VimLeavePre handlers
   - Large plugin counts

### "I want to compare before/after a change"

1. Run profiler before:
   ```vim
   :ProfileRuntimeStart
   " ... use nvim ...
   :ProfileRuntimeStop
   " Copy /tmp/nvim-runtime-profile.log to safe location
   ```
2. Make your change (disable plugin, change config, etc.)
3. Run profiler again:
   ```vim
   :ProfileRuntimeReset
   :ProfileRuntimeStart
   " ... use nvim ...
   :ProfileRuntimeStop
   ```
4. Compare the two log files

---

## Understanding the Output

### Common Culprits

**Autocmds**:
- `CursorMoved` / `CursorMovedI`: Too many handlers = cursor lag
- `TextChanged` / `TextChangedI`: Slow handlers = typing lag
- `BufEnter`: Slow handlers = buffer switching lag

**LSP**:
- `textDocument/semanticTokens`: Slow = syntax highlighting lag
- `textDocument/documentSymbol`: Slow = outline/navic lag
- `textDocument/codeAction`: Slow = lightbulb/diagnostic lag

**Plugins to Check**:
- `treesitter`: Re-parsing on every change
- `lualine/statusline`: Updating too frequently
- `noice`: Message handling overhead
- `copilot/codeium`: Completion requests
- `nvim-cmp/blink`: Completion engine overhead

### Thresholds

- **<5ms**: Normal, no concern
- **5-20ms**: Noticeable on slower machines
- **20-50ms**: User perceivable, investigate if frequent
- **50-100ms**: Definitely laggy
- **>100ms**: Severe performance issue

---

## Tips

1. **Start simple**: Use LagDetector first, it catches most issues
2. **Profile when it's bad**: Enable profiling when you notice lag
3. **Compare logs**: Profile before/after changes to see impact
4. **Focus on frequency**: An operation that's 10ms but runs 100 times/sec is worse than 50ms once
5. **Check the timestamps**: Patterns in timing reveal the culprit
6. **Disable suspects**: If a plugin shows up repeatedly, try disabling it temporarily

---

## Log Files

All log files are written to `/tmp/`:
- `/tmp/nvim-lag-detector.log` - Real-time lag events
- `/tmp/nvim-runtime-profile.log` - Comprehensive profiling data
- `/tmp/nvim-quit-profile.log` - Exit performance data

These are overwritten each session.
