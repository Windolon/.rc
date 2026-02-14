-- unapologetically in justinmk's style.

vim.o.background = "light"

local augroup = vim.api.nvim_create_augroup("my.config", {})

-- https://github.com/neovim/neovim/blob/master/src/nvim/highlight_group.c#L2938
-- stylua: ignore
local colours = {
    NvimDarkBlue        = "#004c73",
    NvimDarkCyan        = "#007373",
    NvimDarkGray1       = "#07080d",
    NvimDarkGray2       = "#14161b",
    NvimDarkGray3       = "#2c2e33",
    NvimDarkGray4       = "#4f5258",
    NvimDarkGreen       = "#005523",
    NvimDarkGrey1       = "#07080d",
    NvimDarkGrey2       = "#14161b",
    NvimDarkGrey3       = "#2c2e33",
    NvimDarkGrey4       = "#4f5258",
    NvimDarkMagenta     = "#470045",
    NvimDarkRed         = "#590008",
    NvimDarkYellow      = "#6b5300",
    NvimLightBlue       = "#a6dbff",
    NvimLightCyan       = "#8cf8f7",
    NvimLightGray1      = "#eef1f8",
    NvimLightGray2      = "#e0e2ea",
    NvimLightGray3      = "#c4c6cd",
    NvimLightGray4      = "#9b9ea4",
    NvimLightGreen      = "#b3f6c0",
    NvimLightGrey1      = "#eef1f8",
    NvimLightGrey2      = "#e0e2ea",
    NvimLightGrey3      = "#c4c6cd",
    NvimLightGrey4      = "#9b9ea4",
    NvimLightMagenta    = "#ffcaff",
    NvimLightRed        = "#ffc0b9",
    NvimLightYellow     = "#fce094",
}
-- Lloyd's pharmacy.
local colors = colours

-- ================================
-- == General settings / options ==
-- ================================

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.loaded_netrwPlugin = 0 -- i have mini.files
vim.g.did_install_default_menus = 1 -- this looks like its mainly designed for the mouse, :h menu.vim

vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.pumheight = 10
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.list = true
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor"
vim.o.statusline = " " .. vim.o.statusline .. " "

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
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"

-- NOTE: guess-indent.nvim appears to control 'tabstop' and 'expandtab'
-- on a per-buffer basis (plugin mimics `detect_indentation` of https://www.sublimetext.com/docs/indentation.html)
-- We still set these two here for an overridable global default
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.smartindent = true

-- ===================
-- == Basic keymaps ==
-- ===================

-- see default binds with :h index

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "ö", "[", { remap = true })
vim.keymap.set("n", "ä", "]", { remap = true })

vim.keymap.set("n", "§", "<Cmd>restart<CR>", { desc = ":restart" })

-- <C-Left> and <C-Right> are aliases for B and W originally (i dont use them)
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- n:<C-c> by default maps to interrupting current command (<Esc> behaviour)
-- i:<C-c> by default maps to quitting insert mode w/o checking for abbr. (<Esc> behaviour)
vim.keymap.set({ "n", "i" }, "<C-c>", vim.snippet.stop, { desc = "Stop current snippet" })

-- <Tab> by default maps to <C-I>
-- i remap it here to provide a synced experience with neogit
vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle fold" })

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
    -- top level dependencies
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/nvim-lua/plenary.nvim",

    -- core editor behaviour
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/akinsho/toggleterm.nvim",
    "https://github.com/tpope/vim-obsession",
    "https://github.com/tpope/vim-surround",
    "https://github.com/tpope/vim-repeat",

    -- appearance
    "https://github.com/nanozuki/tabby.nvim",

    -- git
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/NeogitOrg/neogit",

    -- languages support
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mrcjkb/rustaceanvim",

    -- misc
    "https://github.com/nvim-mini/mini.misc",
})

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
    vim.keymap.set("n", "<leader>gg", "<Cmd>Neogit<CR>", { desc = "Show Neogit UI" })
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

local function config_terminal()
    -- stylua: ignore
    local highlights = vim.o.background == "light"
        and {
            Normal          = { guifg = "#545464", guibg = "#f2ecbc" }, -- kanagawa lotus
            StatusLine      = { guifg = colours.NvimDarkGrey2, guibg = colours.NvimLightGrey1 },
            StatusLineNC    = { guifg = colours.NvimDarkGrey3, guibg = colours.NvimLightGrey3 },
        }
        or {
            Normal          = { guifg = "#dcd7ba", guibg = "#1f1f28" }, -- kanagawa wave
            StatusLine      = { guifg = colours.NvimLightGrey2, guibg = colours.NvimDarkGrey1 },
            StatusLineNC    = { guifg = colours.NvimLightGrey3, guibg = colours.NvimDarkGrey3 },
        }
    require("toggleterm").setup({
        open_mapping = [[<C-ß>]],
        highlights = highlights,
        shade_terminals = false,
    })
end

-- Overrides some default highlight groups
local function config_colorscheme()
    -- stylua: ignore
    local highlights = vim.o.background == "light"
        and {
            StatusLine = { fg = colours.NvimDarkGrey2, bg = colours.NvimLightGrey1 },
        }
        or {
            StatusLine = { fg = colours.NvimLightGrey2, bg = colours.NvimDarkGrey1 },
        }

    for name, val in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, val)
    end
end

-- https://github.com/nanozuki/tabby.nvim/discussions/135
local function config_tabline()
    -- stylua: ignore
    local theme = vim.o.background == "light"
        and {
            current = { fg = colours.NvimDarkGrey2, bg = colours.NvimLightGrey1, style = "bold" },
            not_current = { fg = colours.NvimDarkGrey4, bg = colours.NvimLightGrey1 },
            fill = { bg = colours.NvimLightGrey1 },
        }
        or {
            current = { fg = colours.NvimLightGrey2, bg = colours.NvimDarkGrey1, style = "bold" },
            not_current = { fg = colours.NvimLightGrey4, bg = colours.NvimDarkGrey1 },
            fill = { bg = colours.NvimDarkGrey1 },
        }

    require("tabby.tabline").set(function(line)
        return {
            line.tabs().foreach(function(tab)
                local hl = tab.is_current() and theme.current or theme.not_current
                return {
                    line.sep(" ", hl, theme.fill),
                    tab.number(),
                    line.sep(" ", hl, theme.fill),
                    tab.name(),
                    line.sep(" ", hl, theme.fill),
                    hl = hl,
                }
            end),
            hl = theme.fill,
        }
    end)
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

-- This setup does not include rust-analyzer, see `config_rust()`
local function config_lsp()
    vim.lsp.inlay_hint.enable(true)

    vim.lsp.enable({
        -- cargo install emmylua_ls
        "emmylua_ls",
    })
end

-- rustup component add rust-analyzer
local function config_rust()
    vim.g.rustaceanvim = {
        server = {
            on_attach = function(client, bufnr)
                vim.keymap.set("n", "<leader>ra", function()
                    vim.cmd.RustLsp("codeAction")
                end, { silent = true, buffer = bufnr })

                vim.keymap.set("n", "K", function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                end, { silent = true, buffer = bufnr })
            end,

            default_settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        chainingHints = { enable = false },
                    },
                },
            },
        },
    }
end

-- Call this after config_lsp()
local function config_cmp()
    vim.o.completeopt = "menuone,popup,fuzzy"

    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Enables LSP completion",
        callback = function(args)
            vim.lsp.completion.enable(true, args.data.client_id, args.buf)
        end,
    })
end

local function config_formatters()
    require("conform").setup({
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" }, -- :checkhealth will complain if we are not in a venv, but its fine
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    })
end

local function config_diagnostics()
    vim.diagnostic.config({
        -- underline is true by default
        virtual_text = true,
    })
end

-- do this first
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

config_colorscheme()

require("mini.files").setup()
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Open mini.files explorer" })

config_fzf()
config_git()

require("guess-indent").setup({})

config_terminal()
require("mini.misc").setup_termbg_sync()
config_tabline()

config_treesitter()
config_lsp()
config_rust()
config_cmp()
config_folding()
config_formatters()
config_diagnostics()
