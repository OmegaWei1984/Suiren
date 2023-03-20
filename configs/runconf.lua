return {
    cluster = {
        node1 = "127.0.0.1:10001",
        node2 = "127.0.0.1:10002",
    },
    agentmgr = {
        node = "node1"
    },
    scene = {
        node1 = { 1001, 1002 },
    },
    node1 = {
        gateway = {
            [1] = { port = 10011 },
            [2] = { port = 10012 },
        },
        login = {
            [1] = {},
            [2] = {},
        },
    },
    node2 = {
        gateway = {
            [1] = { port = 10021 },
            [2] = { port = 10022 },
        },
        login = {
            [1] = {},
            [2] = {},
        },
    },
}