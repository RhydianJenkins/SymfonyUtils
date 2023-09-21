# Symfony Utils

A collection of helpful NeoVim utilities for working with PHP Symfony in NeoVim

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
