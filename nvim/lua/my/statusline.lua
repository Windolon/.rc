-- Inspired by the Neovim :: M Λ C R O statusline
-- https://github.com/Bekaboo/dot/blob/master/.config/nvim/lua/plugin/statusline.lua

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
    normal_fg = utils.get_highlight("Normal").fg,
    statusline_bg = utils.get_highlight("StatusLine").bg,
    git_add = utils.get_highlight("GitSignsAdd").fg,
    git_del = utils.get_highlight("GitSignsDelete").fg,
    git_change = utils.get_highlight("GitSignsChange").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
}

require("heirline").load_colors(colors)

-- ================
-- == Components ==
-- ================

local Space = { provider = " " }
local Align = { provider = "%=" }

local ViMode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        -- stylua: ignore
        mode_names = {
            n          = "NO",
            no         = "OP",
            nov        = "OC",
            noV        = "OL",
            ["no\x16"] = "OB",
            ["\x16"]   = "VB",
            niI        = "IN",
            niR        = "RE",
            niV        = "RV",
            nt         = "NT",
            ntT        = "TM",
            v          = "VI",
            vs         = "VI",
            V          = "VL",
            Vs         = "VL",
            ["\x16s"]  = "VB",
            s          = "SE",
            S          = "SL",
            ["\x13"]   = "SB",
            i          = "IN",
            ic         = "IC",
            ix         = "IX",
            R          = "RE",
            Rc         = "RC",
            Rx         = "RX",
            Rv         = "RV",
            Rvc        = "RC",
            Rvx        = "RX",
            c          = "CO",
            cv         = "CV",
            r          = "PR",
            rm         = "PM",
            ["r?"]     = "P?",
            ["!"]      = "SH",
            t          = "TE",
        },
    },
    provider = function(self)
        return " " .. self.mode_names[self.mode] .. " "
    end,
    hl = { fg = "statusline_bg", bg = "normal_fg" },
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = function()
            vim.defer_fn(vim.cmd.redrawstatus, 1000)
        end,
    },
}

local FileIcon = {
    init = function(self)
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local FileName = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
    provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
            return "[No Name]"
        end
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
}

-- dont put preceding space before this component
local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = " [+]",
    },
    {
        condition = function()
            return not vim.bo.modifiable
        end,
        provider = " [-]",
    },
    {
        condition = function()
            return vim.bo.readonly
        end,
        provider = " [RO]",
    },
}

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    {
        provider = function(self)
            return "(#" .. self.status_dict.head .. ", +"
        end,
    },
    {
        provider = function(self)
            return self.status_dict.added or 0
        end,
        hl = { fg = "git_add" },
    },
    { provider = "-" },
    {
        provider = function(self)
            return self.status_dict.removed or 0
        end,
        hl = { fg = "git_del" },
    },
    { provider = "~" },
    {
        provider = function(self)
            return self.status_dict.changed or 0
        end,
        hl = { fg = "git_change" },
    },
    { provider = ")" },
}

local Diagnostics = {
    condition = conditions.has_diagnostics,

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR]
        self.warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN]
        self.info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO]
        self.hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT]
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
        provider = function(self)
            return self.errors > 0 and self.error_icon
        end,
        hl = { fg = "diag_error" },
    },
    {
        provider = function(self)
            return self.errors > 0 and (self.errors .. " ")
        end,
    },
    {
        provider = function(self)
            return self.warnings > 0 and self.warn_icon
        end,
        hl = { fg = "diag_warn" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warnings .. " ")
        end,
    },
    {
        provider = function(self)
            return self.info > 0 and self.info_icon
        end,
        hl = { fg = "diag_info" },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info .. " ")
        end,
    },
    {
        provider = function(self)
            return self.hints > 0 and self.hint_icon
        end,
        hl = { fg = "diag_hint" },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hints .. " ")
        end,
    },
}

local Ruler = {
    provider = "%6(%l:%c%) %P",
}

local TerminalName = {
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
    end,
}

local HelpIcon = {
    condition = conditions.is_active,
    provider = "󰘥 ",
}

local HelpFileName = {
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
}

-- ===============================================
-- == Lines for different buffer / window types ==
-- ===============================================

-- stylua: ignore
local Default = {
    ViMode, Space, FileIcon, FileName, FileFlags, Space, Git, Align,
    Diagnostics, Ruler, Space,
}

-- stylua: ignore
local Inactive = {
    condition = conditions.is_not_active,

    Space, FileName, FileFlags, Align,
    Ruler, Space
}

-- stylua: ignore
local Terminal = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "terminal" } })
    end,

    { condition = conditions.is_active, ViMode }, Space, TerminalName, Align,
}

-- stylua: ignore
local Help = {
    condition = function()
        return conditions.buffer_matches({ buftype = { "help" } })
    end,

    { condition = conditions.is_active, ViMode }, Space, HelpIcon, HelpFileName, FileFlags, Align,
}

local StatusLines = {
    hl = function()
        if conditions.is_active() then
            return "StatusLine"
        else
            return "StatusLineNC"
        end
    end,

    fallthrough = false,

    Help,
    Terminal,
    Inactive,
    Default,
}

require("heirline").setup({ statusline = StatusLines })
