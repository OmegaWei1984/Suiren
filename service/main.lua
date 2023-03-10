local skynet = require "skynet"
local socket = require "skynet.socket"

local function ping()
    skynet.error("main start")
    local ping1 = skynet.newservice("ping")
    local ping2 = skynet.newservice("ping")

    skynet.send(ping1, "lua", "start", ping2)
    skynet.exit()
end

local function connect(fd, addr)
    print("fd = "..fd.." connect addr = "..addr)
    socket.start(fd)
    while true do
        local readdata = socket.read(fd)
        if readdata ~= nil then
            print("fd = "..fd.." recv: "..readdata)
            socket.write(fd, "ehco "..readdata)
        else
            print("fd = "..fd.." close")
            socket.close(fd)
        end
    end
end

local function echo()
    local listenfd = socket.listen("0.0.0.0", 9000)
    socket.start(listenfd, function(fd, addr)
        print("fd = "..fd.." connect addr = "..addr)
        socket.start(fd)
        while true do
            local readdata = socket.read(fd)
            if readdata ~= nil then
                print("fd = "..fd.." recv: "..readdata)
                socket.write(fd, "ehco "..readdata)
            else
                print("fd = "..fd.." close")
                socket.close(fd)
            end
        end
    end)
end

local clients = {}

local function chat()
    local listenfd = socket.listen("0.0.0.0", 9000)
    socket.start(listenfd, function(fd, addr)
        print("fd = "..fd.." connect addr = "..addr)
        socket.start(fd)
        clients[fd] = {}
        while true do
            local readdata = socket.read(fd)
            if readdata ~= nil then
                print("fd = "..fd.." recv: "..readdata)
                for k, _ in pairs(clients) do
                    socket.write(k, fd.." said "..readdata)
                end
            else
                print("fd = "..fd.." close")
                socket.close(fd)
                clients[fd] = nil
            end
        end
    end)
end
-- skynet.start(ping)
-- skynet.start(echo)
skynet.start(chat)

