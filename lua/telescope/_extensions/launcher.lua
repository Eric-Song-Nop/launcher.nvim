local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("This plugins requires nvim-telescope/telescope.nvim")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local launcher_lib = require("launcher.launcher")

local function find()
    local v = launcher_lib.get_all_desktop_entries()
    if v == vim.NIL then
        return {}
    end
    return v
end

local function launch(opts)
    opts = opts or {}
    pickers
        .new(opts, {
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    launcher_lib.exec_from_path(selection[1])
                end)
                return true
            end,
            prompt_title = "laucher",
            finder = finders.new_table(find()),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

return telescope.register_extension({
    exports = {
        launcher = launch,
    },
})
