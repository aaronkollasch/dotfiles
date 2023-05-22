--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width > 0 and win_width < hide_width then
            return ""
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
        end
        return str
    end
end

local function window()
    return vim.api.nvim_win_get_number(0)
end

local options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
        statusline = {},
        winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
    },
}

if not require("ak.opts").icons_enabled then
    options.icons_enabled = false
    options.component_separators = { left = "", right = "" }
    options.section_separators = { left = "", right = "" }
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        local noice = require("noice")
        return {
            options = options,
            sections = {
                lualine_a = {
                    { "mode", fmt = trunc(80, 1, 0, true) },
                },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        color = function()
                            return { gui = vim.bo.modified and "bold" or "" }
                        end,
                    },
                    {
                        "navic",
                        navic_opts = {
                            separator = require("ak.opts").icons_enabled and "  " or "│",
                            depth_limit = 3,
                            depth_limit_align = "left",
                        },
                        fmt = trunc(180, 50, 120, true),
                    },
                },
                lualine_x = {
                    {
                        "%S",
                        color = { fg = "#ff9e64" },
                    },
                    {
                        noice.api.statusline.mode.get,
                        cond = function()
                            return noice.api.statusline.mode.has()
                                and not string.find(noice.api.statusline.mode.get(), "^%-%-")
                        end,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        function()
                            local icon = require("ak.opts").icons_enabled and "{}" or "c"
                            return icon .. "%3{codeium#GetStatusString()}"
                        end,
                        cond = function()
                            return vim.api.nvim_get_mode().mode ~= "c"
                        end,
                        color = { fg = "#276abc" },
                    },
                    -- stylua: ignore
                    {
                        function()
                            local icon = require("ak.opts").icons_enabled and " " or "d"
                            return icon .. require("dap").status()
                        end,
                        cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
                        color = { fg = "#be7e05" },
                    },
                    {
                        "encoding",
                        cond = function()
                            return vim.o.fileencoding ~= "utf-8"
                        end,
                    },
                    {
                        "fileformat",
                        cond = function()
                            return vim.o.fileformat ~= "unix"
                        end,
                    },
                    "filetype",
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = { window },
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {
                "trouble",
                "lazy",
                "neo-tree",
                "toggleterm",
                "fugitive",
                "quickfix",
                -- not installed:
                -- "nvim-dap-ui",
                -- "aerial",
                -- "symbols-outline",
                -- "fzf",
            },
        }
    end,
}
