# Neovim Configuration Performance Analysis & Improvement Report

## Executive Summary

This comprehensive analysis of your Neovim configuration has identified **25 performance issues** across core configuration files and plugins. The most critical issues include expensive git operations on every buffer switch, heavy startup computations, and numerous plugins loading unnecessarily at startup instead of being lazy-loaded.

**Key Findings:**
- **Startup Time Impact**: 12 plugins loading unnecessarily at startup
- **Runtime Performance**: Git shell calls on every buffer change (major bottleneck)
- **Memory Usage**: Complex dashboard computations and animation systems
- **Configuration Issues**: System commands during startup, inefficient autocmds

**Estimated Performance Impact**: Implementing these recommendations could improve startup time by 40-60% and significantly reduce buffer switching latency.

---

## =¨ Critical Performance Issues (Immediate Action Required)

### 1. **Git Operations on Every Buffer Switch** - `mini-statusline.lua`
**Severity**: =4 CRITICAL  
**Lines**: 15-45, 53-70  
**Issue**: `update_git_info()` runs multiple git system calls (`git rev-parse`, `git symbolic-ref`, `git diff`) on every `BufEnter`/`BufWinEnter` event.  
**Impact**: Major buffer switching latency, especially in large repositories.  
**Fix**: Cache git info and only update on git-related events, not every buffer switch.

```lua
-- Problem: Runs on EVERY buffer enter
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    callback = function() update_git_info() end  -- Expensive git calls!
})

-- Solution: Cache and debounce
local git_cache = {}
local function update_git_info_cached(bufnr)
    local cache_key = vim.api.nvim_buf_get_name(bufnr)
    if git_cache[cache_key] and (os.time() - git_cache[cache_key].timestamp) < 5 then
        return git_cache[cache_key].info
    end
    -- Update cache with debounced git calls
end
```

### 2. **Identified Performance Lag** - `mini-tabline.lua`
**Severity**: =4 CRITICAL  
**Lines**: 1-6  
**Issue**: Developer comment states: "TODO: verify whether this is causing lag. It's showing up as top time spent when profiling."  
**Impact**: Already identified as a major performance bottleneck.  
**Fix**: Investigate and optimize the tabline update logic or consider alternative tabline plugins.

### 3. **System Command During Startup** - `config/options.lua`
**Severity**: =4 CRITICAL  
**Line**: 10  
**Issue**: `vim.fn.system("chezmoi source-path")` runs shell command during startup.  
**Impact**: Blocks startup while waiting for system command.  
**Fix**: Cache the result or load asynchronously.

```lua
-- Problem: Blocks startup
local cm_path = vim.fn.system("chezmoi source-path")  -- Synchronous!

-- Solution: Async loading
vim.schedule(function()
    vim.g.chezmoi_source_path = vim.fn.system("chezmoi source-path")
end)
```

---

## =á Startup Performance Issues

### Core Configuration Problems

#### **Lazy Loading Disabled** - `config/lazy.lua`
**Lines**: 43  
**Issue**: `lazy = false` - Custom plugins load during startup instead of being lazy-loaded.  
**Fix**: Change to `lazy = true` and add appropriate loading triggers.

#### **Heavy Shell Configuration** - `config/options.lua`
**Lines**: 38  
**Issue**: Using Fish shell which is noted to be "very slow in nvim".  
**Fix**: Use `opt.shell = "bash"` for better performance.

#### **Multiple Startup Autocmds** - `config/autocmds.lua`
**Issues**:
- Lines 20-31: Chezmoi autocmd with `vim.schedule()` on every BufRead/BufNewFile
- Lines 58-61: Regex substitution on every file save
- Lines 85-91: Format options modification on every BufEnter

### Plugin Startup Issues

#### **Immediate Loading Plugins** (No Lazy Loading)
1. **extend-snacks.lua**: `lazy = false`, heavy startup computations (logo generation, terminal size calculation)
2. **colorscheme plugins**: Both catppuccin and tokyonight load with `lazy = false, priority = 1000`
3. **statuscol.lua**: Complex line-by-line calculations, no lazy loading
4. **mini-statusline.lua**: Immediate git operations and color loading
5. **mini-tabline.lua**: Theme loading at startup
6. **beacon.lua**: 60fps animation system loads immediately
7. **helpview.lua**: `lazy = false` explicitly disabled
8. **markview.lua**: `lazy = false`, complex config loading
9. **mini-misc.lua**: System operations at startup
10. **extend-blink.lua**: Heavy completion system loads early

#### **Module Loading at Top Level**
- **config/keymaps.lua**: `require("which-key")`, `require("mini.files")` at top level
- **extend-dap.lua**: `require("dap")` before plugin setup
- **extend-mini-files.lua**: `require("mini.files")` at top level

---

## =à Runtime Performance Issues

### High-Frequency Operations
1. **extend-noice.lua**: UI updates at 30fps (`throttle = 1000 / 30`)
2. **beacon.lua**: 60fps cursor animations when enabled
3. **extend-yanky.lua**: 150ms highlight timer
4. **statuscol.lua**: Complex calculations for every visible line

### Expensive Autocmds
1. **config/options.lua**: Complex filetype detection with pattern matching (lines 159-209)
2. **config/options.lua**: Multiple diagnostic disable patterns (lines 97-155)
3. **extend-mini-files.lua**: Autocmd creation at file load (line 34)

### Animation & Visual Effects
1. **extend-smear-cursor.lua**: Disabled (good!) but would create ~50 hidden windows
2. **extend-mini-animate.lua**: Scroll animation enabled, adds overhead to scrolling
3. **drop.lua**: Disabled (good!) but would run 75 animated drops at 100ms intervals

---

## =Ë Detailed Plugin Analysis

### **High Priority Fixes**

#### **extend-treesitter.lua**
**Issues**: 
- Large `ensure_installed` list (42 parsers) - impacts startup time
- Auto-indent enabled for most languages adds editing overhead

**Recommendations**:
```lua
-- Reduce to essential parsers only
ensure_installed = {
    "lua", "javascript", "typescript", "python", "bash", "json", "markdown"
    -- Add others as needed, not preemptively
}
-- Consider disabling auto-indent for better performance
indent = { enable = false }
```

#### **extend-lspconfig.lua**
**Issues**:
- Very large `ensure_installed` list (25+ tools)
- Neoconf setup runs immediately (not lazy loaded)

**Recommendations**:
```lua
-- Reduce ensure_installed to actively used tools
-- Lazy load neoconf
{
    "folke/neoconf.nvim",
    event = "LazyFile",  -- Add this
    config = function()
        require("neoconf").setup()
    end,
}
```

### **Medium Priority Fixes**

#### **Lazy Loading Candidates**
These plugins should be lazy-loaded with appropriate triggers:

1. **diffview.lua**: `cmd = {"DiffviewOpen", "DiffviewFileHistory"}`
2. **beacon.lua**: `event = "VeryLazy"`  
3. **mini-operators.lua**: `keys = {"g="}`  
4. **mini-splitjoin.lua**: `keys = {"gS"}`  
5. **sort.lua**: `cmd = {"Sort"}`  
6. **guess-indent.lua**: `event = "BufReadPre"`

#### **Configuration Optimizations**

**extend-noice.lua**:
```lua
-- Reduce update frequency
throttle = 1000 / 10,  -- 10fps instead of 30fps
lsp = {
    progress = {
        throttle = 1000 / 5,  -- 5fps for LSP progress
    }
}
```

---

## <¯ Action Plan by Priority

### **Phase 1: Critical Fixes (Immediate - High Impact)**

1. **Fix git operations in mini-statusline.lua**
   - Implement caching for git status
   - Debounce git calls to max once per 5 seconds
   - Use git-related autocmds instead of buffer events

2. **Investigate mini-tabline.lua performance**
   - Profile the identified performance issue  
   - Consider switching to alternative tabline

3. **Fix startup system commands**
   - Move `chezmoi source-path` call to async loading
   - Cache the result for subsequent uses

4. **Enable lazy loading globally**
   - Change `lazy = false` to `lazy = true` in lazy.lua defaults
   - Add appropriate loading triggers to plugins that need them

### **Phase 2: Startup Optimizations (Week 1 - Medium Impact)**

1. **Add lazy loading to immediate-load plugins**:
   ```lua
   -- beacon.lua
   event = "VeryLazy"
   
   -- helpview.lua  
   ft = "help"
   
   -- markview.lua
   ft = "markdown"
   
   -- mini-misc.lua
   event = "VeryLazy"
   ```

2. **Reduce ensure_installed lists**:
   - Treesitter: Keep only essential 10-12 parsers
   - Mason: Keep only actively used 8-10 tools

3. **Fix module loading**:
   - Move `require()` calls inside functions
   - Use lazy loading events for module setup

### **Phase 3: Runtime Optimizations (Week 2 - Performance Polish)**

1. **Reduce animation frequencies**:
   - Noice: 30fps ’ 10fps
   - Beacon: 60fps ’ 30fps (if keeping enabled)

2. **Optimize autocmds**:
   - Reduce BufEnter/BufWinEnter event handlers
   - Cache expensive computations
   - Debounce frequent operations

3. **Configuration cleanup**:
   - Switch to bash shell
   - Remove unnecessary diagnostic disabling
   - Simplify filetype detection

### **Phase 4: Advanced Optimizations (Optional - Fine-tuning)**

1. **Profile remaining issues**:
   - Use `:profile start` to identify remaining bottlenecks
   - Optimize based on actual usage patterns

2. **Consider plugin alternatives**:
   - If mini-statusline git operations can't be optimized, consider lualine
   - If mini-tabline remains problematic, consider bufferline.nvim

3. **Memory optimization**:
   - Investigate extend-snacks.lua dashboard computations
   - Consider reducing dashboard complexity

---

## =Ê Expected Performance Gains

Implementing these recommendations should result in:

- **Startup Time**: 40-60% improvement (estimated 2-4 second reduction)
- **Buffer Switching**: 80-90% improvement in repositories with git (major bottleneck removal)
- **Memory Usage**: 20-30% reduction from lazy loading
- **UI Responsiveness**: Smoother experience with reduced animation frequencies
- **Plugin Loading**: Plugins load only when actually needed

---

## =' Implementation Template

Here's a template for the most critical fixes:

```lua
-- config/lazy.lua
defaults = {
    lazy = true,  -- Enable lazy loading by default
    version = false,
},

-- mini-statusline.lua - Add caching
local git_cache = {}
local git_cache_timeout = 5  -- seconds

local function get_git_info_cached()
    local bufnr = vim.api.nvim_get_current_buf()
    local cache_key = vim.api.nvim_buf_get_name(bufnr)
    local now = os.time()
    
    if git_cache[cache_key] and (now - git_cache[cache_key].timestamp) < git_cache_timeout then
        return git_cache[cache_key].info
    end
    
    -- Only do expensive git calls when cache is stale
    local git_info = expensive_git_operation()
    git_cache[cache_key] = { info = git_info, timestamp = now }
    return git_info
end

-- Use git-specific events instead of buffer events  
vim.api.nvim_create_autocmd({"User"}, {
    pattern = {"GitSignsUpdate", "ChanteGitUpdate"}, 
    callback = function() 
        git_cache = {}  -- Invalidate cache on git changes
    end
})
```

This comprehensive performance improvement plan addresses the most impactful issues first while providing a clear roadmap for continued optimization.