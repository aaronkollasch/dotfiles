local event = "VeryLazy"

-- stylua: ignore
return {
    -- textobjects
    {
        "chrisgrieser/nvim-various-textobjs",
        event = event,
        init = function()
            vim.keymap.set({ "o", "x" }, "!", '<cmd>lua require("various-textobjs").diagnostic()<CR>', { desc = "Diagnostic" })
            vim.keymap.set({ "o", "x" }, "|", '<cmd>lua require("various-textobjs").column()<CR>', { desc = "Column" })
            -- vim.keymap.set({ "o", "x" }, "ae", '<cmd>lua require("various-textobjs").entireBuffer()<CR>')
            -- vim.keymap.set({ "o", "x" }, "ie", '<cmd>lua require("various-textobjs").entireBuffer()<CR>')

            -- vim.keymap.set({ "o", "x" }, "aS", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
            -- vim.keymap.set({ "o", "x" }, "iS", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
            vim.keymap.set({ "o", "x" }, "ak", '<cmd>lua require("various-textobjs").key("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "ik", '<cmd>lua require("various-textobjs").key("inner")<CR>')
            vim.keymap.set({ "o", "x" }, "av", '<cmd>lua require("various-textobjs").value("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "iv", '<cmd>lua require("various-textobjs").value("inner")<CR>')
            vim.keymap.set({ "o", "x" }, "aC", '<cmd>lua require("various-textobjs").mdFencedCodeBlock("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "iC", '<cmd>lua require("various-textobjs").mdFencedCodeBlock("inner")<CR>')
            vim.keymap.set({ "o", "x" }, "am", '<cmd>lua require("various-textobjs").chainMember("outer")<CR>')
            vim.keymap.set({ "o", "x" }, "im", '<cmd>lua require("various-textobjs").chainMember("inner")<CR>')

            -- indentation textobj requires two parameters, the first for
            -- exclusion of the starting border, the second for the exclusion of<CR>'ing border
            vim.keymap.set({ "o", "x" }, "ii", '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>')
            vim.keymap.set({ "o", "x" }, "ai", '<cmd>lua require("various-textobjs").indentation("outer", "inner")<CR>')
            vim.keymap.set({ "o", "x" }, "iI", '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>')
            vim.keymap.set({ "o", "x" }, "aI", '<cmd>lua require("various-textobjs").indentation("outer", "outer")<CR>')
        end,
    },
    -- see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",               dependencies = "kana/vim-textobj-user", event = event }, -- al/il for the current line
    -- { "kana/vim-textobj-indent",             dependencies = "kana/vim-textobj-user", event = event }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",             dependencies = "kana/vim-textobj-user", event = event }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter",          dependencies = "kana/vim-textobj-user", event = event }, -- a,/i, for an argument to a function
    -- { "D4KU/vim-textobj-chainmember",        dependencies = "kana/vim-textobj-user", event = event }, -- am/im for a member in a member chain
    -- { "vimtaku/vim-textobj-keyvalue",        dependencies = "kana/vim-textobj-user", event = event }, -- ak/ik and av/iv for key/value
    { "jceb/vim-textobj-uri",                dependencies = "kana/vim-textobj-user", event = event }, -- au/iu for a URI, also adds go to open URL
    { "preservim/vim-textobj-sentence",      dependencies = "kana/vim-textobj-user", event = event,   -- as/is for the current sentence (replaces built-in objects/motions)
        config = function ()
            vim.fn["textobj#sentence#init"]()
        end,
    },
    {
        "glts/vim-textobj-comment",          dependencies = "kana/vim-textobj-user", event = event,   -- ac/ic for a comment
        init = function()
            vim.g.loaded_textobj_comment = 1
        end,
        config = function()
            vim.cmd([[
            call textobj#user#plugin('comment', {
                \ '-': {
                \    'select-a': 'ac', 'select-a-function': 'textobj#comment#select_a',
                \    'select-i': 'ic', 'select-i-function': 'textobj#comment#select_i',
                \ }})
            ]])
        end,
    },
    { "Julian/vim-textobj-variable-segment", dependencies = "kana/vim-textobj-user", event = event,   -- aS/iS for a subword, separated by camelCase or underscore
        init = function()
            vim.g.loaded_textobj_variable_segment = 1
        end,
        config = function()
            vim.cmd([[
            call textobj#user#plugin('variable', {
                \ '-': {
                \     'sfile': expand('<sfile>:p'),
                \     'select-a': 'aS',  'select-a-function': 'textobj#variable_segment#select_a',
                \     'select-i': 'iS',  'select-i-function': 'textobj#variable_segment#select_i',
                \ }})
            ]])
        end,
    },

    -- motions
    {
        "andymass/vim-matchup",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- may set any options here
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    {
        "rhysd/clever-f.vim",
        event = event,
        init = function()
            vim.g.clever_f_timeout_ms = 2000
            vim.g.clever_f_highlight_timeout_ms = vim.g.clever_f_timeout_ms - 200
            vim.g.clever_f_fix_key_direction = 1
        end,
    },
    {
        "ggandor/leap.nvim",
        event = event,
        config = function()
            require("leap").add_default_mappings()
            vim.keymap.set(
                "o",
                "s",
                "v:operator == 'y' ? '<Esc>ys' : '<Plug>(leap-forward-to)'",
                { expr = true, remap = true, desc = "Leap forward to" }
            )
            vim.keymap.set(
                "o",
                "S",
                "v:operator == 'y' ? '<Esc>yS' : '<Plug>(leap-backward-to)'",
                { expr = true, remap = true, desc = "Leap backward to" }
            )
        end,
        enabled = false,
    },
    {
        "folke/flash.nvim",
        event = event,
        opts = {
            -- labels = "asdfghjklqwertyuiopzxcvbnm",
            labels = "arstdhneiobgvjmkpfwluycxzq",
            char = {
                enabled = false,
            },
        },
        enabled = false,
    },
}
