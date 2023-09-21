vim.api.nvim_create_user_command("GoToSymfonyDefinition", require("symfony_definition").go_to_def, {})
