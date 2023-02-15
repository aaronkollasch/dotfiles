vim.g.mapleader = " "

-- open Ex
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "[P]roject [V]iew" })

-- press <CR> to hide search results
vim.keymap.set("n", "<CR>", ":noh<CR><CR>:<backspace>")

-- Move cursor to middle of screen after C-d and C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-S-d>", "<C-u>zz")
vim.keymap.set("n", "<C-e>", "<C-u>zz")

-- move cursor to center of screen when searching, and expand folds
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result (expand folds)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous result (expand folds)" })

-- Reselect visual selection after indenting
vim.cmd([[ vnoremap < <gv ]])
vim.cmd([[ vnoremap > >gv ]])

-- move highlighted blocks of text with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- make cursor stay in place when using J
vim.keymap.set("n", "J", "mzJ`z")

-- make Y = yy, not y$
-- for ergonomics and consistency with S, V, and <leader>Y
-- see https://vi.stackexchange.com/a/6135
vim.keymap.del("n", "Y")

-- Alt-Backspace to delete word in insert mode
vim.keymap.set("i", "<M-BS>", '<Esc>vb"_c')
vim.keymap.set("c", "<M-BS>", "<C-w>")

-- <leader>y to yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank line to system clipboard" })

-- <leader>d to delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[D]elete to void" })

-- <leader>s to begin replacement with current word
vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "[S]ubstitute current word" }
)

-- <leader>x to make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file e[X]ecutable" })

-- <leader>b keys to change buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "[B]uffer [P]revious" })

-- <leader><number> to move to window
for i = 1, 6 do
    local lhs = "<Leader>" .. i
    local rhs = i .. "<C-W>w"
    vim.keymap.set("n", lhs, rhs, { desc = "Move to Window " .. i })
end

-- Emacs-style keymaps
vim.keymap.set("c", "<C-A>", "<Home>")
vim.keymap.set("c", "<C-E>", "<End>")

-- window splitting
vim.keymap.set("n", "<C-\\>", ":vsplit<CR>", { silent = true, desc = "Split Vertically" })
vim.keymap.set("n", "<C-_>", ":split<CR>", { silent = true, desc = "Split Vertically" })
