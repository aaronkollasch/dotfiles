return {
    {
        "kiyoon/jupynium.nvim",
        build = "conda run --no-capture-output -n jupynium pip install .",
        enabled = vim.fn.isdirectory(vim.fn.expand("~/mambaforge/envs/jupynium")),
        cmd = {
            "JupyniumAttachToServer",
            "JupyniumStartAndAttachToServer",
            "JupyniumStartAndAttachToServerInTerminal",
            "JupyniumStartSync",
            "JupyniumLoadFromIpynbTab",
            "JupyniumLoadFromIpynbTabAndStartSync",
        },
        opts = {
            --- For Conda environment named "jupynium",
            python_host = { "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },

            jupyter_command = { "conda", "run", "--no-capture-output", "-n", "home", "jupyter" },
        },
    },
    -- {
    --     'glacambre/firenvim',
    --     build = function()
    --         require("lazy").load({ plugins = "firenvim", wait = true })
    --         vim.fn["firenvim#install"](0)
    --     end,
    --     -- Lazy load firenvim
    --     -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    --     cond = not not vim.g.started_by_firenvim,
    --     config = function ()
    --         vim.o.guifont = "Fira_Code:h20"
    --     end
    -- },
}
