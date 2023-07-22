# Poseidon 🔱

*Let's you (filetype specific) navigate the sea of open buffers in neovim*

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
## Keymaps in poseidon
**Keymaps are only used in poseidon and are remapped to the original keymaps when poseidon is closed**
| Key            | Action                                     |
| -------------- | ------------------------------------------ |
| `<CR>`         | Jump to buffer of current line in poseidon |
| `<ESC>`        | Close poseidon without action              |
| `<D-CR>`       | Delete buffer (like :bw N) of current line |
