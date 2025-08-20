---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

local function set_python_path(path)
    local clients = vim.lsp.get_clients({
        bufnr = vim.api.nvim_get_current_buf(),
        name = "basedpyright",
    })
    for _, client in ipairs(clients) do
        if client.settings then
            client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
        else
            client.config.settings =
                vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
        end
        client:notify("workspace/didChangeConfiguration", { settings = nil })
    end
end

-- set basedpyright type checking mode without restarting server
local function pyright_set_type_checking_mode(mode)
    local clients = vim.lsp.get_clients({
        bufnr = vim.api.nvim_get_current_buf(),
        name = "basedpyright",
    })
    for _, client in ipairs(clients) do
        if client.settings then
            client.settings.basedpyright = vim.tbl_deep_extend(
                "force",
                client.settings.basedpyright or {},
                { analysis = { typeCheckingMode = mode } }
            )
        else
            client.config.settings = vim.tbl_deep_extend(
                "force",
                client.config.settings,
                { basedpyright = { analysis = { typeCheckingMode = mode } } }
            )
        end
        client:notify("workspace/didChangeConfiguration", { settings = nil })
    end
end

---@type vim.lsp.Config
return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "PyrightSetPythonPath", set_python_path, {
            desc = "Reconfigure basedpyright with the provided python path",
            nargs = 1,
            complete = "file",
        })
        vim.api.nvim_buf_create_user_command(bufnr, "PyrightSetTypeCheckingMode", function(opts)
            local typeCheckingMode = opts.fargs[1] or "standard"
            pyright_set_type_checking_mode(typeCheckingMode)
        end, {
            nargs = 1,
            complete = function()
                return { "off", "basic", "standard", "strict", "all" }
            end,
        })
    end,
}
