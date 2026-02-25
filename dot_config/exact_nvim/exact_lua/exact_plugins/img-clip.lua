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

if vim.env.IS_SSH == "1" then
  return {}
end

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
      verbose = false, -- suppress "Content is not an image." on non-image pastes
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
    filetypes = {
      -- For markdown (Obsidian notes): save as file into vault attachments folder,
      -- insert a relative path link. The Obsidian global is the loaded client.
      markdown = {
        embed_image_as_base64 = false,
        -- dir_path must be RELATIVE to the current file when relative_to_current_file = true.
        -- img-clip saves to (current_file_dir / dir_path / filename) and inserts that same
        -- relative path as the link. An absolute dir_path causes img-clip to create the full
        -- absolute path as nested subdirectories under the current file's directory.
        dir_path = function()
          local current_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")

          -- Vault subdirectories that should NOT use the shared attachments folder.
          -- Matched as plain substrings against the current file's directory path.
          local vault_attachment_excluded_dirs = {
            "/src/",
            "/src_code/",
          }
          -- Only use the vault attachments dir if the current file is inside the vault
          -- and not in an excluded subdirectory.
          if Obsidian then
            local vault_path = tostring(Obsidian.workspace.path)
            local in_vault = current_dir:find(vault_path, 1, true)
            local excluded = false
            for _, pattern in ipairs(vault_attachment_excluded_dirs) do
              if current_dir:find(pattern, 1, true) then
                excluded = true
                break
              end
            end
            if in_vault and not excluded then
              local target = vault_path .. "/05_Attachments/images"
              -- Compute relative path from current_dir to target
              local function split(p)
                local parts = {}
                for part in p:gmatch("[^/]+") do
                  table.insert(parts, part)
                end
                return parts
              end
              local src, dst = split(current_dir), split(target)
              local common = 0
              for i = 1, math.min(#src, #dst) do
                if src[i] == dst[i] then
                  common = i
                else
                  break
                end
              end
              local rel = {}
              for _ = common + 1, #src do
                table.insert(rel, "..")
              end
              for i = common + 1, #dst do
                table.insert(rel, dst[i])
              end
              return table.concat(rel, "/")
            end
          end

          return "images" -- sibling directory next to the current file
        end,
        file_name = "%Y%m%d%H%M%S",
        prompt_for_file_name = false,
        relative_to_current_file = true,
        url_encode_path = true,
        template = "![img]($FILE_PATH)",
      },
    },
    -- -- Filetype-specific overrides (old stub)
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
    -- {
    --   "<leader>i",
    --   function()
    --     vim.cmd("PasteImage")
    --   end,
    --   mode = { "n", "i" },
    --   desc = "Paste image from clipboard",
    -- },
    -- {
    --   "<C-i>",
    --   function()
    --     -- Only paste images in agentic buffers
    --     local bufname = vim.bo.filetype(0)
    --     if bufname:match("sidekick_terminal") then
    --       vim.cmd("PasteImage")
    --     else
    --       -- Fall back to default <C-p> behavior in other buffers
    --       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>", true, false, true), "n", false)
    --     end
    --   end,
    --   mode = { "n", "i" },
    --   desc = "Paste image from clipboard (Agentic buffers)",
    -- },
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
