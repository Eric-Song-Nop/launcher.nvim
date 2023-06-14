local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("This plugins requires nvim-telescope/telescope.nvim")
else
    print("Loaded telescope")
end

local pickers = require("telescope.builtin")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function launcher(opts)
    opts = opts or {}
    pickers
        .new(opts, {
            prompt_title = "colors",
            finder = finders.new_table({
                results = { "red", "green", "blue" },
            }),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

return telescope.register_extension({ exports = { ["launcher"] = launcher, launcher = launcher } })
