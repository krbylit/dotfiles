-- Disable auto-closing HTML tags in markdown files.
-- nvim-ts-autotag includes markdown in its default supported filetypes,
-- which causes unwanted </tag> insertion when typing HTML-like tags in .md.
return {
  "windwp/nvim-ts-autotag",
  opts = {
    per_filetype = {
      ["markdown"] = {
        enable_close = false,
      },
    },
  },
}
