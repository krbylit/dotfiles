-- refactoring.nvim now requires lewis6991/async.nvim as a runtime dep
-- (every source file does `require "async"`), but the LazyVim
-- editor/refactoring extra still only declares plenary + treesitter.
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "lewis6991/async.nvim",
  },
}
