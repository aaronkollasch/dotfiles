local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use, use_rocks)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Post-install/update hook with neovim command
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({ "nvim-treesitter/playground" })
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })

    -- LSP support with lsp-zero
    use({
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },

            -- Additional dependencies
            { "simrat39/rust-tools.nvim" },
        },
    })

    -- extra language support
    use("NoahTheDuke/vim-just")
    use("ckipp01/stylua-nvim")
    use("folke/neodev.nvim")
    use("aaronkollasch/vim-known_hosts")

    -- additional info sources
    use("rizzatti/dash.vim")
    use({ "mrjones2014/op.nvim", run = "make install" })

    -- Fuzzy Finder (files, lsp, etc)
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

    -- Telescope add-ons
    use({ "nvim-telescope/telescope-ui-select.nvim" })

    -- Code Actions
    use({
        "kosayoda/nvim-lightbulb",
        requires = "antoinemadec/FixCursorHold.nvim",
    })

    -- statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- statuscolumn
    use("lewis6991/gitsigns.nvim")

    -- tree view
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
    })
    use({
        -- 'ThePrimeagen/harpoon',
        -- '~/GitHub/harpoon',
        "aaronkollasch/harpoon",
        branch = "add-file-keymap-hints",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use("mbbill/undotree")

    -- splits management / tmux compatibility
    use("mrjones2014/smart-splits.nvim") -- replaces christoomey/vim-tmux-navigator
    use("aaronkollasch/vim-bufkill")
    use("markstory/vim-zoomwin") -- <leader>z to zoom, see also troydm/zoomwintab.vim

    -- hints
    use({
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({
                operators = {
                    gc = "Comments",
                    ["<space>p"] = "Paste",
                    ["<space>v"] = "Paste",
                }
            })
        end,
    })

    -- tpope
    use("numToStr/Comment.nvim") -- replaces tpope/vim-commentary
    use("tpope/vim-sleuth")
    use("tpope/vim-fugitive")
    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    use("tpope/vim-characterize")

    -- text actions
    use("junegunn/vim-easy-align")

    -- better <leader>p
    use("inkarkat/vim-ReplaceWithRegister")

    -- textobjects, see https://github.com/kana/vim-textobj-user/wiki
    use({ "kana/vim-textobj-line",      requires = "kana/vim-textobj-user" }) -- al/il for the current line
    use({ "kana/vim-textobj-indent",    requires = "kana/vim-textobj-user" }) -- ai/ii for a block of similarly indented lines / aI/iI for a block of lines with the same indentation
    use({ "kana/vim-textobj-entire",    requires = "kana/vim-textobj-user" }) -- ae/ie for the entire region of the current buffer
    use({ "sgur/vim-textobj-parameter", requires = "kana/vim-textobj-user" }) -- a,/i, for an argument to a function
    use({ "glts/vim-textobj-comment",   requires = "kana/vim-textobj-user" }) -- ac/ic for a comment

    -- colorscheme
    use("sainnhe/edge")

    -- <leader>fml
    use({
        "Eandrju/cellular-automaton.nvim",
        config = function()
            vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
