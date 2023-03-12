vim.g.mapleader = " "

-- open Ex
vim.keymap.set("n", "<leader>lv", vim.cmd.Ex, { desc = "[L]ocal  [V]iew" })

-- press <CR> to hide search results
vim.keymap.set("n", "<CR>", ":noh<CR><CR>:<backspace>", { desc = "Clear search and next line" })

-- Move cursor to middle of screen after C-d and C-u
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-S-d>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-e>", "<C-u>zz")

-- move cursor to center of screen when searching, and expand folds
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result (expand folds)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous result (expand folds)" })

-- Reselect visual selection after indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- move highlighted blocks of text with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down one line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up one line" })

-- make cursor stay in place when using J, y, and Y
vim.keymap.set("n", "J", [[ "mz" . v:count . "J`z" ]], { expr = true, desc = "Join lines" })
vim.cmd([[ nnoremap <expr> y "my\"" . v:register . "y" ]])
vim.cmd([[ nnoremap <expr> Y "my\"" . v:register . "y$" ]])
vim.cmd([[ vnoremap <expr> y "my\"" . v:register . "y" ]])
vim.cmd([[ vnoremap <expr> Y "my\"" . v:register . "Y" ]])

-- move by terminal rows, not lines, unless a count is provided
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Alt-Backspace to delete word in insert mode
vim.keymap.set("i", "<M-BS>", '<Esc>vb"_c')
vim.keymap.set("c", "<M-BS>", "<C-w>")

-- <leader>y to yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [[my"+y]], { desc = "[Y]ank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [[my"+Y]], { desc = "[Y]ank line to system clipboard" })
vim.keymap.set("n", "<S-Space>Y", [[my"+Y]], { desc = "[Y]ank line to system clipboard" })

-- <leader>d to delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[D]elete to void" })

-- <leader>p to replace with register
vim.keymap.set("n", "<leader>p",  "<Plug>ReplaceWithRegisterOperator", { desc = "[P]aste from register (operator)" })
vim.keymap.set("n", "<leader>pp", "<Plug>ReplaceWithRegisterLine",     { desc = "[P]aste line from register" })
vim.keymap.set("x", "<leader>p",  "<Plug>ReplaceWithRegisterVisual",   { desc = "[P]aste from register" })

-- <leader>v to replace with system clipboard
vim.keymap.set("n", "<leader>v",  '"+<Plug>ReplaceWithRegisterOperator', { desc = "[P]aste from clipboard (operator)" })
vim.keymap.set("n", "<leader>vv", '"+<Plug>ReplaceWithRegisterLine',     { desc = "[P]aste line from clipboard" })
vim.keymap.set("x", "<leader>v",  '"+<Plug>ReplaceWithRegisterVisual',   { desc = "[P]aste from clipboard" })

-- <leader>s to begin replacement with current word
vim.keymap.set(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "[S]ubstitute current word" }
)

-- <leader>x to execute line, <leader><leader>x to execute file
vim.keymap.set("n", "<leader>x", function ()
  vim.cmd([[
    if &ft == 'lua'
      call execute(printf(":lua %s", getline(".")))
    elseif &ft == 'vim'
      exe getline(">")
    endif
  ]])
end, { desc = "Execute this line" })
vim.keymap.set("v", "<leader>x", function ()
  vim.cmd([[
    if &ft == 'lua'
      " call execute(printf(":lua %s", getline(".")))
    elseif &ft == 'vim'
      exe join(getline("'<","'>"),'<Bar>')
    endif
  ]])
end, { desc = "Execute selection" })
vim.keymap.set("n", "<leader><leader>x", ":call ak#save_and_exec()<CR>", { desc = "Save and execute this file" })

-- <leader>il to inspect letter
if vim.version().major > 0 or vim.version().minor >= 9 then
  vim.keymap.set("n", "<leader>il", ":Inspect<CR>",                        { desc = "[I]nspect [L]etter" })
  vim.keymap.set("n", "<leader>iv", ":Inspect!<CR>",                       { desc = "[I]nspect [V]erbose" })
  vim.keymap.set("n", "<leader>it", ":InspectTree<CR>",                    { desc = "[I]nspect [T]ree" })
else
  vim.keymap.set("n", "<leader>il", ":TSHighlightCapturesUnderCursor<CR>", { desc = "[I]nspect [L]etter" })
  vim.keymap.set("n", "<leader>iv", ":TSNodeUnderCursor<CR>",              { desc = "[I]nspect [V]erbose" })
end
vim.keymap.set("n",   "<leader>ip", ":TSPlaygroundToggle<CR>",             { desc = "[I]nspect [P]layground" })

-- <leader><leader>l to open Lazy plugin management window
vim.keymap.set("n", "<leader><leader>l", ":Lazy<CR>", { desc = "[L]azy" })

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

-- tcsh-style keymaps
vim.keymap.set("c", "<C-A>", "<Home>")
vim.keymap.set("c", "<C-E>", "<End>")
vim.keymap.set({ "c", "i", "n", "v" }, "<M-b>", "<S-Left>")
vim.keymap.set({ "c", "i", "n", "v" }, "<M-f>", "<S-Right>")

-- window splitting
vim.keymap.set("n", "<leader>\\", ":bel vsplit<CR>", { silent = true, desc = "Split Vertically" })
vim.keymap.set("n", "<C-\\>",     ":bel vsplit<CR>", { silent = true, desc = "Split Vertically" })
vim.keymap.set("n", "<leader>-",  ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-->",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-_>",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<C-'>",      ":bel split<CR>",  { silent = true, desc = "Split Horizontally" })
vim.keymap.set("n", "<leader>=",  ":ZoomToggle<CR>", { silent = true, desc = "Toggle window zoom" })
vim.keymap.set("n", "<C-=>",      ":ZoomToggle<CR>", { silent = true, desc = "Toggle window zoom" })

-- term keymaps
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]])
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]])
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]])
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
