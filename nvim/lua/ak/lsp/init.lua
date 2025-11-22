local automatic_enable = vim.fn.has("nvim-0.11") > 0

require("mason").setup({})
require("mason-lspconfig").setup({
    automatic_enable = automatic_enable,
    ensure_installed = {
        "ts_ls",
        "eslint",
        "lua_ls",
        "rust_analyzer",
        "basedpyright",
        -- "pylsp",
        "ruff",
        "bashls",
        "clangd",
    },
})

-- language-specific customizations
vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            inlayHints = {
                parameterHints = {
                    enable = false,
                },
            },
        },
    },
})

-- formatters
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_organize_imports", "ruff_format" }
            else
                return { "isort", "black" }
            end
        end,
        c = { "clang-format" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
    },
})

-- see https://github.com/neovim/nvim-lspconfig/issues/2366#issuecomment-1367098168
vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
    return true
end

local ds = vim.diagnostic.severity
local sign_icons = {
    [ds.ERROR] = "E",
    [ds.WARN] = "W",
    [ds.HINT] = "H",
    [ds.INFO] = "I",
}
if require("ak.opts").icons_enabled then
    sign_icons = {
        [ds.ERROR] = " ",
        [ds.WARN] = " ",
        [ds.HINT] = " ",
        [ds.INFO] = "󰌵",
    }
end
vim.diagnostic.config({
    signs = { text = sign_icons },
    severity_sort = true,
    jump = { float = true },
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local function map(mode, l, r, opts)
    opts = opts or {}
    opts.noremap = true
    opts.silent = true
    vim.keymap.set(mode, l, r, opts)
end

-- stylua: ignore start
map("n", "<leader>e",  vim.diagnostic.open_float, { desc = "Open LSP float" })
map("n", "<leader>q",  function()
    require("telescope.builtin").diagnostics()
end,                                              { desc = "Show diagnostics" })
map("n", "<leader>wd",  function()
    require("telescope.builtin").diagnostics()
end,                                              { desc = "[W]orkspace [D]iagnostics" })
-- stylua: ignore end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local builtin = require("telescope.builtin")

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    local function bufmap(mode, l, r, bufopts)
        bufopts = bufopts or {}
        bufopts.buffer = bufnr
        bufopts.noremap = true
        bufopts.silent = true
        vim.keymap.set(mode, l, r, bufopts)
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- stylua: ignore start
    bufmap("n", "gD",             vim.lsp.buf.declaration,      { desc = "[G]oto [D]eclaration" })
    bufmap("n", "gd",             builtin.lsp_definitions,      { desc = "[G]oto [d]efinition" })
    bufmap("n", "<leader>wa",     vim.lsp.buf.add_workspace_folder,
                                                                { desc = "[W]orkspace [A]dd folder" })
    bufmap("n", "<leader>wr",     vim.lsp.buf.remove_workspace_folder,
                                                                { desc = "[W]orkspace [R]emove folder" })
    bufmap("n", "<leader>wl",     function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,                                                        { desc = "[W]orkspace [L]ist" })
    bufmap("n", "<leader>rn",     vim.lsp.buf.rename,           { desc = "[R]e[N]ame" })
    bufmap("n", "<leader>ca",     vim.lsp.buf.code_action,      { desc = "[C]ode  [A]ctions" })
    bufmap("n", "<leader>ci",     builtin.lsp_incoming_calls,   { desc = "[C]alls [I]ncoming" })
    bufmap("n", "<leader>co",     builtin.lsp_outgoing_calls,   { desc = "[C]alls [O]utgoing" })
    bufmap("n", "<leader>fmt",      function()
        require("conform").format({ async = true, bufnr = bufnr, lsp_format = "fallback" })
    end,                                                        { desc = "[F]or[M]a[T] (async)" })
    -- stylua: ignore end

    -- enable <c-j> and <c-k> arrow keys
    bufmap("i", "<c-x><c-j>", "<c-x><c-n>")
    bufmap("i", "<c-x><c-k>", "<c-x><c-p>")
    vim.cmd([[inoremap <buffer> <c-j> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>]])
    vim.cmd([[inoremap <buffer> <c-k> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>Up>"<CR>]])

    if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
            range = true,
        }
    end

    if client.server_capabilities.inlayHintProvider then
        bufmap("n", "<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, { desc = "[C]ode  [H]ints" })
        if client.name == "rust_analyzer" then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end
end
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
    callback = function(event_context)
        local client = vim.lsp.get_client_by_id(event_context.data.client_id)
        -- vim.print(client.name, client.server_capabilities)

        if not client then
            return
        end

        local bufnr = event_context.buf

        on_attach(client, bufnr)
    end,
})

local diagnostic_config = {
    virtual_text = {
        prefix = "■",
        spacing = 1,
    },
}
if not require("ak.opts").icons_enabled then
    diagnostic_config.virtual_text.prefix = "!"
end
vim.diagnostic.config(diagnostic_config)

-- completion setup
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = {
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
    ["<Right>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),

    ["<C-d>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.scroll_docs(4)
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-u>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.scroll_docs(-4)
        else
            fallback()
        end
    end, { "i", "s" }),

    -- go to next placeholder in the snippet
    ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-;>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end, { "i", "s" }),

    -- go to previous placeholder in the snippet
    ["<C-p>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<C-,>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
}

local cmp_sources = cmp.config.sources({
    { name = "path" },
    { name = "lazydev", keyword_length = 3, group_index = 0 },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
})

cmp.setup({
    mapping = cmp_mappings,
    sources = cmp_sources,
})
