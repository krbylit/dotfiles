# Adding keymaps for plugins

- Plugin specific keymaps are put in their own files (e.g. `harpoon-maps.lua`) as modules with a `setup()` method.
- `plugin-keymaps/init.lua` `require().setup()`s all the plugin keymap files.
- `config/keymaps.lua` then calls `require("plugin-keymaps").setup()` to load all the plugin keymaps.

## Notes

- `which-key` did not play nice with 'rhs' being a string like this: `":lua require('grug-far').grug_far({ prefills = { paths = vim.fn.expand(" % ") } })<CR>"`
  - Instead used a function call to the command (see the module).

## Adding keymaps to which-key

- To add maps to `which-key`, we can `require("which-key").add(<keymap-spec>)` in the plugin keymap files.
- We can also add 'groups' to `which-key` to categorize the mappings (see e.g. below).
- Keymap spec is a table with the following attributes:

  > A mapping has the following attributes:
  > [1]: (string) lhs (required)
  > [2]: (string|fun()) rhs (optional): when present, it will create the mapping
  > desc: (string|fun():string) description (required for non-groups)
  > group: (string|fun():string) group name (optional)
  > mode: (string|string[]) mode (optional, defaults to "n")
  > cond: (boolean|fun():boolean) condition to enable the mapping (optional)
  > hidden: (boolean) hide the mapping (optional)
  > icon: (string|wk.Icon|fun():(wk.Icon|string)) icon spec (optional)
  > proxy: (string) proxy to another mapping (optional)
  > expand: (fun():wk.Spec) nested mappings (optional)
  > any other option valid for vim.keymap.set. These are only used for creating mappings.

e.g. from `harpooon-maps.lua`, this creates the 'h' group in the main `<leader>` menu and maps `<leader>he`:

```lua

  { "<leader>h", group = "Harpoon" },
  {
   "<leader>he",
   function()
    toggle_telescope(harpoon:list())
   end,
   desc = "Open Harpoon Telescope",
  },
```
