local skynet = require "skynet"
local runconf = require "runconf"

skynet.start(function ()
    skynet.error(runconf.agentmgr.node)
    skynet.exit()
end)