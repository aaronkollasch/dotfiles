vim.g.edge_transparent_background = 1
vim.g.edge_enable_italic = 1

vim.cmd([[
if has('termguicolors')
  set termguicolors
endif

"LIGHT
" set background=light
"DARK
 set background=dark
if $LC_TERMINAL == "cool-retro-term"
  set background=dark
  let g:edge_enable_italic = 0
  let g:edge_disable_italic_comment = 1
endif
if $LC_DARKMODE == "YES"
  set background=dark
elseif $LC_DARKMODE == "NO"
  set background=light
endif

function! UpdateEdgeColors()
  " use built-in fg color for Normal
  highlight Normal guibg=NONE ctermbg=NONE

  " highlight TSVariable as Normal
  highlight! link TSParameter Normal
  highlight! link TSParameterReference Normal
  highlight! link TSVariable Normal
  highlight! link TSVariableBuiltin Red

  if &background ==# 'light'
    " #76af6f = oklch(69.82% 0.109 141.77) >> oklch(86.2% 0.165 141.77)  = #8fec84
    call edge#highlight('Search', ['#000000', '0'], ['#8fec84', '119'])
    " #6996e0 = oklch(67.24% 0.121 259.96) >> oklch(81.0% 0.165 259.96) ~= #9dc2ff
    call edge#highlight('IncSearch', ['#000000', '0'], ['#9dc2ff', '81'])
    " #d05858 = oklch(61.36% 0.153 22.66)  >> oklch(93% 0.153 22.66)    ~= #ffdfdd
    call edge#highlight('Error', ['#d05858', '167'], ['#ffdfdd', '224'])
  else
    " #a0c980 = oklch(78.86% 0.108 132.28) >> oklch(51.8% 0.167 132.28) ~= #467800
    call edge#highlight('Search', ['#FFFFFF', '1'], ['#467800', '28'])
    " #6cb6eb = oklch(74.89% 0.107 241.3)  >> oklch(55.5% 0.167 241.3)  ~= #007ab7
    call edge#highlight('IncSearch', ['#FFFFFF', '1'], ['#007ab7', '27'])
    " #ec7279 = oklch(69.7% 0.151 18.26)   >> oklch(20% 0.151 18.26)    ~= #320007
    call edge#highlight('Error', ['#ec7279', '203'], ['#320007', '52'])
  endif

  " highlight spelling with undercurl
  hi SpellBad   guisp=red gui=undercurl guifg=NONE guibg=NONE
     \ ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl
  if &background ==# 'light'
    hi SpellCap   guisp=#be7e05 gui=undercurl guifg=NONE guibg=NONE
       \ ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl
  else
    hi SpellCap   guisp=yellow gui=undercurl guifg=NONE guibg=NONE
       \ ctermfg=NONE ctermbg=NONE term=underline cterm=undercurl
  endif

  " vim-matchup virtual text support
  hi! link MatchupVirtualText VirtualTextHint
endfunction

function! ColorSchemeDarcula()
  if &background ==# 'dark'
    colorscheme darcula

    " make cursor line number brighter
    set cursorline

    " fix lualine theme
    lua require("lualine").setup({ options = { theme='auto' } })
    highlight! lualine_a_insert guifg=#30302c
  endif
endfunction

augroup CustomColors
  au!
  au ColorScheme edge call UpdateEdgeColors()
  au FileType python call ColorSchemeDarcula()
augroup END
]])

vim.api.nvim_create_autocmd("ColorScheme", {
    group = "CustomColors",
    pattern = { "edge", "darcula" },
    callback = function()
        -- link new semantic highlighting groups
        -- see https://github.com/neovim/neovim/pull/22022
        -- see https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
        -- see https://github.com/Microsoft/vscode-docs/blob/main/api/language-extensions/semantic-highlight-guide.md
        local links = {
            ["@identifier"] = "Identifier",
            ["@structure"] = "Structure",
            ["@lsp.type.namespace"] = "@namespace",
            ["@lsp.type.type"] = "@type",
            ["@lsp.type.class"] = "@type",
            ["@lsp.type.enum"] = "@type",
            ["@lsp.type.struct"] = "@structure",
            ["@lsp.type.parameter"] = "@parameter",
            ["@lsp.type.variable"] = "@variable",
            ["@lsp.type.property"] = "@property",
            ["@lsp.type.enumMember"] = "@constant",
            ["@lsp.type.function"] = "@function",
            ["@lsp.type.method"] = "@method",
            ["@lsp.type.macro"] = "@macro",
            ["@lsp.type.decorator"] = "@function",
            -- customizations:
            ["@lsp.type.interface"] = "@identifier",
            ["@lsp.type.typeParameter"] = "@type",
            ["@lsp.type.formatSpecifier"] = "@punctuation.special",
            ["@lsp.mod.readonly"] = "@constant",
            ["@lsp.mod.global"] = "@constant",
            ["@lsp.mod.constant"] = "@constant",
            ["@lsp.typemod.variable.defaultLibrary"] = "@variable.builtin",
            ["@lsp.typemod.variable.readonly.defaultLibrary"] = "@constant.builtin",
            ["@lsp.typemod.function.defaultLibrary"] = "@function.builtin",
            ["@lsp.typemod.type.defaultLibrary"] = "@type.builtin",
            ["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
        }
        for newgroup, oldgroup in pairs(links) do
            vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
        end
        -- language-specific
        vim.api.nvim_set_hl(0, "@lsp.mod.mutable.rust", { italic = true })
        vim.api.nvim_set_hl(0, "@lsp.type.struct.rust", { link = "@type", default = true })
        vim.api.nvim_set_hl(0, "@lsp.type.macro.rust", { link = "@lsp", default = true })
        -- vim.api.nvim_set_hl(0, '@lsp.typemod.decorator.attribute.rust', { link = 'Purple', default = true })
        -- vim.api.nvim_set_hl(0, '@lsp.typemod.builtinAttribute.attribute.rust', { link = 'Purple', default = true })
        -- vim.api.nvim_set_hl(0, '@lsp.typemod.generic.attribute.rust', { link = 'Purple', default = true })
    end,
})

vim.cmd([[
if &background ==# 'light'
  " let g:edge_colors_override = {
  "         \ 'black':      ['#dde2e7',   '253'],
  "         \ 'bg0':        ['#fafafa',   '231'],
  "         \ 'bg1':        ['#eef1f4',   '255'],
  "         \ 'bg2':        ['#e8ebf0',   '254'],
  "         \ 'bg3':        ['#e8ebf0',   '253'],
  "         \ 'bg4':        ['#dde2e7',   '253'],
  "         \ 'bg_grey':    ['#bcc5cf',   '246'],
  "         \ 'bg_red':     ['#e17373',   '167'],
  "         \ 'diff_red':   ['#f6e4e4',   '217'],
  "         \ 'bg_green':   ['#76af6f',   '107'],
  "         \ 'diff_green': ['#e5eee4',   '150'],
  "         \ 'bg_blue':    ['#6996e0',   '68'],
  "         \ 'diff_blue':  ['#e3eaf6',   '153'],
  "         \ 'bg_purple':  ['#bf75d6',   '134'],
  "         \ 'diff_yellow':['#f0ece2',   '183'],
  "         \ 'fg':         ['#4b505b',   '240'], = lch(34% 7 269deg)  >> lch(10% 7 269deg)  = #171c25
  "         \ 'red':        ['#d05858',   '167'],
  "         \ 'yellow':     ['#be7e05',   '172'],
  "         \ 'green':      ['#608e32',   '107'], = lch(54% 51 124deg) >> lch(48% 60 124deg) = #407506
  "         \ 'cyan':       ['#3a8b84',   '73'],  = lch(53% 27 189deg) >> lch(44% 40 189deg) = #007971
  "         \ 'blue':       ['#5079be',   '68'],  = lch(50% 41 272deg) >> lch(44% 50 272deg) = #276abc
  "         \ 'purple':     ['#b05ccc',   '134'], = lch(53% 65 317deg) >> lch(48% 72 317deg) = #a64ac7
  "         \ 'grey':       ['#8790a0',   '245'], = lch(59% 10 265deg) >> lch(52% 11 265deg) = #737d8f
  "         \ 'grey_dim':   ['#bac3cb',   '249'],
  "         \ 'none':       ['NONE',      'NONE']
  "         \ } "}}}
  let g:edge_colors_override = {
        \ 'fg': ['#171c25', '235'],
        \ 'green': ['#407506', '71'],
        \ 'cyan': ['#007971', '73'],
        \ 'blue': ['#276abc', '68'],
        \ 'purple': ['#a64ac7', '134'],
        \ 'grey': ['#737d8f', '243'],
        \ 'bg4': ['#bac3cb', '249'],
        \ }
  colorscheme edge
else
  let g:edge_colors_override = {
        \ 'bg4': ['#535c6a', '240'],
        \ }
  colorscheme edge
endif
]])
