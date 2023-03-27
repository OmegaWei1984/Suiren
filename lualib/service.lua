local skynet = require "skynet"
local cluster = require "skynet.cluster"

function Traceback(err)
    skynet.error(tostring(err))
    skynet.error(debug.traceback())
end

local M = {
    name = "",
    id = 0,
    init = nil,
    exit = nil,
    resp = {}
}

local function dispatch(session, address, cmd, ...)
    local fun = M.resp[cmd]
    if not fun then
        skynet.ret()
        return
    end

    local ret = table.pack(xpcall(fun, Traceback, address, ...))
    local isOk = ret[1]

    if not isOk then
        skynet.ret()
        return
    end

    skynet.retpack(table.unpack(ret, 2))
end

function Init()
    skynet.dispatch("local", dispatch)
    if M.init then
        M.init()
    end
end

function M.start(name, id, ...)
    M.name = name
    M.id = tonumber(id)
    skynet.start(Init)
end

function M.call(node, srv, ...)
    local mynode = skynet.getenv("node")
    if node == mynode then
        return skynet.call(srv, "lua", ...)
    else
        return cluster.call(node, srv, ...)
    end
end

function M.send(node, srv, ...)
    local mynode = skynet.getenv("node")
    if node == mynode then
        return skynet.send(srv, "lua", ...)
    else
        return skynet.send(node, srv, ...)
    end
end

return M
