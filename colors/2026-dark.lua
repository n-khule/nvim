-- 2026 Dark — Neovim colorscheme
-- Ported from the 2026 Dark VS Code theme

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.o.background = "dark"
vim.g.colors_name = "2026-dark"

local hi = vim.api.nvim_set_hl

-- Editor UI
hi(0, "Normal",         { fg = "#BBBEBF", bg = "#121314" })
hi(0, "NormalFloat",    { fg = "#bfbfbf", bg = "#202122" })
hi(0, "FloatBorder",    { fg = "#2A2B2C", bg = "#202122" })
hi(0, "Cursor",         { fg = "#121314", bg = "#BBBEBF" })
hi(0, "CursorLine",     { bg = "#242526" })
hi(0, "CursorColumn",   { bg = "#242526" })
hi(0, "ColorColumn",    { bg = "#242526" })
hi(0, "LineNr",         { fg = "#858889" })
hi(0, "CursorLineNr",   { fg = "#BBBEBF" })
hi(0, "SignColumn",     { fg = "#858889", bg = "#121314" })
hi(0, "VertSplit",      { fg = "#2A2B2C", bg = "#121314" })
hi(0, "WinSeparator",   { fg = "#2A2B2C" })
hi(0, "StatusLine",     { fg = "#8C8C8C", bg = "#191A1B" })
hi(0, "StatusLineNC",   { fg = "#555555", bg = "#191A1B" })
hi(0, "TabLine",        { fg = "#8C8C8C", bg = "#191A1B" })
hi(0, "TabLineSel",     { fg = "#bfbfbf", bg = "#121314" })
hi(0, "TabLineFill",    { bg = "#191A1B" })
hi(0, "Folded",         { fg = "#8C8C8C", bg = "#242526" })
hi(0, "FoldColumn",     { fg = "#8C8C8C", bg = "#121314" })
hi(0, "NonText",        { fg = "#2A2B2C" })
hi(0, "Whitespace",     { fg = "#2A2B2C" })
hi(0, "SpecialKey",     { fg = "#2A2B2C" })
hi(0, "EndOfBuffer",    { fg = "#2A2B2C" })
hi(0, "MatchParen",     { bg = "#1E3D4F" })   -- #3994BC @ 33% on #121314
hi(0, "Visual",         { bg = "#1F4D5E" })   -- #276782 @ 87% on #121314
hi(0, "VisualNOS",      { bg = "#173848" })   -- #276782 @ 38% on #121314
hi(0, "Search",         { fg = "#BBBEBF", bg = "#1B4356" })  -- #276782 @ 56% on #121314
hi(0, "IncSearch",      { fg = "#121314", bg = "#48A0C7" })
hi(0, "CurSearch",      { fg = "#121314", bg = "#48A0C7" })
hi(0, "Substitute",     { fg = "#121314", bg = "#ffa657" })

-- Popups / menus
hi(0, "Pmenu",          { fg = "#bfbfbf", bg = "#202122" })
hi(0, "PmenuSel",       { fg = "#ededed", bg = "#1A3040" })  -- #3994BC @ 15% on #202122
hi(0, "PmenuSbar",      { bg = "#202122" })
hi(0, "PmenuThumb",     { bg = "#4A4B4C" })               -- #838485 @ 40% on #202122
hi(0, "WildMenu",       { fg = "#ededed", bg = "#1A3040" })

-- Messages / prompts
hi(0, "ErrorMsg",       { fg = "#f48771" })
hi(0, "WarningMsg",     { fg = "#e5ba7d" })
hi(0, "ModeMsg",        { fg = "#bfbfbf" })
hi(0, "MoreMsg",        { fg = "#48A0C7" })
hi(0, "Question",       { fg = "#48A0C7" })

-- Diagnostics
hi(0, "DiagnosticError",          { fg = "#f48771" })
hi(0, "DiagnosticWarn",           { fg = "#e5ba7d" })
hi(0, "DiagnosticInfo",           { fg = "#48A0C7" })
hi(0, "DiagnosticHint",           { fg = "#8C8C8C" })
hi(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#f48771" })
hi(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "#e5ba7d" })
hi(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "#48A0C7" })
hi(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "#8C8C8C" })

-- Diff
hi(0, "DiffAdd",        { bg = "#162B1A" })   -- #347d39 @ 15% on #121314
hi(0, "DiffChange",     { bg = "#5a1e02" })
hi(0, "DiffDelete",     { bg = "#2B1515" })   -- #c93c37 @ 15% on #121314
hi(0, "DiffText",       { bg = "#1E4A20" })   -- #57ab5a @ 30% on #121314
hi(0, "Added",          { fg = "#72C892" })
hi(0, "Changed",        { fg = "#ffa657" })
hi(0, "Removed",        { fg = "#F28772" })

-- Gutter signs
hi(0, "GitSignsAdd",    { fg = "#72C892", bg = "#121314" })
hi(0, "GitSignsChange", { fg = "#ffa657", bg = "#121314" })
hi(0, "GitSignsDelete", { fg = "#F28772", bg = "#121314" })

-- Syntax — token colors mapped from VS Code scopes
hi(0, "Comment",        { fg = "#8b949e", italic = true })
hi(0, "Constant",       { fg = "#79c0ff" })
hi(0, "String",         { fg = "#a5d6ff" })
hi(0, "Character",      { fg = "#ff7b72" })
hi(0, "Number",         { fg = "#79c0ff" })
hi(0, "Boolean",        { fg = "#79c0ff" })
hi(0, "Float",          { fg = "#79c0ff" })
hi(0, "Identifier",     { fg = "#ffa657" })
hi(0, "Function",       { fg = "#d2a8ff" })
hi(0, "Statement",      { fg = "#ff7b72" })
hi(0, "Keyword",        { fg = "#ff7b72" })
hi(0, "Conditional",    { fg = "#ff7b72" })
hi(0, "Repeat",         { fg = "#ff7b72" })
hi(0, "Label",          { fg = "#ff7b72" })
hi(0, "Operator",       { fg = "#ff7b72" })
hi(0, "Exception",      { fg = "#ff7b72" })
hi(0, "PreProc",        { fg = "#ff7b72" })
hi(0, "Include",        { fg = "#ff7b72" })
hi(0, "Define",         { fg = "#ff7b72" })
hi(0, "Macro",          { fg = "#79c0ff" })
hi(0, "Type",           { fg = "#ff7b72" })
hi(0, "StorageClass",   { fg = "#ff7b72" })
hi(0, "Structure",      { fg = "#ff7b72" })
hi(0, "Typedef",        { fg = "#ff7b72" })
hi(0, "Special",        { fg = "#7ee787" })
hi(0, "SpecialChar",    { fg = "#7ee787", bold = true })
hi(0, "Tag",            { fg = "#7ee787" })
hi(0, "Delimiter",      { fg = "#c9d1d9" })
hi(0, "SpecialComment", { fg = "#8b949e" })
hi(0, "Underlined",     { fg = "#a5d6ff", underline = true })
hi(0, "Error",          { fg = "#ffa198", italic = true })
hi(0, "Todo",           { fg = "#121314", bg = "#8b949e", bold = true })

-- Treesitter (nvim 0.8+ @-prefixed groups)
hi(0, "@comment",               { link = "Comment" })
hi(0, "@string",                { link = "String" })
hi(0, "@string.regex",          { fg = "#a5d6ff" })
hi(0, "@string.escape",         { fg = "#7ee787", bold = true })
hi(0, "@character",             { link = "Character" })
hi(0, "@number",                { link = "Number" })
hi(0, "@boolean",               { link = "Boolean" })
hi(0, "@float",                 { link = "Float" })
hi(0, "@function",              { fg = "#d2a8ff" })
hi(0, "@function.builtin",      { fg = "#79c0ff" })
hi(0, "@function.call",         { fg = "#d2a8ff" })
hi(0, "@method",                { fg = "#d2a8ff" })
hi(0, "@method.call",           { fg = "#d2a8ff" })
hi(0, "@constructor",           { fg = "#ffa657" })
hi(0, "@parameter",             { fg = "#c9d1d9" })
hi(0, "@keyword",               { fg = "#ff7b72" })
hi(0, "@keyword.function",      { fg = "#ff7b72" })
hi(0, "@keyword.operator",      { fg = "#ff7b72" })
hi(0, "@keyword.return",        { fg = "#ff7b72" })
hi(0, "@conditional",           { fg = "#ff7b72" })
hi(0, "@repeat",                { fg = "#ff7b72" })
hi(0, "@label",                 { fg = "#ff7b72" })
hi(0, "@operator",              { fg = "#ff7b72" })
hi(0, "@exception",             { fg = "#ff7b72" })
hi(0, "@include",               { fg = "#ff7b72" })
hi(0, "@type",                  { fg = "#ff7b72" })
hi(0, "@type.builtin",          { fg = "#ff7b72" })
hi(0, "@type.definition",       { fg = "#ffa657" })
hi(0, "@storageclass",          { fg = "#ff7b72" })
hi(0, "@namespace",             { fg = "#c9d1d9" })
hi(0, "@variable",              { fg = "#ffa657" })
hi(0, "@variable.builtin",      { fg = "#79c0ff" })
hi(0, "@constant",              { fg = "#79c0ff" })
hi(0, "@constant.builtin",      { fg = "#79c0ff" })
hi(0, "@field",                 { fg = "#79c0ff" })
hi(0, "@property",              { fg = "#79c0ff" })
hi(0, "@punctuation.delimiter", { fg = "#c9d1d9" })
hi(0, "@punctuation.bracket",   { fg = "#c9d1d9" })
hi(0, "@punctuation.special",   { fg = "#ff7b72" })
hi(0, "@tag",                   { fg = "#7ee787" })
hi(0, "@tag.attribute",         { fg = "#c9d1d9" })
hi(0, "@tag.delimiter",         { fg = "#c9d1d9" })
hi(0, "@text.strong",           { fg = "#c9d1d9", bold = true })
hi(0, "@text.emphasis",         { fg = "#c9d1d9", italic = true })
hi(0, "@text.underline",        { underline = true })
hi(0, "@text.strike",           { strikethrough = true })
hi(0, "@text.title",            { fg = "#79c0ff", bold = true })
hi(0, "@text.quote",            { fg = "#7ee787" })
hi(0, "@text.uri",              { fg = "#a5d6ff", underline = true })
hi(0, "@text.reference",        { fg = "#a5d6ff" })

-- LSP semantic tokens
hi(0, "@lsp.type.function",     { link = "@function" })
hi(0, "@lsp.type.method",       { link = "@method" })
hi(0, "@lsp.type.variable",     { link = "@variable" })
hi(0, "@lsp.type.parameter",    { link = "@parameter" })
hi(0, "@lsp.type.property",     { link = "@property" })
hi(0, "@lsp.type.class",        { fg = "#ffa657" })
hi(0, "@lsp.type.interface",    { fg = "#ffa657" })
hi(0, "@lsp.type.enum",         { fg = "#79c0ff" })
hi(0, "@lsp.type.enumMember",   { fg = "#79c0ff" })
hi(0, "@lsp.type.namespace",    { link = "@namespace" })
hi(0, "@lsp.type.keyword",      { link = "@keyword" })
hi(0, "@lsp.type.string",       { link = "@string" })
hi(0, "@lsp.type.number",       { link = "@number" })
hi(0, "@lsp.type.comment",      { link = "@comment" })
hi(0, "@lsp.type.operator",     { link = "@operator" })
hi(0, "@lsp.type.decorator",    { fg = "#d2a8ff" })
hi(0, "@lsp.type.macro",        { fg = "#79c0ff" })

-- nvim-cmp
hi(0, "CmpItemAbbr",            { fg = "#bfbfbf" })
hi(0, "CmpItemAbbrMatch",       { fg = "#48A0C7", bold = true })
hi(0, "CmpItemAbbrMatchFuzzy",  { fg = "#48A0C7" })
hi(0, "CmpItemKind",            { fg = "#8C8C8C" })
hi(0, "CmpItemMenu",            { fg = "#555555" })

-- Telescope
hi(0, "TelescopeBorder",        { fg = "#2A2B2C" })
hi(0, "TelescopePromptBorder",  { fg = "#3994BC" })
hi(0, "TelescopeSelection",     { bg = "#1A3040" })
hi(0, "TelescopeMatching",      { fg = "#48A0C7", bold = true })

-- indent-blankline
hi(0, "IblIndent",              { fg = "#2A2B2C" })
hi(0, "IblScope",               { fg = "#838485" })
