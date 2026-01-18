-- unapologetically in justinmk's style.

local augroup = vim.api.nvim_create_augroup("my.config", {})

-- ================================
-- == General settings / options ==
-- ================================

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.loaded_netrwPlugin = 0 -- i have mini.files
vim.g.did_install_default_menus = 1 -- this looks like its mainly designed for the mouse, :h menu.vim

vim.o.breakindent = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.pumheight = 10
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.list = true
vim.o.background = "light"

vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 30
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.confirm = true
vim.o.mouse = "a"
-- taken from example_init.lua
vim.api.nvim_create_autocmd("UIEnter", {
    group = augroup,
    desc = "Syncs clipboard between OS and Neovim",
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.opt.spelllang = { "en", "de" } -- :h spell
vim.o.expandtab = true

-- ===================
-- == Basic keymaps ==
-- ===================

-- see default binds with :h index

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "ö", "[", { remap = true })
vim.keymap.set("n", "ä", "]", { remap = true })

vim.keymap.set("n", "<leader>nr", "<Cmd>restart<CR>", { desc = ":restart" })

vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Turn off highlighting until the next search" })

-- <C-Left> and <C-Right> are aliases for B and W originally (i dont use them)
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- n:<C-c> by default maps to interrupting current command (<Esc> behaviour)
-- i:<C-c> by default maps to quitting insert mode w/o checking for abbr. (<Esc> behaviour)
vim.keymap.set({ "n", "i" }, "<C-c>", vim.snippet.stop, { desc = "Stop current snippet" })

-- default keymaps with improved behaviour
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
-- taken from lazyvim
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.pack.add({
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/nvim-mini/mini.files",

    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/lewis6991/gitsigns.nvim",
    -- NOTE: cd to plugin dir and run `cargo build --release` after updating/installing
    "https://github.com/saghen/blink.cmp",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/rmagatti/auto-session",
    "https://github.com/akinsho/toggleterm.nvim",

    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
})

local function config_mini()
    require("mini.icons").setup()
    MiniIcons.mock_nvim_web_devicons()

    require("mini.files").setup()
    vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Open mini.files explorer" })
end

-- Use LSP folding if the client supports it, otherwise use treesitter folding
-- Taken from :h vim.lsp.foldexpr()
local function config_folding()
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.o.foldlevel = 99 -- dont fold anything on buffer open
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Configures LSP folding if the client supports it",
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            -- this is an LspAttach autocmd, `client` is guaranteed to exist
            ---@diagnostic disable-next-line: need-check-nil
            if client:supports_method("textDocument/foldingRange") then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            end
        end,
    })
end

local function config_git()
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]h", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end)

            map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[h", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end)

            -- Actions
            map("n", "<leader>hs", gitsigns.stage_hunk)
            map("n", "<leader>hr", gitsigns.reset_hunk)

            map("v", "<leader>hs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)

            map("v", "<leader>hr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end)

            map("n", "<leader>hS", gitsigns.stage_buffer)
            map("n", "<leader>hR", gitsigns.reset_buffer)
            map("n", "<leader>hp", gitsigns.preview_hunk)
            map("n", "<leader>hi", gitsigns.preview_hunk_inline)

            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end)

            map("n", "<leader>hd", gitsigns.diffthis)

            map("n", "<leader>hD", function()
                gitsigns.diffthis("~")
            end)

            map("n", "<leader>hQ", function()
                gitsigns.setqflist("all")
            end)
            map("n", "<leader>hq", gitsigns.setqflist)

            -- Toggles
            map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
            map("n", "<leader>tw", gitsigns.toggle_word_diff)

            -- Text object
            map({ "o", "x" }, "ih", gitsigns.select_hunk)
        end,
    })
end

local function config_fzf()
    require("fzf-lua").setup({
        fzf_colors = true,
    })
    vim.keymap.set("n", "<leader>fb", FzfLua.buffers, { desc = "Fuzzy find open buffers" })
    vim.keymap.set("n", "<leader>ff", FzfLua.files, { desc = "Fuzzy find files" })
    vim.keymap.set("n", "<leader>fg", FzfLua.live_grep, { desc = "Live grep current project" })
    vim.keymap.set("n", "<leader>fs", FzfLua.lsp_document_symbols, { desc = "Fuzzy find document symbols" })
    vim.keymap.set("n", "<leader>fh", FzfLua.help_tags, { desc = "Fuzzy find Neovim help tags" })
end

local function config_toggleterm()
    -- stylua: ignore
    local normal = vim.o.background == "light"
        and { guifg = "#545464", guibg = "#f2ecbc" }
        or  { guifg = "#dcd7ba", guibg = "#1f1f28" }
    -- TODO: improve terminal colours (statuslines, etc.)
    require("toggleterm").setup({
        open_mapping = [[<C-ß>]],
        highlights = {
            Normal = normal,
        },
        shade_terminals = false,
    })
end

local function config_treesitter()
    -- i dont mind my lamb chops well done.
    require("nvim-treesitter").install({ "all" })
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        desc = "Starts treesitter if the filetype is supported",
        callback = function()
            -- there is still a chance that this will error so we wrap it in a pcall
            pcall(vim.treesitter.start)
        end,
    })
end

local function config_lsp()
    vim.lsp.inlay_hint.enable(true)

    vim.lsp.config("rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                inlayHints = {
                    -- i agree with you maria
                    chainingHints = { enable = false },
                },
            },
        },
    })

    vim.lsp.enable({
        -- cargo install emmylua_ls
        "emmylua_ls",
        -- rustup component add rust-analyzer
        "rust_analyzer",
    })
end

local function config_blink()
    require("blink.cmp").setup({
        appearance = {
            nerd_font_variant = "normal",
        },
        completion = {
            accept = { auto_brackets = { enabled = false } },
        },
    })
end

local function config_format_on_write()
    require("conform").setup({
        formatters_by_ft = {
            lua = { "stylua" },
            -- :checkhealth will complain if we are not in a venv, but its fine
            python = { "black" },
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    })
end

local function config_diagnostics()
    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = "󰋽 ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
        },
        -- underline is true by default
    })
end

-- do this first
config_mini()

config_fzf()
config_git()

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup()
vim.keymap.set("n", "<leader>fo", "<Cmd>AutoSession search<CR>", { desc = "Fuzzy find Neovim sessions" })

require("guess-indent").setup({})
config_toggleterm()

config_treesitter()
config_lsp()
config_folding()
config_blink()
config_format_on_write()
config_diagnostics()
