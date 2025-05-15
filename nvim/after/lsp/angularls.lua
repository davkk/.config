local utils = require("utils")
local default = require("lspconfig.configs.angularls").default_config
local cmd = utils.append(default.cmd, "--forceStrictTemplates")

return {
    root_markers = { "angular.json", "nx.json", "Gruntfile.js" },
    cmd = cmd,
    workspace_required = true,
}
