return {
    {
        "mrjones2014/op.nvim",
        build = "make install",
        keys = {
            {
                "<leader>op",
                function()
                    require("op").op_insert()
                end,
                desc = "[O]ne[P]assword",
            },
            -- { "<leader>op", function() require("op.sidebar").toggle end, desc = "[O]ne[P]assword" },
        },
        opts = {
            sidebar = {
                side = "left",
            },
            mappings = {
                ["q"] = function()
                    require("op.sidebar").close()
                end,
            },
        },
    },
    {
        'pwntester/octo.nvim',
        cmd = "Octo",
        opts = {
            gh_env = function ()
                -- see https://blog.1password.com/1password-neovim/
                local github_token = require('op.api').item.get({ 'GitHub Personal Access Token', '--fields', 'token' })[1]
                if not github_token or not vim.startswith(github_token, 'ghp_') then
                    error('Failed to get GitHub token.')
                end
                return { GITHUB_TOKEN = github_token }
            end,
        },
    }
}
