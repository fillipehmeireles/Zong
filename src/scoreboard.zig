const rl = @cImport({
    @cInclude("raylib.h");
});
const std = @import("std");
const GameBorders = @import("game_screen.zig").GameBorders;

pub const ScoreBoard = struct {
    p1_s: [1]u8,
    p2_s: [1]u8,
    color: rl.Color = rl.RED,

    pub fn init(p1s: i32, p2s: i32) !ScoreBoard {
        var p1: [1]u8 = undefined;
        var p2: [1]u8 = undefined;
        _ = try std.fmt.bufPrint(&p1, "{d}", .{p1s});
        _ = try std.fmt.bufPrint(&p2, "{d}", .{p2s});
        return .{
            .p1_s = p1,
            .p2_s = p2,
        };
    }

    pub fn draw(self: ScoreBoard, w_width: c_int, game_borders: GameBorders) !void {
        var score_text: [5]u8 = undefined;
        const x: c_int = @divTrunc(w_width, 2);
        const y: c_int = @intFromFloat(game_borders.top_border.rect.height);
        _ = try std.fmt.bufPrint(&score_text, "{s} : {s}", .{ self.p1_s, self.p2_s });
        rl.DrawText(&score_text, x - 25, y, 30, self.color);
    }

    pub fn update(self: *ScoreBoard, p1s: i32, p2s: i32) !void {
        var p1: [1]u8 = undefined;
        var p2: [1]u8 = undefined;
        _ = try std.fmt.bufPrint(&p1, "{d}", .{p1s});
        _ = try std.fmt.bufPrint(&p2, "{d}", .{p2s});
        self.p1_s = p1;
        self.p2_s = p2;
    }
};
