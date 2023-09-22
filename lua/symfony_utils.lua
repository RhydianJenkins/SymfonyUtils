local M = {}

M.config = {
    search_dirs = { "." },
}

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

local function regex_exists_in_file(file_path, regex_pattern)
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

local function goto_line_matching_regex(regex_pattern)
    local last_line = vim.fn.line("$")

    for line_number = 0, last_line do
        local line_text = vim.fn.getline(line_number)
        if vim.fn.match(line_text, regex_pattern) > -1 then
            vim.cmd(":" .. line_number)
            return
        end
    end

    print("No line matching the regex found.")
end

local function get_yml_files()
    local all_files = {}

    for _, dir in ipairs(M.config.search_dirs) do
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

local function go_to_yml_definition()
    local word = vim.fn.expand("<cword>")
    local search_regex = "class:.*.\\" .. word .. "$"
    local yml_files = get_yml_files()

    for _, file in ipairs(yml_files) do
        if regex_exists_in_file(file, search_regex) then
            vim.cmd("e " .. file)
            goto_line_matching_regex(search_regex)
            return
        end
    end

    print("Symfony definition not found for: " .. word)
end

M.go_to_def = function()
    if vim.bo.filetype == 'yml' or vim.bo.filetype == 'yaml' then
        print('TODO go to definition')
        return
    end

    go_to_yml_definition()
end

return M
