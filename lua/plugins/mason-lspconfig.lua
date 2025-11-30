return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		"pyrefly",
		"gopls",
		"bashls",
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	handlers = {
		function(server_name)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig[server_name].setup({
				capabilities = capabilities,
			})
		end,
	},
}
