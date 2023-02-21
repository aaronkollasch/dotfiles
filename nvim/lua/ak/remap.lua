vim.g.mapleader = " "

-- open Ex
vim.keymap.set("n", "<leader>lv", vim.cmd.Ex, { desc = "[L]ocal  [V]iew" })

-- press <CR> to hide search results
vim.keymap.set("n", "<CR>", ":noh<CR><CR>:<backspace>")

-- Move cursor to middle of screen after C-d and C-u
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-S-d>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-e>", "<C-u>zz")

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
vim.keymap.set("n", "Y", "yy")

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

-- <leader>x to execute line, <leader><leader>x to execute file
vim.cmd([[
" Map execute this line
function! s:executor() abort
  if &ft == 'lua'
    call execute(printf(":lua %s", getline(".")))
  elseif &ft == 'vim'
    exe getline(">")
  endif
endfunction
nnoremap <leader>x :call <SID>executor()<CR>
vnoremap <leader>x :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>
" Execute this file
nnoremap <leader><leader>x :call ak#save_and_exec()<CR>
]])

-- <leader>b keys to change buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "[B]uffer [N]ext" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { silent = true, desc = "[B]uffer [P]revious" })

-- <leader>n keys to jump
vim.keymap.set("n", "<leader>n",  "]",  { desc = "Next,     alias of ]", remap = true })
vim.keymap.set("n", "<leader>N",  "[",  { desc = "Previous, alias of [", remap = true })
vim.keymap.set("n", "<S-Space>N", "[",  { desc = "Previous, alias of [", remap = true })

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
vim.keymap.set("n", "<leader>\\", ":bel vsplit<CR>", { silent = true, desc = "Split Vertically" })
vim.keymap.set("n", "<C-\\>",     ":bel vsplit<CR>", { silent = true, desc = "Split Vertically" })
vim.keymap.set("n", "<leader>-",  ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-->",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-_>",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-'>",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<leader>=",  ":ZoomToggle<CR>", { silent = true, desc = "Toggle window zoom" })
vim.keymap.set("n", "<C-=>",      ":ZoomToggle<CR>", { silent = true, desc = "Toggle window zoom" })
