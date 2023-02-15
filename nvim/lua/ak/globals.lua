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
