-- VS Code compatible keymaps for Neovim

-- Open File Explorer (Ctrl + Shift + E)
vim.keymap.set("n", "<C-E>", vim.cmd.Ex, { noremap = true, silent = true })
