local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 60,
            on_visual = false,
        })
    end,
})

local strip_history_group = augroup("StripHistory", {})
autocmd({ "VimEnter", "CmdLineLeave" }, {
    group = strip_history_group,
    pattern = "*",
    callback = function()
        vim.fn.histdel(":", "\\m^\\(w\\|wq\\|qa\\?!\\?\\|b[npw]\\)$")
    end,
})
