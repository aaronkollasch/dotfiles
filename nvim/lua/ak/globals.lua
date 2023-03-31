-- P and R from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/globals.lua
-- see https://youtu.be/n4Lp4cV8YR0?t=2222
P = function(v)
    print(vim.inspect(v))
    return v
end

local ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = require
if ok then
    reloader = plenary_reload.reload_module
end

RELOAD = function(...)
    return reloader(...)
end

R = function(name)
    RELOAD(name)
    return require(name)
end

vim.cmd([[
" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call ak#redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call ak#redir(<q-args>, <range>, <line1>, <line2>)
]])
