local M = {}

local defaults = {
	name = "achitek",
	cmd = { "achitek-ls" },
	filetypes = { "achitekfile", "tera" },
	root_markers = { { "Achitekfile", "achitekfile" }, ".git" },
	single_file_support = true,
}

local function command_exists(cmd)
	local executable = cmd and cmd[1]

	if type(executable) ~= "string" or executable == "" then
		return false
	end

	if executable:sub(1, 1) == "/" then
		return vim.fn.executable(executable) == 1
	end

	return vim.fn.executable(executable) == 1
end

local function root_dir(markers)
	local util = require("lspconfig.util")
	local flattened = {}

	for _, marker in ipairs(markers) do
		if type(marker) == "table" then
			vim.list_extend(flattened, marker)
		else
			table.insert(flattened, marker)
		end
	end

	return function(fname)
		return util.root_pattern(unpack(flattened))(fname) or vim.fn.getcwd()
	end
end

local function setup_with_vim_lsp(name, config)
	vim.lsp.config(name, {
		cmd = config.cmd,
		filetypes = config.filetypes,
		root_markers = config.root_markers,
		single_file_support = config.single_file_support,
		settings = config.settings,
		init_options = config.init_options,
	})

	if command_exists(config.cmd) then
		vim.lsp.enable(name)
	else
		vim.schedule(function()
			vim.notify(
				"achitek.nvim: achitek-ls was not found on PATH; install it or configure lsp.cmd",
				vim.log.levels.WARN
			)
		end)
	end
end

local function setup_with_lspconfig(name, config)
	local lspconfig = require("lspconfig")
	local configs = require("lspconfig.configs")

	if not configs[name] then
		configs[name] = {
			default_config = {
				cmd = config.cmd,
				filetypes = config.filetypes,
				root_dir = root_dir(config.root_markers),
				single_file_support = config.single_file_support,
				settings = config.settings,
				init_options = config.init_options,
			},
		}
	end

	if command_exists(config.cmd) then
		lspconfig[name].setup(config)
	else
		vim.schedule(function()
			vim.notify(
				"achitek.nvim: achitek-ls was not found on PATH; install it or configure lsp.cmd",
				vim.log.levels.WARN
			)
		end)
	end
end

function M.setup(opts)
	local config = vim.tbl_deep_extend("force", defaults, opts or {})
	local name = config.name

	if vim.lsp and vim.lsp.config and vim.lsp.enable then
		setup_with_vim_lsp(name, config)
	else
		setup_with_lspconfig(name, config)
	end
end

return M
