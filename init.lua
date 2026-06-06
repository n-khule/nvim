vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugins 
vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", build = ":TSUpdate" },
    { src = "https://github.com/SmiteshP/nvim-navic" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/benomahony/uv.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
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
opt.guicursor      = ""
opt.mouse          = "a"
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

-- nvim-cmp handles completion

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

vim.lsp.config("ts_ls", {
    cmd          = { "typescript-language-server", "--stdio" },
    filetypes    = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    settings     = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

-- nvim-cmp capabilities for LSP
local cmp_capabilities = (function()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    return ok and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
end)()
vim.lsp.config("*", { capabilities = cmp_capabilities })

vim.lsp.enable({ "basedpyright", "gopls", "lua_ls", "ts_ls" })

-- Enable inlay hints and code lens when the server supports them
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        -- Inlay hints
        if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        -- CodeLens
        if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = ev.buf })

            local codelens_group = vim.api.nvim_create_augroup(
                "lsp-codelens-" .. ev.buf,
                { clear = true }
            )

            vim.api.nvim_create_autocmd({
                "BufEnter",
                "BufWinEnter",
                "BufWritePost",
                "InsertLeave",
                "TextChanged",
                "TextChangedI",
                "CursorHold",
                "CursorHoldI",
                "FocusGained",
            }, {
                group = codelens_group,
                buffer = ev.buf,
                callback = function()
                    vim.lsp.codelens.enable(true, { bufnr = ev.buf })
                end,
            })
        end

        -- Symbol highlighting
        if client:supports_method("textDocument/documentHighlight") then
            local highlight_group = vim.api.nvim_create_augroup(
                "lsp-highlight-" .. ev.buf,
                { clear = true }
            )

            vim.api.nvim_create_autocmd(
                { "CursorHold", "CursorHoldI" },
                {
                    group = highlight_group,
                    buffer = ev.buf,
                    callback = vim.lsp.buf.document_highlight,
                }
            )

            vim.api.nvim_create_autocmd(
                { "CursorMoved", "CursorMovedI" },
                {
                    group = highlight_group,
                    buffer = ev.buf,
                    callback = vim.lsp.buf.clear_references,
                }
            )
        end

        -- Navic breadcrumbs
        local ok, navic = pcall(require, "nvim-navic")
        if ok
            and client:supports_method("textDocument/documentSymbol")
            then
                navic.attach(client, ev.buf)
            end
        end,
    })

-- nvim-cmp
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    local kind_icons = {
        Text          = "\u{f0d18}",
        Method        = "\u{f06b1}",
        Function      = "\u{f0530}",
        Constructor   = "\u{f0bd7}",
        Field         = "\u{f0ba9}",
        Variable      = "\u{f0628}",
        Class         = "\u{f0ec6}",
        Interface     = "\u{f0f8a}",
        Module        = "\u{f0480}",
        Property      = "\u{f032b}",
        Unit          = "\u{f0493}",
        Value         = "\u{f0556}",
        Enum          = "\u{f02ad}",
        Keyword       = "\u{f03fe}",
        Snippet       = "\u{f0cce}",
        Color         = "\u{f0f3c}",
        File          = "\u{f0168}",
        Reference     = "\u{f0318}",
        Folder        = "\u{f0169}",
        EnumMember    = "\u{f02ad}",
        Constant      = "\u{f04d9}",
        Struct        = "\u{f0ec6}",
        Event         = "\u{f01ad}",
        Operator      = "\u{f0599}",
        TypeParameter = "\u{f0cec}",
    }

    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
        }, {
            { name = "buffer" },
            { name = "path" },
        }),
        window = {
            completion = {
                border = "rounded",
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            },
            documentation = {
                border = "rounded",
            },
        },
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = (kind_icons[vim_item.kind] or "") .. " " .. vim_item.kind
                return vim_item
            end,
        },
    })
end

-- Formatting 
vim.g.format_on_save = false -- toggle with <leader>tf
local cf_ok, conform = pcall(require, "conform")
if cf_ok then
    conform.setup({
        formatters_by_ft = {
            lua    = { "stylua" },
            python = { "ruff_format" },
            go     = { "gofmt" },
            javascript = { "prettierd", "prettier" },
            javascriptreact = { "prettierd", "prettier" },
            typescript = { "prettierd", "prettier" },
            typescriptreact = { "prettierd", "prettier" },
            json       = { "prettierd", "prettier" },
            yaml       = { "prettierd", "prettier" },
            markdown   = { "prettierd", "prettier" },
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

-- uv.nvim
local uv_ok, uv = pcall(require, "uv")
if uv_ok then
    uv.setup({
      -- Auto-activate virtual environments when found
      auto_activate_venv = true,
      notify_activate_venv = true,

      -- Integration with a UI picker (remove if you don't use snacks/telescope)
      picker_integration = true,

      -- Keymaps (uses <leader>x prefix by default)
      keymaps = {
        prefix = "<leader>x",
        commands = true,
        run_file = true,
        run_selection = true,
        run_function = true,
        venv = true,
        init = true,
        add = true,
        remove = true,
        sync = true,
      },

      execution = {
        run_command = "uv run python",
        notify_output = true,
        notification_timeout = 10000,
      },
    })
end

-- lualine
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
    lualine.setup({
        options = {
            icons_enabled = false,
            theme = "auto",
            disabled_buftypes = { "terminal", "nofile", "prompt", "quickfix" },
            -- component_separators = { left = "|", right = "|" },
            -- section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { "filename", "diagnostics" },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        tabline = {
            lualine_a = { {
                "buffers",
                show_filename_only = true,
                hide_filename_extension = false,
                show_modified_status = true,
                buffers_color = {
                    active   = "lualine_a_normal",
                    inactive = "lualine_c_normal",
                },
            } },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
    })
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

-- Ctrl-Space triggers nvim-cmp (configured above)

-- Diagnostics
map("n", "[d",        vim.diagnostic.goto_prev,  "Prev diagnostic")
map("n", "]d",        vim.diagnostic.goto_next,  "Next diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostic float")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Move to left window")
map("n", "<C-j>", "<C-w>j", "Move to lower window")
map("n", "<C-k>", "<C-w>k", "Move to upper window")
map("n", "<C-l>", "<C-w>l", "Move to right window")

-- Terminal Windows
map("n", "<leader>tv", function() vim.cmd("vertical " .. math.floor(vim.o.columns * 0.25) .. "split | terminal" ) end)
map("n", "<leader>th", function () vim.cmd(math.floor(vim.o.lines * 0.25) .. "split | terminal" ) end)
map("n", "<leader>tt", function() vim.cmd(math.floor(vim.o.lines * 0.25) .. "split | terminal" ) end)

-- Misc
map("n", "<Esc>",     "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<leader>w", "<cmd>write<CR>",      "Save")
map("n", "<leader>q", "<cmd>quit<CR>",       "Quit")
map("n", "<leader>u", "<cmd>packadd nvim.undotree | Undotree<CR>", "Undotree")

-- Colorscheme 
vim.cmd.colorscheme("2026-dark")

