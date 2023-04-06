local skynet = require "skynet"
local s = require "service"
local runconf = require "configs.runconf"
local socket = require "skynet.socket"

local conns = {}
local player = {}

local function conn()
    local m = {
        fd = nil,
        playerid = nil
    }
    return m
end

local function gateplayer()
    local m = {
        playerid = nil,
        agent = nil,
        conn = nil
    }
    return m
end

function s.init()
    local recv_loop = function (fd)
        socket.start(fd)
        skynet.error("socket connected " .. fd)
        local readbuff = ""
        while true do
            -- todo
        end
    end

    local connect = function(fd, addr)
        print("connect from" .. addr .. " " .. fd)
        local c = conn()
        conns[fd] = c
        c.fd = fd
        skynet.fork(recv_loop, fd)
    end

    skynet.error("[start]" .. s.name .. " " .. s.id)
    local node = skynet.getenv("node")
    local nodecfg = runconf[node]
    local port = nodecfg.gateway[s.id].port


    local listenfd = socket.listen("0.0.0.0", port)
    skynet.error("Listen socket: ", "0.0.0.0", port)
    socket.start(listenfd, connect)
end

s.start(...)
