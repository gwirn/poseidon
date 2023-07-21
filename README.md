# Poseidon 🔱

*Let's you navigate the sea of open buffers in neovim*

## Documentation

see `:help poseidon`

Shows a floating window for either all open buffers or only for buffers with the same file type as the current window.
The buffers can be navigated and closed through the floating window.

### Tested on NVIM v0.9.1

## Sample setup

```lua
vim.keymap.set('n', '<leader>cb', function ()
 require("poseidon").buffer_nav(1)
end, {desc = '[C]hange between all [B]uffers'})

vim.keymap.set('n', '<leader>cf', function ()
 require("poseidon").buffer_nav()
end, {desc = '[C]hange between buffers of same [F]iletype'})
```
