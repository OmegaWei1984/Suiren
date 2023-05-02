local skynet = require "skynet"
local s = require "service"

s.client = {}

s.resp.client = function(source, fd, cmd, msg)
    if s.client[cmd] then
        local ret_msg = s.client[cmd](fd, msg, source)
        skynet.send(source, "lua", "send_by_fd", fd, ret_msg)
    else
        skynet.error("s.resp.client fail", cmd)
    end
end

s.client.login = function(fd, msg, source)
    local playerid = tonumber(msg[2])
    local pw = tonumber(msg[3])
    local gate = source
    local node = skynet.getenv("node")
    if pw ~= 123 then
        return { "login", 1, "密码错误" }
    end
    local isok, agent = skynet.call("agentmgr", "lua", "relogin", playerid, node, gate)
    if not isok then
        return { "login", 1, "请求 mgr 失败" }
    end
    isok = skynet.call(gate, "lua", "sure_agent", fd, playerid, agent)
    if not isok then
        return { "login", 1, "gate 注册失败" }
    end
    skynet.error("login success " .. playerid)
    return { "login", 0, "登录成功" }
end

s.start(...)
