local has_plenary, plenary = pcall(require, "plenary")

if not has_plenary then
    error "This plugins requires plenary.nvim"
end

local scan = plenary.scandir

local function ext_is_desktop(path)
    local ext = vim.api.nvim_call_function("fnamemodify", { path, ":e" })
    return ext == "desktop"
end

local function get_filename(fullpath)
    local name = vim.api.nvim_call_function("fnamemodify", { fullpath, ":t" })
    return name
end

local function find_application_dirs()
    local res = {}

    local data_home = vim.fn.getenv "XDG_DATA_HOME"
    if data_home and data_home ~= "" and data_home ~= vim.NIL then
        table.insert(res, vim.fn.fnamemodify(data_home, ":p") .. "/applications")
    else
        local home = vim.fn.getenv "HOME"
        if not home or home == "" or home == vim.NIL then
            return nil, "Couldn't get home dir"
        end
        table.insert(res, home .. "/.local/share/applications")
    end

    local extra_data_dirs = vim.fn.getenv "XDG_DATA_DIRS"
    if extra_data_dirs and extra_data_dirs ~= "" and extra_data_dirs ~= vim.NIL then
        for dir in string.gmatch(extra_data_dirs, "[^:]+") do
            table.insert(res, dir .. "/applications")
        end
    else
        table.insert(res, "/usr/local/share/applications")
        table.insert(res, "/usr/share/applications")
    end

    return res
end

local function get_all_desktop_entries()
    local dirs = find_application_dirs()
    local all_pahtes = {}
    local path = require "plenary.path"
    for ind, dir in ipairs(dirs) do
        local p = path:new(dir)
        -- print(p)
        if p:exists() then
            local files = scan.scan_dir(dir, { hidden = false, depth = 1, add_dirs = false })
            for _, file in ipairs(files) do
                if ext_is_desktop(file) then
                    table.insert(all_pahtes, { get_filename(file), file })
                end
            end
        end
    end
    return all_pahtes
end

local function print_app_pathes()
    local dirs, err = find_application_dirs()
    if dirs then
        for _, dir in ipairs(dirs) do
            print(dir)
        end
    else
        print("Error:", err)
    end
end

local function exec_from_path(fullpath)
    if not ext_is_desktop(fullpath) then
        error "Executing non desktop entry"
        return
    end
    local command = ""
    local null = "/dev/null"
    if vim.fn.executable "gtk-launch" == 1 then
        command = "gtk-launch " .. get_filename(fullpath)
    elseif vim.fn.executable "dex" == 1 then
        command = "dex" .. fullpath
    else
        error "Require gtk or dex on path!"
        return
    end

    os.execute(command .. " > " .. null .. " 2>&1")
end

-- Examples:
--    local ds = require('myluamodule/definestuff')
--    ds.show_stuff()
--    local definestuff = require('myluamodule/definestuff')
--    definestuff.show_stuff()
return {
    exec_from_path = exec_from_path,
    get_all_desktop_entries = get_all_desktop_entries,
}
