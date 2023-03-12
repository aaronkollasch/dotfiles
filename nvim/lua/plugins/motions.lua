local event = "VeryLazy"

return {
    -- textobjects
    {
        "chrisgrieser/nvim-various-textobjs",
        event = event,
        init = function ()
            vim.keymap.set({"o", "x"}, "!", function () require("various-textobjs").diagnostic() end, { desc = "Diagnostic" })
            vim.keymap.set({"o", "x"}, "|", function () require("various-textobjs").column() end, { desc = "Column" })
            -- vim.keymap.set({"o", "x"}, "ae", function () require("various-textobjs").entireBuffer() end)
            -- vim.keymap.set({"o", "x"}, "ie", function () require("various-textobjs").entireBuffer() end)

            -- vim.keymap.set({"o", "x"}, "aS", function () require("various-textobjs").subword(false) end)
            -- vim.keymap.set({"o", "x"}, "iS", function () require("various-textobjs").subword(true) end)
            vim.keymap.set({"o", "x"}, "ak", function () require("various-textobjs").key(false) end)
            vim.keymap.set({"o", "x"}, "ik", function () require("various-textobjs").key(true) end)
            vim.keymap.set({"o", "x"}, "av", function () require("various-textobjs").value(false) end)
            vim.keymap.set({"o", "x"}, "iv", function () require("various-textobjs").value(true) end)

            -- indentation textobj requires two parameters, the first for
            -- exclusion of the starting border, the second for the exclusion of ending
            -- border
            vim.keymap.set({"o", "x"}, "ii", function () require("various-textobjs").indentation(true, true) end)
            vim.keymap.set({"o", "x"}, "ai", function () require("various-textobjs").indentation(false, true) end)
            vim.keymap.set({"o", "x"}, "iI", function () require("various-textobjs").indentation(true, true) end)
            vim.keymap.set({"o", "x"}, "aI", function () require("various-textobjs").indentation(false, false) end)
        end
    },
    -- see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",               dependencies = "kana/vim-textobj-user", event = event }, -- al/il for the current line
    -- { "kana/vim-textobj-indent",             dependencies = "kana/vim-textobj-user", event = event }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",             dependencies = "kana/vim-textobj-user", event = event }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter",          dependencies = "kana/vim-textobj-user", event = event }, -- a,/i, for an argument to a function
    -- { "vimtaku/vim-textobj-keyvalue",        dependencies = "kana/vim-textobj-user", event = event }, -- ak/ik and av/iv for key/value
    { "glts/vim-textobj-comment",            dependencies = "kana/vim-textobj-user", event = event }, -- ac/ic for a comment
    { "jceb/vim-textobj-uri",                dependencies = "kana/vim-textobj-user", event = event }, -- au/iu for a URI, also adds go to open URL
    { "preservim/vim-textobj-sentence",      dependencies = "kana/vim-textobj-user", event = event,   -- as/is for the current sentence (replaces built-in objects/motions)
        config = function ()
            vim.fn["textobj#sentence#init"]()
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
        "rhysd/clever-f.vim",
        event = event,
        init = function ()
            vim.g.clever_f_timeout_ms = 2000
            vim.g.clever_f_highlight_timeout_ms = vim.g.clever_f_timeout_ms - 200
            vim.g.clever_f_fix_key_direction = 1
        end,
    },
    {
        "ggandor/leap.nvim",
        event = event,
        config = function ()
            require('leap').add_default_mappings()
        end
    },
}
