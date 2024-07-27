all:
	zig build run

test-server:
	zig test ./server/server.zig
