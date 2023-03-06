local event = "VeryLazy"

return {
    -- textobjects, see https://github.com/kana/vim-textobj-user/wiki
    { "kana/vim-textobj-line",               dependencies = "kana/vim-textobj-user", event = event }, -- al/il for the current line
    { "kana/vim-textobj-indent",             dependencies = "kana/vim-textobj-user", event = event }, -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    { "kana/vim-textobj-entire",             dependencies = "kana/vim-textobj-user", event = event }, -- ae/ie for the entire region of the current buffer
    { "sgur/vim-textobj-parameter",          dependencies = "kana/vim-textobj-user", event = event }, -- a,/i, for an argument to a function
    { "vimtaku/vim-textobj-keyvalue",        dependencies = "kana/vim-textobj-user", event = event }, -- ak/ik and av/iv for key/value
    { "glts/vim-textobj-comment",            dependencies = "kana/vim-textobj-user", event = event }, -- ac/ic for a comment
    { "jceb/vim-textobj-uri",                dependencies = "kana/vim-textobj-user", event = event }, -- au/iu for a URI, also adds go to open URL
    { "preservim/vim-textobj-sentence",      dependencies = "kana/vim-textobj-user", event = event,   -- as/is for the current sentence (replaces built-in objects/motions)
        config = function ()
            vim.fn["textobj#sentence#init"]()
        end
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
        end
    },
}
