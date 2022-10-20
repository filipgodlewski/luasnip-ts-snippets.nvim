# luasnip-ts-snippets.nvim
LuaSnip and Treesitter-powered (+regular) snippets

## Install

This plugin has the following dependencies (make sure to install and enable them):
- [neovim/neovim](https://github.com/neovim/neovim)  -- of course
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### Vim Plug
```vim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'L3MON4D3/LuaSnip', {'tag': 'v<CurrentMajor>.*'}
Plug 'filipgodlewski/luasnip-ts-snippets.nvim'
```

### Packer
```lua
use({
   "filipgodlewski/luasnip-ts-snippets.nvim",
   branch = "main",
   config = function()
      local snips = require("luasnip-ts-snippets")
      snips.setup({
         -- your configuration
      })
   end
})
```

### Manually
```sh
mkdir -p ~/.local/share/nvim/site/pack/*/start  # replace '*' with something meaningful
git clone https://github.com/filipgodlewski/luasnip-ts-snippets.nvim.git $_
# '$_' returns the last output, in this case the folder you created
```

## Configuration

Below you can find the default options with values.

DO NOT copy as it will be changed. add only those values that you need to customize.

```lua
require "luasnip-ts-snippets".setup {
   filetypes = {
      "python",
      "lua",
   },
   active_choice_highlight_group = "Normal",
}
```

## Tips

### Set choice shortcut

It generally is a good idea to set up a shortcut for switching the currently active choice as they are used massively in here.

If you're using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), you might potentially want to use something like:

```lua
local cmp = require "cmp"
local ls = require "luasnip"

local mapping = cmp.mapping.preset.insert({
   ["<C-t>"] = cmp.mapping(function(fallback)
      if ls.choice_active() then
         ls.change_choice(1)
      else
         fallback()
      end
   end, { "i", "s" }),
})
```

This will let you switch between available choices with ctrl-t.

## Showcase

TODO

## Contributing

If you wish to help me extend those snippets with the languages that you would like to use, please don't hesitate to do so!
Please, create pull requests, issues, or a fork and let me know about it.

## Donate

If you'd like to support my work financially, buy me a coffee through ... TODO

## License

Licensed under the [MIT](./LICENSE) license.
