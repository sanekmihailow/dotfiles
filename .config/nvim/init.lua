    --#C- global variables
    --#C-  variables dont works with camelCase
req_func = require('core.functions')

    --#C- local variables
--print(vim.inspect(nv_version)) --debug
local version = vim.version()
local nv_version = tonumber(version.major .. "." .. version.minor)   

    --#C- includes
require("core.functions")
if nv_version >= 0.7 then require("core.keymaps") else require("old.keymap")
end    
require("core.sets")
require("core.colors")
require("core.plugins")
if nv_version >= 0.7 then require("core.autostart") else require("old.autostart")
end
if nv_version >= 0.7 then require("core.syntax") end
