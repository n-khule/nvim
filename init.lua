vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugins 
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },             -- telescope dependency
    { src = "https://github.com/nvim-telescope/telescope.nvim" },     -- fuzzy finder
    { src = "https://github.com/lewis6991/gitsigns.nvim" },           -- git gutter + blame
    { src = "https://github.com/stevearc/conform.nvim" },             -- multi-formatter dispatch
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", build = ":TSUpdate" },
    { src = "https://github.com/SmiteshP/nvim-navic" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

-- Options 
local opt = vim.opt

-- Keymaps 
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

opt.number         = true
opt.relativenumber = true
opt.signcolumn     = "yes"   -- always show; prevents layout shifts on diagnostics
opt.cursorline     = true
opt.termguicolors  = true
opt.scrolloff      = 8
opt.splitright     = true
opt.splitbelow     = true
opt.undofile       = true    -- persist undo history across sessions
opt.updatetime     = 250     -- faster CursorHold events (used by codelens, etc.)
opt.timeoutlen     = 300

-- Search
opt.ignorecase = true
opt.smartcase  = true        -- case-sensitive only when query has uppercase
opt.hlsearch   = true
opt.incsearch  = true

-- Indentation
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true

-- Completion 
vim.o.autocomplete = true
opt.completeopt    = "menu,menuone,noselect,popup"
vim.o.pumborder    = "rounded"
vim.o.pummaxwidth  = 80

-- Diagnostics 
local sev = vim.diagnostic.severity

vim.diagnostic.config({
    severity_sort = true,
    float         = { border = "rounded" },
    virtual_text  = {
        severity = { min = sev.WARN }, -- only show warnings and above inline
    },
})

-- LSP 
vim.lsp.config("basedpyright", {
    cmd          = { "basedpyright-langserver", "--stdio" },
    filetypes    = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
    settings     = {
        basedpyright = { analysis = { typeCheckingMode = "standard", venvPath = ".", venv = ".venv" } },
    },
})

vim.lsp.config("gopls", {
    cmd          = { "gopls" },
    filetypes    = { "go", "gomod", "gowork" },
    root_markers = { "go.mod", "go.work", ".git" },
    settings     = {
        gopls = { gofumpt = true },
    },
})

vim.lsp.config("lua_ls", {
    cmd          = { "lua-language-server" },
    filetypes    = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings     = {
        Lua = {
            runtime   = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.enable({ "basedpyright", "gopls", "lua_ls" })

-- Enable inlay hints and code lens when the server supports them
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
                buffer   = ev.buf,
                callback = vim.lsp.codelens.refresh,
            })
        end
    end,
})

-- Formatting 
vim.g.format_on_save = false -- toggle with <leader>tf
local cf_ok, conform = pcall(require, "conform")
if cf_ok then
    conform.setup({
        formatters_by_ft = {
            lua    = { "stylua" },
            python = { "ruff_format" },
            go     = { "gofmt" },
        },
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
            if vim.g.format_on_save then
                conform.format({ bufnr = args.buf, lsp_fallback = true })
            end
        end,
    })
    map("v", "<leader>lf", function()
        conform.format({ range = {
            start = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        }})
    end, "Format selection")
end

-- Treesitter 
local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
    ts.setup({
        ensure_installed = { "lua", "python", "go", "bash", "json", "yaml", "markdown" },
        highlight        = { enable = true },
        indent           = { enable = true },
    })
end

-- Git signs 
local gs_ok, gitsigns = pcall(require, "gitsigns")
if gs_ok then
    gitsigns.setup({
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end
            map("n", "]h", gs.next_hunk,            "Next hunk")
            map("n", "[h", gs.prev_hunk,            "Prev hunk")
            map("n", "<leader>hs", gs.stage_hunk,   "Stage hunk")
            map("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
            map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>hb", gs.blame_line,   "Blame line")
        end,
    })
end

-- nvim-tree
local nt_ok, nvimtree = pcall(require, "nvim-tree")
if nt_ok then
    nvimtree.setup({
        filters = {
            dotfiles = false,  -- set true if you want to hide ALL dotfiles
            custom   = { "^.git$" },
        },
        renderer = {
            icons = {
                show = {
                    file         = true,
                    folder       = false,
                    folder_arrow = true,
                    git          = false,
                },
                glyphs = {
                    default  = "-",
                    folder   = { arrow_open = "v", arrow_closed = ">" },
                    git      = {
                        unstaged  = "M",
                        staged    = "A",
                        unmerged  = "U",
                        renamed   = "R",
                        untracked = "?",
                        deleted   = "D",
                        ignored   = "!",
                    },
                },
            },
        },
    })

    -- Underline folder names
    vim.api.nvim_set_hl(0, "NvimTreeFolderName",      { underline = true })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { underline = true })
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName",  { underline = true })
end


-- Formatting
map("n", "<leader>tf", function()
    vim.g.format_on_save = not vim.g.format_on_save
    vim.notify("Format on save: " .. (vim.g.format_on_save and "on" or "off"))
end, "Toggle format on save")

-- Telescope
local tel_ok, tb = pcall(require, "telescope.builtin")
if tel_ok then
    map("n", "<leader>ff", tb.find_files,  "Find files")
    map("n", "<leader>fg", tb.live_grep,   "Live grep")
    map("n", "<leader>fb", tb.buffers,     "Buffers")
    map("n", "<leader>fh", tb.help_tags,   "Help tags")
    map("n", "<leader>fd", tb.diagnostics, "Diagnostics")
end

-- nvim-tree.lua
map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>", "Toggle file tree")

-- LSP extras (0.12 built-ins cover gra/grn/grr/gri/grt already)
map("n", "<leader>ld", vim.lsp.buf.definition,     "Go to definition")
map("n", "<leader>lh", vim.lsp.buf.hover,          "Hover docs")
map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")
map("n", "<leader>lf", vim.lsp.buf.format,         "LSP format")

-- Ctrl-Space triggers omnifunc (LSP) completions specifically
map("i", "<C-Space>", "<C-x><C-o>", "Trigger LSP completion")

-- Diagnostics
map("n", "[d",        vim.diagnostic.goto_prev,  "Prev diagnostic")
map("n", "]d",        vim.diagnostic.goto_next,  "Next diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostic float")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- Misc
map("n", "<Esc>",     "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<leader>w", "<cmd>write<CR>",      "Save")
map("n", "<leader>q", "<cmd>quit<CR>",       "Quit")
map("n", "<leader>u", "<cmd>packadd nvim.undotree | Undotree<CR>", "Undotree")

-- Statusline 
vim.o.statusline = table.concat({
    " %f",                                  -- relative file path
    " %m%r",                                -- [+] modified, [RO] readonly
    "%=",                                   -- right-align everything after
    "%{%v:lua.vim.lsp.status()%}",          -- LSP progress messages
    " | ",
    "%{%v:lua.vim.diagnostic.status()%}",   -- error/warn counts
    " | %l:%c ",                            -- line:column
    " %p%% ",                               -- scroll percentage
})

-- Colorscheme 
vim.cmd.colorscheme("default")
