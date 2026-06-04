local augroup = vim.api.nvim_create_augroup("my.config", {})

-- https://www.reddit.com/r/neovim/comments/1e9j6c0/are_providers_really_necessary/
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- :h 'optionname' describes in detail what the option does
-- Here I just provide "why" I set the option

-- Stops wrapping from messing up file layout
-- Also avoids unintuitive j / k navigation issues when a line is wrapped
vim.o.wrap = false
-- Makes window layout consistent regardless of gitsigns' presence
vim.o.signcolumn = "yes"
-- Easily distinguishes content between floating windows and the background
vim.o.winborder = "rounded"
-- Adds helper symbols to tabs and trailing spaces so they don't go unnoticed
vim.o.list = true
-- Stops cursor from blinking in terminal mode
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor"
-- Aesthetics
vim.o.laststatus = 3
-- Persistent undo history
vim.o.undofile = true
-- Some plugins benefit from a lower updatetime for better perceptual performance
-- I haven't encountered any lags or glitches with this set at 250
-- Modern hardware should be able to handle this no problem
vim.o.updatetime = 250
-- tabby.nvim needs `globals` to be in `sessionoptions` to save tab names
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal,globals"
-- guess-indent.nvim appears to control 'tabstop' and 'expandtab' on a per-buffer basis
-- (plugin mimics `detect_indentation` of https://www.sublimetext.com/docs/indentation.html)
-- We still set these two here for an overridable global default
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.smartindent = true

-- Just habits and ergonomics that I got used to
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.scrolloff = 10
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.spelllang = { "en", "de" } -- :h spell
vim.api.nvim_create_autocmd("UIEnter", {
    group = augroup,
    desc = "Syncs clipboard between OS and Neovim",
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})

-- :h index lists default keybinds

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "ö", "[", { remap = true })
vim.keymap.set("n", "ä", "]", { remap = true })

vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set({ "n", "i" }, "<C-c>", vim.snippet.stop, { desc = "Stop current snippet" })

-- Default keybinds with improved behaviour
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.pack.add({
    -- Top level dependencies
    "https://github.com/nvim-mini/mini.icons",

    -- Appearance
    "https://github.com/rktjmp/lush.nvim",
    "https://github.com/zenbones-theme/zenbones.nvim",
    "https://github.com/nanozuki/tabby.nvim",

    -- Core editor behaviour
    "https://github.com/nvim-mini/mini.files",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/akinsho/toggleterm.nvim",
    "https://github.com/tpope/vim-obsession",
    "https://github.com/tpope/vim-surround",
    "https://github.com/tpope/vim-repeat",

    -- Git
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/dlyongemallo/diffview-plus.nvim",
    "https://github.com/NeogitOrg/neogit",

    -- General languages
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",

    -- Specific languages
    "https://github.com/mrcjkb/rustaceanvim",
})

local function setup_zenbones()
    vim.cmd("colorscheme zenwritten")

    local lush = require("lush")
    local base = require("zenwritten")

    local specs = lush.parse(function()
        return {
            ---@diagnostic disable-next-line: undefined-global
            StatusLine({ base.Normal }),
        }
    end)

    lush.apply(lush.compile(specs))
end

-- https://github.com/nanozuki/tabby.nvim/discussions/135
local function setup_tabby()
    local base = require("zenwritten")
    local theme = {
        current = { fg = base.Normal.fg.hex, bg = base.Normal.bg.hex, style = "bold" },
        not_current = { fg = base.LineNr.fg.hex, bg = base.Normal.bg.hex },
        fill = { bg = base.Normal.bg.hex },
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

local function setup_minifiles()
    require("mini.files").setup()
    ---@diagnostic disable-next-line: undefined-global
    vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Open mini.files explorer" })
end

local function setup_fzf()
    require("fzf-lua").setup({
        fzf_colors = true,
    })
    vim.keymap.set("n", "<leader>fb", FzfLua.buffers, { desc = "Fuzzy find open buffers" })
    vim.keymap.set("n", "<leader>ff", FzfLua.files, { desc = "Fuzzy find files" })
    vim.keymap.set("n", "<leader>fg", FzfLua.live_grep, { desc = "Live grep current project" })
    vim.keymap.set("n", "<leader>fs", FzfLua.lsp_document_symbols, { desc = "Fuzzy find document symbols" })
    vim.keymap.set("n", "<leader>fh", FzfLua.help_tags, { desc = "Fuzzy find Neovim help tags" })
end

local function setup_toggleterm()
    require("toggleterm").setup({
        open_mapping = "<C-ß>",
        shade_terminals = false,
    })
end

local function setup_gitsigns()
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end)

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
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

local function setup_treesitter()
    -- Usually, only this table should be modified e.g. adding / removing languages
    local filetypes = {
        "gitcommit",
        "json",
        "lua",
        "rust",
        "squirrel",
        "toml",
    }

    require("nvim-treesitter").install(filetypes)
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        desc = "Starts treesitter for supported filetypes",
        pattern = filetypes,
        callback = function()
            vim.treesitter.start()
        end,
    })
    require("treesitter-context").setup({
        max_lines = 5,
    })
end

local function setup_folding()
    -- Use LSP folding if the client supports it, otherwise use treesitter folding
    -- Taken from :h vim.lsp.foldexpr()
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- Don't fold anything on buffer open
    vim.o.foldlevel = 99
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Configures LSP folding if the client supports it",
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            -- This is an LspAttach autocmd, `client` is guaranteed to exist
            ---@diagnostic disable-next-line: need-check-nil
            if client:supports_method("textDocument/foldingRange") then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
            end
        end,
    })
end

-- This setup does not include rust-analyzer, see `setup_rustaceanvim()`
local function setup_lsp()
    vim.lsp.inlay_hint.enable(true)

    vim.lsp.enable({
        -- cargo install emmylua_ls
        "emmylua_ls",
    })
end

local function setup_rustaceanvim()
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

local function setup_autocompletion()
    vim.o.completeopt = "menuone,popup,fuzzy"
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        desc = "Enables LSP completion",
        callback = function(args)
            vim.lsp.completion.enable(true, args.data.client_id, args.buf)
        end,
    })
end

local function setup_conform()
    require("conform").setup({
        formatters_by_ft = {
            lua = { "stylua" },
        },
        format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
        },
    })
end

require("mini.icons").setup()
setup_zenbones()
setup_minifiles()
setup_fzf()
setup_gitsigns()
vim.keymap.set("n", "<leader>gg", "<Cmd>Neogit<CR>", { desc = "Open Neogit UI" })
require("guess-indent").setup({})
setup_toggleterm()
setup_tabby()
setup_treesitter()
setup_lsp()
setup_rustaceanvim()
setup_autocompletion()
setup_folding()
setup_conform()
vim.diagnostic.config({ virtual_text = true })
