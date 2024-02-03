local M = {}

M.regex_exists_in_file = function(file_path, regex_pattern)
    local file = io.open(file_path, "r")

    if file then
        for line in file:lines() do
            if string.match(line, regex_pattern) then
                file:close()
                return true
            end
        end
        file:close()
    end

    return false
end

M.goto_line_matching_regex = function(regex_pattern)
    local last_line = vim.fn.line("$")

    for line_number = 0, last_line do
        local line_text = vim.fn.getline(line_number)
        if string.match(line_text, regex_pattern) then
            vim.cmd(":" .. line_number)
            return
        end
    end

    print("No line found matching: '" .. regex_pattern .. "'")
end

M.get_yml_files = function(yaml_dirs)
    local all_files = {}

    for _, dir in ipairs(yaml_dirs) do
        local yml_files = vim.fn.globpath(dir, "**/*.yml", true, true)
        for _, file in ipairs(yml_files) do
            table.insert(all_files, file)
        end

        local yaml_files = vim.fn.globpath(dir, "**/*.yaml", true, true)
        for _, file in ipairs(yaml_files) do
            table.insert(all_files, file)
        end
    end

    return all_files
end

M.get_class_files = function(class_dirs, namespace)
    local all_files = {}

    for _, dir in ipairs(class_dirs) do
        local class_files = vim.fn.globpath(dir, "**/*.php", true, true)
        for _, file in ipairs(class_files) do
            if not namespace or M.regex_exists_in_file(file, "namespace " .. namespace) then
                table.insert(all_files, file)
            end
        end
    end

    return all_files
end

return M
