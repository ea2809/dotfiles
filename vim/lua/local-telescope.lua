local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')

local M = {}


-- local fd_command = "fd --type file --color=always --follow --hidden --no-ignore-vcs --exclude .git"
local fd = {}
-- fd["find_command"] = {"fd","--type","file","--color=always","--follow","--hidden","--no-ignore-vcs"}
fd["find_command"] = {"fd","--type","file","--follow","--hidden"}
    
M.search_files = function()
    require("telescope.builtin").find_files(fd)
end

local fd_all = {}
fd_all["find_command"] = {"fd","--type","file","--follow","--hidden","--no-ignore-vcs"}
M.search_all_files = function()
    require("telescope.builtin").find_files(fd_all)
end

return M
