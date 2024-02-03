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

---@param regex_pattern string
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

---@param yaml_dirs table
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

---@param class_dirs table
---@param namespace string
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

---@param pattern string
---@return string, nil
M.search_pattern_and_capture = function(pattern)
    local bufnr = vim.api.nvim_get_current_buf()
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    for i = 1, line_count do
        local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1] -- Get the i-th line
        if line:find(pattern) then
            local match = line:match(pattern)
            if match then
                return match
            end
        end
    end
    return nil
end

return M
