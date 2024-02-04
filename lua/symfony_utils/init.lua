local M = {}

local utils = require("symfony_utils.utils")

M.config = {
    yaml_dirs = { "." },
    class_dirs = { "." },
}

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

---@param search_regex string
local function go_to_yml_definition(search_regex)
    local yml_files = utils.get_yml_files(M.config.yaml_dirs)
    local found_files = {}

    for _, file in ipairs(yml_files) do
        if utils.regex_exists_in_file(file, search_regex) then
            table.insert(found_files, file)
        end
    end

    if #found_files == 0 then
        print("Symfony definition not found for: " .. search_regex)
    end

    if #found_files == 1 then
        vim.cmd("e " .. found_files[1])
        utils.goto_line_matching_regex(search_regex)
    end

    if #found_files > 1 then
        vim.ui.select(found_files, {
            prompt = #found_files .. " found. Select one:",
        }, function(choice)
            vim.cmd("e " .. choice)
            utils.goto_line_matching_regex(search_regex)
        end)
    end
end

---@param class_name string
---@param namespace string, nil
local function go_to_class_definition(class_name, namespace)
    local class_files = utils.get_class_files(M.config.class_dirs, namespace)
    local file_name = "/" .. class_name .. ".php$"
    local filtered_files = vim.tbl_filter(function(file)
        return string.match(file, file_name)
    end, class_files)

    if #filtered_files == 0 then
        print("No files found with the name '" .. file_name .. "'")
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

local function find_definition_from_yml_file()
    local line = vim.fn.getline(".")

    if string.match(line, ".*[\"']@.*") then
        local container_service_name = string.match(line, ".*@(.*)[\"']")

        go_to_yml_definition(" " .. container_service_name .. ":$")
        return
    end

    if string.match(line, ".*class:.*") then
        local class_name = string.match(line, ".*\\(.*)")
        local namespace = string.match(line, ".*%s(.*)\\.*") or ""

        if not class_name then
            print("No class name found on line")
            return
        end

        go_to_class_definition(class_name, namespace)
        return
    end

    print("No class or service definition found on line")
end

local function find_definition_from_php_file()
    local line = vim.fn.getline(".")
    local class_name = vim.fn.expand("<cword>")

    if string.match(line, ".*class .*") then
        local namespace = utils.search_pattern_and_capture("namespace (.*)")
        namespace = string.match(namespace, "(.*);") or namespace
        local full_class_name = namespace .. "\\" .. class_name

        go_to_yml_definition("class: " .. full_class_name .. "$")
        return
    end

    go_to_yml_definition("class: .*\\" .. class_name .. "$")
end

M.go_to_def = function()
    local filetype = vim.bo.filetype

    if filetype == "yml" or filetype == "yaml" then
        find_definition_from_yml_file()
        return
    end

    if filetype == "php" then
        find_definition_from_php_file()
        return
    end

    print("Unsupported filetype " .. filetype)
end

return M
