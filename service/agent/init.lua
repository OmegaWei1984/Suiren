local skynet = require "skynet"
local s = require "service"

s.client = {}
s.gate = nil

require "scene"

s.resp.client = function(source, cmd, msg)
    s.gate = source
    if s.client[cmd] then
        local ret_msg = s.client[cmd](msg, source)
        if ret_msg then
            skynet.send(source, "lua", "send", s.id, ret_msg)
        end
    else
        skynet.error("s.resp.client fail", cmd)
    end
end

s.resp.kick = function(source)
    s.leave_scene()
    skynet.sleep(200)
end

s.resp.exit = function(source)
    skynet.exit()
end

s.resp.send = function (source, msg)
    skynet.send(s.gate, "lua", "send", s.id, msg)
end

s.client.work = function(msg)
    s.data.coin = s.data.coin + 1
    return { "work", s.data.coin }
end

s.client.shift = function (msg)
    if not s.sname then
        return
    end
    local x = msg[2] or 0
    local y = msg[3] or 0
    s.call(s.snode, s.sname, "shift", s.id, x, y)
end

s.init = function()
    skynet.sleep(200)
    s.data = {
        coin = 10,
        hp = 100
    }
end

s.start(...)
