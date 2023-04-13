local options = {
    icons_enabled = true,
}

if vim.env.LC_TERMINAL == "cool-retro-term" or vim.env.LC_RETRO == "yes" or vim.g.started_by_firenvim then
    options.icons_enabled = false
end

return options
