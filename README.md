# Symfony Utils

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/ellisonleao/nvim-plugin-template/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A collection of helpful utilities for working with PHP Symfony in NeoVim

```lua
-- install via packer (etc)
use({ "rhydianjenkins/symfonyutils" })

-- optional setup
require('symfony_utils').setup({
    search_dirs = {
        -- defaults to '.'
        "path/to/config/dir",
        "path/to/other/config/dir",
    },
})
```

## TODO:

- [x] `GoToSymfonyDefinition`: Jumps from a source file to its yml definition
- [ ] `GoToDefinitionFile`: Jumps from a yml definition file to its source file (possibly add this to `GoToSymfonyDefinition`)
