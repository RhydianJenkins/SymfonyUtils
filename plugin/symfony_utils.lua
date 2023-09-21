vim.api.nvim_create_user_command("GoToSymfonyDefinition", require("symfony_utils").go_to_def, {})
