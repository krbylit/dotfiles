return {
  "hedyhli/markdown-toc.nvim",
  ft = "markdown",
  cmd = { "Mtoc" },
  opts = {
    -- Auto-update TOC on save (looks for fence markers)
    auto_update = true,
    -- Fence markers to wrap the TOC
    fences = {
      enabled = true,
      start_text = "mtoc-start",
      end_text = "mtoc-end",
    },
    -- Heading levels to include (1-6)
    headings = {
      before_toc = false, -- Don't include headings before TOC
    },
    -- TOC list options
    toc_list = {
      markers = { "-" }, -- Use dash for list items
      item_format_string = "${indent}${marker} [[#${name}]]", -- Obsidian-style links
    },
  },
}
