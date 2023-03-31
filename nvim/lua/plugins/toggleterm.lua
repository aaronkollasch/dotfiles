local function config()
    function _G.set_toggleterm_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("n", "q", "<cmd>ToggleTerm<CR>", opts)
    end

    vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_toggleterm_keymaps()")

    require("toggleterm").setup({
        size = function(term)
            if term.direction == "horizontal" then
                return vim.o.lines * 0.4
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
    })
end

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
        { "<leader>tt", "<cmd>0ToggleTerm direction=float<cr>",      desc = "[T]oggle [T]erm 0 (float)" },
        { "<leader>tf", "<cmd>0ToggleTerm direction=float<cr>",      desc = "[T]oggle Term 0 ([F]loat)" },
        { "<leader>th", "<cmd>0ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term 0 ([H]orizontal)" },
        { "<leader>tv", "<cmd>0ToggleTerm direction=vertical<cr>",   desc = "[T]oggle Term 0 ([V]ertical)" },
        { "<leader>t0", "<cmd>0ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term [0]" },
        { "<leader>t1", "<cmd>1ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term [1]" },
        { "<leader>t2", "<cmd>2ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term [2]" },
        { "<leader>t3", "<cmd>3ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term [3]" },
        { "<leader>t4", "<cmd>4ToggleTerm direction=horizontal<cr>", desc = "[T]oggle Term [4]" },
        { "<leader>ta", "<cmd>ToggleTermToggleAll<cr>",              desc = "[T]oggle [A]ll terminals" },
    },
    config = config,
}
