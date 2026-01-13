--[[
═══════════════════════════════════════════════════════════════════════════════
IMAGE PASTING IN AGENTIC.NVIM - COMPLETE JOURNEY
═══════════════════════════════════════════════════════════════════════════════

GOAL:
Paste screenshots from clipboard into agentic.nvim chat and send to Claude as images

═══════════════════════════════════════════════════════════════════════════════
ATTEMPTS AND PROBLEMS
═══════════════════════════════════════════════════════════════════════════════

1. CUSTOM ImageManager IN AGENTIC.NVIM (PR #62 - REJECTED)
   ───────────────────────────────────────────────────────────────────────────
   Approach:
   - Built full clipboard → base64 → ACP pipeline directly in agentic.nvim
   - New ImageManager module with platform detection (macOS/Linux/Windows)
   - <C-p> keymap to paste images
   - Visual indicators in input buffer

   Problem:
   - Maintainer rejected as out of scope
   - Quote: "img-clip.nvim already covers Mac, Linux, and Windows"
   - Wants minimal code in agentic.nvim, delegation to existing tools

2. IMG-CLIP WITH BASE64 MODE FOR AgenticInput
   ───────────────────────────────────────────────────────────────────────────
   Approach:
   - Use img-clip.nvim with embed_image_as_base64 = true
   - Paste data URIs: data:image/png;base64,iVBORw0KGgo...

   Problem:
   - img-clip has HARDCODED filetype check in paste.lua:
     ```lua
     M.lang_supports_base64 = function(ft)
       return ft == "markdown" or ft == "md" or ft == "rmd" or ft == "wiki" or ft == "vimwiki"
     end
     ```
   - Error when pasting in AgenticInput:
     "Filetype AgenticInput does not support base64 encoding."
   - NO config option exists to override this list

3. IMG-CLIP WITH FILE PATHS, AGENTIC READS FILES
   ───────────────────────────────────────────────────────────────────────────
   Approach:
   - img-clip saves to img-clip-assets/screenshot.png
   - agentic.nvim reads file path from input, converts to base64

   Problem:
   - File paths don't work reliably with Claude ACP
   - Adds base64 encoding logic to agentic.nvim (maintainer wants minimal)
   - User reported: "pasting image path has not worked well for me with Claude"

═══════════════════════════════════════════════════════════════════════════════
CURRENT SOLUTION (FORK + OVERRIDE)
═══════════════════════════════════════════════════════════════════════════════

Setup:
1. Fork agentic.nvim with minimal data URI parsing (~19 lines)
   - Detects: data:image/png;base64,... in input text
   - Sends as image content to ACP
   - Removes data URI from displayed text

2. Override img-clip's lang_supports_base64 function (see commented config below)
   - Makes img-clip treat AgenticInput as base64-compatible

Workflow:
1. Copy screenshot to clipboard
2. In AgenticInput buffer, press <leader>pi
3. img-clip pastes: data:image/png;base64,iVBORw0KGgo...
4. Submit → agentic detects data URI, sends as image content to Claude
5. Data URI removed from chat display (avoids visual clutter)

Division of Responsibilities:
- img-clip.nvim: clipboard → base64 data URI (all platforms)
- agentic.nvim: parse text input → send to ACP (minimal code)

═══════════════════════════════════════════════════════════════════════════════
ALTERNATIVE SOLUTIONS (NOT CHOSEN)
═══════════════════════════════════════════════════════════════════════════════

Option A: Manual Workflow (No Override Needed)
───────────────────────────────────────────────────────────────────────────────
1. Open any markdown buffer (*.md file)
2. Press <leader>pi → img-clip pastes data URI
3. Copy the pasted data URI
4. Paste into AgenticInput buffer
5. Submit → agentic detects and sends to Claude

Pro: No override code needed
Con: Annoying multi-step process every time

Option B: Fork img-clip.nvim
───────────────────────────────────────────────────────────────────────────────
- Add base64_filetypes config option
- Maintain our own fork

Pro: Clean solution
Con: Maintenance burden, need to sync upstream changes

Option C: Submit PR to img-clip.nvim (Best Long-term)
───────────────────────────────────────────────────────────────────────────────
Add configurable filetype list:

```lua
-- In config defaults:
base64_filetypes = { "markdown", "md", "rmd", "wiki", "vimwiki" }

-- In paste.lua:
M.lang_supports_base64 = function(ft)
  local filetypes = config.get_opt("base64_filetypes") or {}
  return vim.tbl_contains(filetypes, ft)
end
```

Then configure:
```lua
opts = {
  default = {
    base64_filetypes = { "markdown", "md", "AgenticInput", "AgenticChat" },
  }
}
```

Pro: Upstream solution, benefits all users
Con: Waiting for PR acceptance

═══════════════════════════════════════════════════════════════════════════════
CONFIGURATION NOTES
═══════════════════════════════════════════════════════════════════════════════

embed_image_as_base64:
- true: Pastes data URIs (works with our fork)
- false: Pastes file paths (doesn't work well with Claude)

max_base64_size:
- Default: 10 KB (too small!)
- Set to: 10000 KB (10 MB) for screenshots
- Claude has token limits, but 10MB base64 is usually acceptable

process_cmd:
- Use ImageMagick to compress before encoding
- Example: "magick - -resize '800>' -quality 75 -"
- Reduces token usage while maintaining clarity
- Requires: brew install imagemagick

═══════════════════════════════════════════════════════════════════════════════
--]]

return {
    "hakonharnes/img-clip.nvim",
    event = "VeryLazy",
    -- NOTE: This workaround is required to be able to paste base64 into `AgenticInput` filetypes (img-clip only allows pasting into Markdown)
    -- config = function(_, opts)
    --     require("img-clip").setup(opts)
    --
    --     -- Override img-clip's lang_supports_base64 to include AgenticInput
    --     local paste = require("img-clip.paste")
    --     local original_lang_supports_base64 = paste.lang_supports_base64
    --     paste.lang_supports_base64 = function(ft)
    --         if ft == "AgenticInput" or ft == "AgenticChat" then
    --             return true
    --         end
    --         return original_lang_supports_base64(ft)
    --     end
    -- end,
    opts = {
        -- Default settings for file-based buffers (markdown, etc.)
        default = {
            -- dir_path = vim.fn.expand("~/.img-clip-assets"), -- Default directory for saved images
            dir_path = "/tmp", -- Default directory for saved images
            -- embed_image_as_base64 = false,
            embed_image_as_base64 = true,
            max_base64_size = 10000, ---@type number | fun(): number
            -- Reduce image size for AI prompts (requires ImageMagick)
            -- Resizes to max 1024px width while maintaining aspect ratio
            -- Compresses with 80% quality for smaller file sizes
            -- process_cmd = "magick - -resize '1024>' -quality 80 -",
        },
        -- -- Filetype-specific overrides
        -- filetypes = {
        --     -- For agentic buffers, use aggressive compression since
        --     -- large images can exceed Claude's token limits
        --     AgenticInput = {
        --         dir_path = "img-clip-assets",
        --         -- Smaller size for chat: 800px max width, 75% quality
        --         -- process_cmd = "magick - -resize '1024>' -quality 100 -",
        --     },
        -- },
    },
    keys = {
        {
            "<leader>pi",
            function()
                vim.cmd("PasteImage")
            end,
            mode = { "n", "i" },
            desc = "Paste image from clipboard",
        },
        -- {
        --     "<C-p>",
        --     function()
        --         -- Only paste images in agentic buffers
        --         local bufname = vim.bo.filetype(0)
        --         if bufname:match("Agentic") then
        --             vim.cmd("PasteImage")
        --         else
        --             -- Fall back to default <C-p> behavior in other buffers
        --             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, false, true), "n", false)
        --         end
        --     end,
        --     mode = { "n", "i" },
        --     desc = "Paste image from clipboard (Agentic buffers)",
        -- },
    },
}
