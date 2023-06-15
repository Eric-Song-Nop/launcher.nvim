# launcher.nvim

This is a simple Neovim plugin to find and run desktop entry from Neovim.

## Installation

### Lazy

An example of how to load this plugin in Lazy.nvim:

```lua
{
    'Eric-Song-Nop/launcher.nvim',
    cmd = "DRun",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
}
```

Just use command `DRun` to find and run an app!
