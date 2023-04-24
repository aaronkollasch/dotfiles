-- Do not load up plugin when in diff mode.
if vim.opt.diff:get() then
    return {}
end

return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local feedkeys = vim.api.nvim_feedkeys

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]g", function()
                if vim.wo.diff then
                    return "]g"
                end
                gs.next_hunk()
                vim.schedule(function()
                    feedkeys("zz", "n", false)
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Next git hunk" })

            map("n", "[g", function()
                if vim.wo.diff then
                    return "[g"
                end
                gs.prev_hunk()
                vim.schedule(function()
                    feedkeys("zz", "n", false)
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Previous git hunk" })

            -- Actions
            -- stylua: ignore start
            map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "[H]unk [S]tage" })
            map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "[H]unk [R]eset" })
            map("n",          "<leader>hS", gs.stage_buffer,            { desc = "[H]unk [S]tage buffer" })
            map("n",          "<leader>hu", gs.undo_stage_hunk,         { desc = "[H]unk [U]ndo stage" })
            map("n",          "<leader>hU", function()
                os.execute("git restore --staged " .. vim.fn.expand("%"))
                gs.refresh()
            end,                                                        { desc = "[H]unk [U]ndo all staged" })
            map("n",          "<leader>hR", gs.reset_buffer,            { desc = "[H]unk [R]eset buffer" })
            map("n",          "<leader>hp", gs.preview_hunk,            { desc = "[H]unk [P]review" })
            map("n",          "<leader>hb", function()
                gs.blame_line({ full = true })
            end,                                                        { desc = "[H]unk [B]lame line" })
            map("n",          "<leader>hd", gs.diffthis,                { desc = "[H]unk [D]iff index" })
            map("n",          "<leader>hD", function()
                gs.diffthis("~")
            end,                                                        { desc = "[H]unk [D]iff parent" })
            -- map("n", "<leader>td", gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })
            -- stylua: ignore end

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "git hunk" })
        end,
    },
}
