local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local make_entry = require "telescope.make_entry"
local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local Path = require("plenary.path")

-- add line numbers to preview
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

-- custom previewers
local project_files = function()
    local opts = {} -- define here if you want to define something
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        require("telescope.builtin").git_files(opts)
    else
        require("telescope.builtin").find_files(opts)
    end
end

local changed_on_branch = function()
    pickers
        .new({
            results_title = "Modified in current directory",
            finder = finders.new_oneshot_job({
                "git",
                "diff",
                "--name-only",
                "--diff-filter=ACMR",
                "--relative",
                "HEAD",
            }),
            sorter = sorters.get_fuzzy_file(),
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    return {
                        "git",
                        "-c",
                        "core.pager=delta",
                        "-c",
                        "delta.side-by-side=false",
                        "diff",
                        "--diff-filter=ACMR",
                        "--relative",
                        "HEAD",
                        "--",
                        entry.value,
                    }
                end,
            }),
        })
        :find()
end

local changed_on_root = function()
    local rel_path = string.gsub(vim.fn.system("git rev-parse --show-cdup"), "^%s*(.-)%s*$", "%1")
    if vim.v.shell_error ~= 0 then
        return
    end
    pickers
        .new({
            results_title = "Modified on current branch",
            finder = finders.new_oneshot_job({
                "git",
                "diff",
                "--name-only",
                "HEAD",
            }),
            sorter = sorters.get_fuzzy_file(),
            previewer = previewers.new_termopen_previewer({
                get_command = function(entry)
                    return {
                        "git",
                        "-c",
                        "core.pager=delta",
                        "-c",
                        "delta.side-by-side=false",
                        "diff",
                        "HEAD",
                        "--",
                        rel_path .. entry.value,
                    }
                end,
            }),
        })
        :find()
end

local commits_in_project = function()
    return builtin.git_commits({
        git_command = {
            "git",
            "log",
            "--format=%h%d %s (%cr)",
        }
    })
end

local commits_in_buffer = function()
    return builtin.git_bcommits({
        git_command = {
            "git",
            "log",
            "--format=%h%d %s (%cr)",
        }
    })
end

local get_current_buf_line = function(winnr)
      local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
      return vim.trim(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(winnr), lnum - 1, lnum, false)[1])
end

local commits_in_selection = function(opts)
    -- git.bcommits from
    -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/__git.lua
    -- similar to fzf.vim Bcommits command
    -- see: https://github.com/junegunn/fzf.vim/blob/dc71692255b62d1f67dc55c8e51ab1aa467b1d46/autoload/fzf/vim.vim#L1278
    local conf = require("telescope.config").values

    opts = vim.F.if_nil(opts, {})
    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    else
        opts.cwd = vim.loop.cwd()
    end
    opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
    opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
    opts.current_line = (opts.current_file == nil) and get_current_buf_line(opts.winnr) or nil
    opts.current_file = vim.F.if_nil(opts.current_file, vim.api.nvim_buf_get_name(opts.bufnr))
    opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

    -- get visual selection
    -- from https://github.com/b3nj5m1n/kommentary/blob/3a80117148c6798972bb69414423311ab151d368/lua/kommentary/init.lua#LL95C9-L96C43
    -- potentially update with https://github.com/neovim/neovim/pull/13896
    local line_number_start = vim.fn.line("v")
    local line_number_end = vim.fn.line(".")
    local line_range = string.format(
        "%d,%d:%s",
        line_number_start,
        line_number_end,
        Path:new(opts.current_file):make_relative(opts.cwd)
    )
    print(vim.inspect(line_range))

    local git_command = {
        "git",
        "log",
        "--format=%h%d %s (%cr)",
        "--no-patch",
        "-L",
        line_range,
        -- "--exclude",
    }
    pickers
        .new(opts, {
            prompt_title = "Git BCommits",
            finder = finders.new_oneshot_job(
                git_command,
                -- vim.tbl_flatten {
                --     git_command,
                --     opts.current_file,
                -- },
                opts
            ),
            previewer = {
                previewers.git_commit_diff_to_parent.new(opts),
                previewers.git_commit_diff_to_head.new(opts),
                previewers.git_commit_diff_as_was.new(opts),
                previewers.git_commit_message.new(opts),
            },
            sorter = conf.file_sorter(opts),
            attach_mappings = function()
                actions.select_default:replace(actions.git_checkout_current_buffer)
                local transfrom_file = function()
                    return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ""
                end

                local get_buffer_of_orig = function(selection)
                    local value = selection.value .. ":" .. transfrom_file()
                    local content = utils.get_os_command_output({ "git", "--no-pager", "show", value }, opts.cwd)

                    local bufnr = vim.api.nvim_create_buf(false, true)
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
                    vim.api.nvim_buf_set_name(bufnr, "Original")
                    return bufnr
                end

                local vimdiff = function(selection, command)
                    local ft = vim.bo.filetype
                    vim.cmd("diffthis")

                    local bufnr = get_buffer_of_orig(selection)
                    vim.cmd(string.format("%s %s", command, bufnr))
                    vim.bo.filetype = ft
                    vim.cmd("diffthis")

                    vim.api.nvim_create_autocmd("WinClosed", {
                        buffer = bufnr,
                        nested = true,
                        once = true,
                        callback = function()
                            vim.api.nvim_buf_delete(bufnr, { force = true })
                        end,
                    })
                end

                actions.select_vertical:replace(function(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    vimdiff(selection, "leftabove vert sbuffer")
                end)

                actions.select_horizontal:replace(function(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    vimdiff(selection, "belowright sbuffer")
                end)

                actions.select_tab:replace(function(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    vim.cmd("tabedit " .. transfrom_file())
                    vimdiff(selection, "leftabove vert sbuffer")
                end)
                return true
            end,
        })
        :find()
end

-- picker keymaps
vim.keymap.set("n", "<leader>lf",       builtin.find_files,     { desc = "[L]ocate [F]iles" })
vim.keymap.set("n", "<leader>lg",       builtin.git_files,      { desc = "[L]ocate [G]itfiles" })
vim.keymap.set("n", "<C-p>",            project_files,          { desc = "Find project files" })
vim.keymap.set("n", "<C-f>",            builtin.find_files,     { desc = "Find project files" })
vim.keymap.set("n", "<leader>*",        builtin.grep_string,    { desc = "Project search current word" })
vim.keymap.set("n", "<leader>#",        builtin.grep_string,    { desc = "Project search current word" })
vim.keymap.set("n", "<leader>rg",       builtin.live_grep,      { desc = "[R]ip[G]rep" })
vim.keymap.set("n", "<leader>ls",       builtin.live_grep,      { desc = "[L]ocal  [S]earch" })

-- git
vim.keymap.set("n", "<leader>gm",       changed_on_branch,      { desc = "[G]it [M]odified files" })
vim.keymap.set("n", "<leader>gd",       changed_on_root,        { desc = "[G]it [D]iff" })
vim.keymap.set("n", "<leader>ga",       builtin.git_status,     { desc = "[G]it [A]dd" })
vim.keymap.set("n", "<leader>gl",       commits_in_project,     { desc = "[G]it [L]og" })
vim.keymap.set("n", "<leader>gh",       commits_in_buffer,      { desc = "[G]it buffer [H]istory" })
vim.keymap.set("v", "<leader>gh",       commits_in_selection,   { desc = "[G]it buffer [H]istory" })

-- buffers
vim.keymap.set("n", "<leader>lb",       builtin.buffers,        { desc = "[L]oaded [B]uffers" })
vim.keymap.set("n", "<leader>/",        builtin.current_buffer_fuzzy_find,
                                                                { desc = "[/] Fuzzily search in current buffer" })

-- f-keymaps
vim.keymap.set("n", "<leader>fh",       builtin.oldfiles,       { desc = "[F]ile [H]istory" })
vim.keymap.set("n", "<leader>fl",       function()
    builtin.oldfiles({ cwd_only = true })
end,                                                            { desc = "[F]ile [L]ocal History" })
vim.keymap.set("n", "<leader>fn",       builtin.treesitter,     { desc = "[F]ind [N]ames" })
vim.keymap.set("n", "<leader>fd",       builtin.diagnostics,    { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fs",       builtin.spell_suggest,  { desc = "[F]ind [S]pelling suggestions" })
vim.keymap.set("n", "<leader>f/",       builtin.help_tags,      { desc = "[F]ind [/] Help" })
vim.keymap.set("n", "<leader>fk",       builtin.keymaps,        { desc = "[F]ind [K]eys" })
vim.keymap.set("n", "<leader>fo",       builtin.vim_options,    { desc = "[F]ind [O]ptions" })
vim.keymap.set("n", "<leader>f;",       builtin.commands,       { desc = "[F]ind [;] Commands" })
vim.keymap.set("n", "<leader>fb",       builtin.builtin,        { desc = "[F]ind [B]uiltin pickers" })
vim.keymap.set("n", "<leader>f\"",      builtin.registers,      { desc = "[F]ind [\"] registers" })
vim.keymap.set("n", "<leader>f'",       builtin.marks,          { desc = "[F]ind ['] marks" })
vim.keymap.set("n", "<leader>fj",       builtin.jumplist,       { desc = "[F]ind [J]umps" })
vim.keymap.set("n", "<leader>fq",       builtin.quickfix,       { desc = "[F]ind [Q]uickfix" })

vim.keymap.set("n", "<leader>fp",       builtin.pickers,        { desc = "[F]ind [P]ickers to resume" })
vim.keymap.set("n", "<leader>rf",       builtin.resume,         { desc = "[R]esume last [F]ind" })

vim.keymap.set("c", "<C-f>",            builtin.command_history, { desc = "Search command history" })

-- options

-- jump file pickers to line with colon
-- https://www.youtube.com/watch?v=X35yfs3yvKw&t=443s
-- https://gitter.im/nvim-telescope/community/?at=6113b874025d436054c468e6
local find_file_config = {
    on_input_filter_cb = function(prompt)
        local find_colon = string.find(prompt, ":")
        if find_colon then
            local ret = string.sub(prompt, 1, find_colon - 1)
            vim.schedule(function()
                local prompt_bufnr = vim.api.nvim_get_current_buf()
                local picker = action_state.get_current_picker(prompt_bufnr)
                local lnum = tonumber(prompt:sub(find_colon + 1))
                if type(lnum) == "number" then
                    local win = picker.previewer.state.winid
                    local bufnr = picker.previewer.state.bufnr
                    local line_count = vim.api.nvim_buf_line_count(bufnr)
                    vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
                end
            end)
            return { prompt = ret }
        end
    end,
    attach_mappings = function()
        actions.select_default:enhance({
            post = function()
                -- if we found something, go to line
                local prompt = action_state.get_current_line()
                local find_colon = string.find(prompt, ":")
                if find_colon then
                    local lnum = tonumber(prompt:sub(find_colon + 1))
                    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
                end
            end,
        })
        return true
    end,
}

require("telescope").setup({
    defaults = {
        set_env = {
            LESS = "",
            DELTA_PAGER = "less",
        },
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-e>"] = "preview_scrolling_up",
            },
        },
        cache_picker = {
            num_pickers = 30,
        },
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker

        find_files = find_file_config,
        git_files = find_file_config,
        oldfiles = find_file_config,
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure

        -- fzf = {
        --   fuzzy = true,                    -- false will only do exact matching
        --   override_generic_sorter = true,  -- override the generic sorter
        --   override_file_sorter = true,     -- override the file sorter
        --   case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        --                                    -- the default case_mode is "smart_case"
        -- },

        ["ui-select"] = {
            require("telescope.themes").get_cursor({
                -- even more opts
            }),

            -- pseudo code / specification for writing custom displays, like the one
            -- for "codeactions"
            -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
            --   codeactions = false,
            -- }
        },
    },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
