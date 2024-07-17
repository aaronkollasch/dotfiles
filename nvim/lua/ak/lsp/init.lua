local lsp_zero = require("lsp-zero")

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "tsserver",
        "eslint",
        "lua_ls",
        "rust_analyzer",
        "basedpyright",
        -- "pylsp",
        "ruff",
        "ruff_lsp",
        "bashls",
        "clangd",
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup({})
        end,

        lua_ls = function()
            -- lua setup
            require("lspconfig").lua_ls.setup({
                settings = {
                    Lua = {
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
                commands = {
                    Format = {
                        function()
                            require("stylua-nvim").format_file()
                        end,
                    },
                },
            })
        end,

        -- python setup
        basedpyright = function()
            require("lspconfig").basedpyright.setup({
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "strict", -- disable deprecation warnings for now
                        },
                    },
                },
            })
        end,
        ruff_lsp = function()
            require("lspconfig").ruff_lsp.setup({
                init_options = {
                    settings = {
                        args = {
                            "--line-length=120",
                        },
                    },
                },
            })
        end,

        clangd = function()
            local capabilities = lsp_zero.get_capabilities()
            capabilities.offsetEncoding = { "utf-16" }
            require("lspconfig").clangd.setup({
                capabilities = capabilities,
            })
        end,

        rust_analyzer = function()
            -- rust setup
            require("lspconfig").rust_analyzer.setup({
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            })
        end,
    },
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = function(bufnr)
            if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_format" }
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

local sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
}
if require("ak.opts").icons_enabled then
    sign_icons = {
        error = " ",
        warn = " ",
        hint = " ",
        info = "󰌵",
    }
end
lsp_zero.set_sign_icons(sign_icons)

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
map("n", "[d",         vim.diagnostic.goto_prev,  { desc = "Previous diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>q",  function()
    require("telescope.builtin").diagnostics()
end,                                              { desc = "Show diagnostics" })
map("n", "<leader>wd",  function()
    require("telescope.builtin").diagnostics()
end,                                              { desc = "[W]orkspace [D]iagnostics" })
-- stylua: ignore end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
lsp_zero.on_attach(function(client, bufnr)
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
    bufmap("n", "K",              vim.lsp.buf.hover,            { desc = "LSP Hover" })
    bufmap("n", "gi",             builtin.lsp_implementations,  { desc = "[G]oto [I]mplementation" })
    bufmap({ "i", "s" }, "<C-h>", vim.lsp.buf.signature_help,   { desc = "Show signature help" })
    bufmap("n", "<leader>wa",     vim.lsp.buf.add_workspace_folder,
                                                                { desc = "[W]orkspace [A]dd folder" })
    bufmap("n", "<leader>wr",     vim.lsp.buf.remove_workspace_folder,
                                                                { desc = "[W]orkspace [R]emove folder" })
    bufmap("n", "<leader>wl",     function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,                                                        { desc = "[W]orkspace [L]ist" })
    bufmap("n", "<leader>D",      builtin.lsp_type_definitions, { desc = "Type [D]efinition" })
    bufmap("n", "<S-Space>D",     builtin.lsp_type_definitions, { desc = "Type [D]efinition" })
    bufmap("n", "<leader>rn",     vim.lsp.buf.rename,           { desc = "[R]e[N]ame" })
    bufmap("n", "<leader>ca",     vim.lsp.buf.code_action,      { desc = "[C]ode  [A]ctions" })
    bufmap("n", "<leader>ci",     builtin.lsp_incoming_calls,   { desc = "[C]alls [I]ncoming" })
    bufmap("n", "<leader>co",     builtin.lsp_outgoing_calls,   { desc = "[C]alls [O]utgoing" })
    bufmap("n", "gr",             builtin.lsp_references,       { desc = "[G]oto [R]eferences" })
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

    if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end

    if client.server_capabilities.inlayHintProvider then
        bufmap("n", "<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
        end, { desc = "[C]ode  [H]ints" })
        if client.name == "rust_analyzer" then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end
end)

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
local cmp_mappings = lsp_zero.defaults.cmp_mappings({
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
})

-- disable <CR> mapping so that <CR> is faster
cmp_mappings["<CR>"] = nil

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

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
