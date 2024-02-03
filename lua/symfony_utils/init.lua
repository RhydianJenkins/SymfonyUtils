local M = {}

local utils = require("symfony_utils.utils")

M.config = {
    yaml_dirs = { "." },
    class_dirs = { "." },
}

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

local function go_to_yml_definition()
    local class_name = vim.fn.expand("<cword>")
    local search_regex = "class:.*.\\" .. class_name .. "$"
    local yml_files = utils.get_yml_files(M.config.yaml_dirs)

    for _, file in ipairs(yml_files) do
        if utils.regex_exists_in_file(file, search_regex) then
            vim.cmd("e " .. file)
            utils.goto_line_matching_regex(search_regex)
            return
        end
    end

    print("Symfony definition not found for: " .. search_regex)
end

local function go_to_class_definition()
    local line = vim.fn.getline(".")
    local class_name = string.match(line, ".*\\(.*)")
    local namespace = string.match(line, ".*%s(.*)\\.*") or ""

    if not class_name then
        print("No class name found on line")
        return
    end

    local class_files = utils.get_class_files(M.config.class_dirs, namespace)
    local file_name = class_name .. ".php$"
    local filtered_files = vim.tbl_filter(function(file)
        return string.match(file, file_name)
    end, class_files)

    if #filtered_files == 0 then
        print("No files found with the name")
        return
    end

    if #filtered_files == 1 then
        vim.cmd("e " .. filtered_files[1])
        return
    end

    vim.ui.select(filtered_files, {
        prompt = #filtered_files .. " found. Select one:",
    }, function(choice)
        vim.cmd("e " .. choice)
    end)
end

M.go_to_def = function()
    if vim.bo.filetype == "yml" or vim.bo.filetype == "yaml" then
        return go_to_class_definition()
    end

    go_to_yml_definition()
end

return M
