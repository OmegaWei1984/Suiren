local skynet = require "skynet"
local s = require "service"
local runconf = require "runconf"
local mynode = skynet.getenv("node")

s.snode = nil
s.sname = nil

local function random_scene()
    local nodes = {}
    for i, _ in pairs(runconf.scene) do
        table.insert(nodes, i)
        if runconf.scene[mynode] then
            table.insert(nodes, mynode)
        end
    end
    local idx = math.random(1, #nodes)
    local scenenode = nodes[idx]
    local scenelist = runconf.scene[scenenode]
    idx = math.random(1, #scenelist)
    local sceneid = scenelist[idx]
    return scenenode, sceneid
end

s.client.enter = function(msg)
    if s.sname then
        return { "enter", 1, "已在场景" }
    end
    local snode, sid = random_scene()
    local sname = "scene" .. sid
    local isok = s.call(snode, sname, "enter", s.id, mynode, skynet.self())
    if not isok then
        return { "enter", 1, "进入失败" }
    end
    s.snode = snode
    s.sname = sname
    return nil
end

s.leave_scene = function ()
    if not s.sname then
        return
    end
    s.call(s.snode, s.sname, "leave", s.id)
    s.snode = nil
    s.sname = nil
end
