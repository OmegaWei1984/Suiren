local skynet = require "skynet"
local runconf = require "runconf"
local cluster = require "skynet.cluster"
local skynet_manager = require "skynet.manager"

skynet.start(function ()
    skynet.error("[start main]")

    local mynode = skynet.getenv("node")
    local nodecfg = runconf[mynode]
    -- nodemgr
    local nodemgr = skynet.newservice("nodemgr", "nodemgr", 0)
    skynet.name("nodemgr", nodemgr)
    -- cluster
    cluster.reload(runconf.cluster)
    cluster.open(mynode)
    -- gate
    for i, _ in pairs(nodecfg.gateway or {}) do
        local srv = skynet.newservice("gateway", "gateway", i)
        skynet.name("gateway"..i, srv)
    end
    -- login
    for i, _ in pairs(nodecfg.login or {}) do
       local srv = skynet.newservice("login", "login", i)
       skynet.name("login"..i, srv)
    end
    -- agentmgr
    local anode = runconf.agentmgr.node
    if mynode == anode then
        local srv = skynet.newservice("agentmgr", "agentmgr", 0)
        skynet.name("agentmgr", srv)
    else
        local proxy = cluster.proxy(anode, "agentmgr")
        skynet.name("agentmgr", proxy)
    end

    skynet.exit()
end)