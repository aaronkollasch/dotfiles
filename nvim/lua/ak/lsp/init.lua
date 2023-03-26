local lsp = require("lsp-zero")

-- see https://github.com/neovim/nvim-lspconfig/issues/2366#issuecomment-1367098168
vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.reset(ns, bufnr)
    return true
end

lsp.preset("recommended")

lsp.ensure_installed({
    "tsserver",
    "eslint",
    "lua_ls",
    "rust_analyzer",
    "pyright",
    "bashls",
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
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
    { name = "nvim_lua", keyword_length = 3 },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "buffer", keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = cmp_sources,
})

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
        info = "",
    }
end
lsp.set_preferences({
    sign_icons=sign_icons,
})

vim.diagnostic.config({
    virtual_text = true,
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float, { desc = "Open LSP float", unpack(opts) })
vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  { desc = "Previous diagnostic", unpack(opts) })
vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  { desc = "Next diagnostic", unpack(opts) })
vim.keymap.set("n", "<leader>q",  function()
    require("telescope.builtin").diagnostics()
end,                                                         { desc = "Show diagnostics", unpack(opts) })
vim.keymap.set("n", "<leader>wd",  function()
    require("telescope.builtin").diagnostics()
end,                                                         { desc = "[W]orkspace [D]iagnostics", unpack(opts) })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local builtin = require("telescope.builtin")

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD",             vim.lsp.buf.declaration,      { desc = "[G]oto [D]eclaration", unpack(bufopts) })
    vim.keymap.set("n", "gd",             builtin.lsp_definitions,      { desc = "[G]oto [d]efinition", unpack(bufopts) })
    vim.keymap.set("n", "K",              vim.lsp.buf.hover,            { desc = "LSP Hover", unpack(bufopts) })
    vim.keymap.set("n", "gi",             builtin.lsp_implementations,  { desc = "[G]oto [I]mplementation", unpack(bufopts) })
    vim.keymap.set({ "i", "s" }, "<C-h>", vim.lsp.buf.signature_help,   { desc = "Show signature help", unpack(bufopts) })
    vim.keymap.set("n", "<leader>wa",     vim.lsp.buf.add_workspace_folder,
                                                                        { desc = "[W]orkspace [A]dd folder", unpack(bufopts) })
    vim.keymap.set("n", "<leader>wr",     vim.lsp.buf.remove_workspace_folder,
                                                                        { desc = "[W]orkspace [R]emove folder", unpack(bufopts) })
    vim.keymap.set("n", "<leader>wl",     function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,                                                                { desc = "[W]orkspace [L]ist", unpack(bufopts) })
    vim.keymap.set("n", "<leader>D",      builtin.lsp_type_definitions, { desc = "Type [D]efinition", unpack(bufopts) })
    vim.keymap.set("n", "<S-Space>D",     builtin.lsp_type_definitions, { desc = "Type [D]efinition", unpack(bufopts) })
    vim.keymap.set("n", "<leader>rn",     vim.lsp.buf.rename,           { desc = "[R]e[N]ame", unpack(bufopts) })
    vim.keymap.set("n", "<leader>ca",     vim.lsp.buf.code_action,      { desc = "[C]ode  [A]ctions", unpack(bufopts) })
    vim.keymap.set("n", "<leader>ci",     builtin.lsp_incoming_calls,   { desc = "[C]alls [I]ncoming", unpack(bufopts) })
    vim.keymap.set("n", "<leader>co",     builtin.lsp_outgoing_calls,   { desc = "[C]alls [O]utgoing", unpack(bufopts) })
    vim.keymap.set("n", "gr",             builtin.lsp_references,       { desc = "[G]oto [R]eferences", unpack(bufopts) })
    vim.keymap.set("n", "<leader>fm",      function()
        vim.lsp.buf.format({ async = true })
    end,                                                                { desc = "[F]or[M]at (async)", unpack(bufopts) })
    vim.keymap.set("n", "<leader>fmt",      function()
        vim.lsp.buf.format({ async = true })
    end,                                                                { desc = "[F]or[M]a[T] (async)", unpack(bufopts) })
    -- enable <c-j> and <c-k> arrow keys
    vim.keymap.set("i", "<c-x><c-j>", "<c-x><c-n>", bufopts)
    vim.keymap.set("i", "<c-x><c-k>", "<c-x><c-p>", bufopts)
    vim.cmd([[inoremap <c-j> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>]])
    vim.cmd([[inoremap <c-k> <C-R>=pumvisible() ? "\<lt>C-P>" : "\<lt>Up>"<CR>]])

    require("nvim-navbuddy").attach(client, bufnr)
end
lsp.on_attach(on_attach)

-- lua setup
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})
lsp.configure("lua_ls", {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "<leader>fm", function()
            require("stylua-nvim").format_file()
        end, { desc = "[F]or[M]at (async)", unpack(bufopts) })
        vim.keymap.set("n", "<leader>fmt", function()
            require("stylua-nvim").format_file()
        end, { desc = "[F]or[M]a[T] (async)", unpack(bufopts) })
    end,
    settings = {
        Lua = {
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
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

lsp.skip_server_setup({'rust_analyzer'})
lsp.setup()

-- rust setup
local rust_lsp = lsp.build_options("rust_analyzer", {
    on_attach = on_attach,
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

require("rust-tools").setup({
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = " ",
            other_hints_prefix = " ",
            highlight = "NonText",
        },
    },
    server = rust_lsp,
})
