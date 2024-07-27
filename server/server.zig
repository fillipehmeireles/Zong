const std = @import("std");
const expect = std.testing.expect;
const net = std.net;
const os = std.os;
const server_config = @import("server-config.zig");

const Server = struct {
    address: std.net.Address,
    socket: std.posix.socket_t,

    fn init(ip: []const u8, port: u16) !Server {
        const parsed_address = try std.net.Address.parseIp4(ip, port);
        const sock = try std.posix.socket(std.posix.AF.INET, std.posix.SOCK.DGRAM, 0);
        errdefer os.closeServer(sock);
        return Server{ .address = parsed_address, .socket = sock };
    }

    fn bind(self: *Server) !void {
        try std.posix.bind(self.socket, &self.address.any, self.address.getOsSockLen());
    }

    fn listen(self: *Server) !void {
        var buffer: [1024]u8 = undefined;

        while (true) {
            const received_bytes = try std.posix.recvfrom(self.socket, buffer[0..], 0, null, null);
            std.debug.print("Received {d} bytes: {s}\n", .{ received_bytes, buffer[0..received_bytes] });
        }
    }
};

pub fn main() !void {
    var server = try Server.init(server_config.SERVER_ADDR, server_config.SERVER_PORT);

    try server.bind();
    try server.listen();
}

test "create a socket" {
    const server = try Server.init(server_config.SERVER_ADDR, server_config.SERVER_PORT);
    try expect(@TypeOf(server.socket) == std.posix.socket_t);
}
