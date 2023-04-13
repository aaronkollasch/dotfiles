local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local yank_group = augroup("CustomYank", {})
autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 60,
            on_macro = false,
            on_visual = true,
        })
    end,
})
local function return_to_y_mark()
    if vim.v.event.operator == "y" or vim.v.event.operator == "Y" then
        vim.api.nvim_feedkeys("g`y", "n", true)
    end
end
autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = return_to_y_mark,
})

local strip_history_group = augroup("StripHistory", {})
autocmd({ "VimEnter", "CmdLineLeave" }, {
    group = strip_history_group,
    pattern = "*",
    callback = function()
        vim.fn.histdel(":", "\\m^\\(w\\|wq\\|qa\\?!\\?\\|x\\|xa\\?!\\?\\|b[npw]\\)$")
    end,
})

local persist_buffer_group = augroup("PersistBuffer", {
    clear = false,
})
local persist_buffer = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.fn.setbufvar(bufnr, "bufpersist", 1)
end
autocmd({ "BufRead" }, {
    group = persist_buffer_group,
    pattern = { "*" },
    callback = function()
        autocmd({ "InsertEnter", "BufModifiedSet" }, {
            buffer = 0,
            once = true,
            callback = function()
                persist_buffer()
            end,
        })
    end,
})
