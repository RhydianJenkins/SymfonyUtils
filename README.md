# Symfony Utils

A collection of helpful NeoVim utilities for working with PHP Symfony in NeoVim

```lua
-- install via packer (etc)
use({ "rhydianjenkins/symfonyutils" })

-- optional setup
require('symfony_utils').setup({
    -- both default to '.'
    class_dirs = {
        "path/to/php/classes/dir",
    },
    yaml_dirs = {
        "path/to/config/dir",
        "path/to/other/config/dir",
    },
})
```

## TODO:

- [x] `GoToSymfonyDefinition`: Jumps from a source file to its yml definition
- [x] `GoToDefinitionFile`: Jumps from a yml definition file to its source file (possibly add this to `GoToSymfonyDefinition`)
- [ ] Improve namespace checking when multiple files exist with the same name
