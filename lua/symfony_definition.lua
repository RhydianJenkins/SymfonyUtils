---@class Config
local config = {}

---@class SymfonyDefinition
local M = {}

---@type Config
M.config = config

---@param args Config?
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
    local current_line = vim.fn.line('.')
    local last_line = vim.fn.line('$')

    for line_number = current_line, last_line do
        local line_text = vim.fn.getline(line_number)
        if vim.fn.match(line_text, regex_pattern) > -1 then
            vim.cmd(':' .. line_number)
            return
        end
    end

    print("No line matching the regex found.")
end

M.go_to_def = function()
    local word = vim.fn.expand('<cword>')
    local search_dirs = { "config/di/", "connect/app/" }
    local pattern = "**/*.yml"

    for _, dir in ipairs(search_dirs) do
        local yaml_files = vim.fn.globpath(dir, pattern, true, true)

        for _, file in ipairs(yaml_files) do
            local search_regex = 'class:.*.\\' .. word .. '$';
            if regex_exists_in_file(file, search_regex) then
                vim.cmd("e " .. file)
                goto_line_matching_regex(search_regex)
                return
            end
        end
    end

    print("Symfony definition not found for: " .. word)
end

return M
