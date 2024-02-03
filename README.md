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

## TODO

Go to definition of yaml argument params, e.g.

```
arguments:
  - "@ai.openai.client"
```
