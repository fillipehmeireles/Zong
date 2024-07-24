const rl = @cImport({
    @cInclude("raylib.h");
});
const std = @import("std");

pub const GameStage = enum {
    GAME_MENU,
    GAME_GAMEPLAY,
    GAME_OVER,

    pub fn updateStage(self: *GameStage, new_stage: GameStage) void {
        self.* = new_stage;
    }
};

pub fn GameOver(w_width: i32, w_height: i32, p_winner: *i32) !void {
    var winner: *const [2:0]u8 = undefined;
    if (p_winner.* == 1) {
        winner = "P1";
    } else {
        winner = "P2";
    }
    var result_text: [17]u8 = undefined;
    _ = try std.fmt.bufPrint(&result_text, "{s} is the winner!", .{winner});
    const x = @divTrunc(w_width, 2);
    const y = @divTrunc(w_height, 2);
    const menu_text = "Press any key to go to menu";
    rl.DrawText(&result_text, x - 130, y, 50, rl.RED);
    rl.DrawText(menu_text, x - 130, w_height - 40, 20, rl.GRAY);
}

pub fn GameMenu(w_height: i32) void {
    const menu_text_h1 = "Zong";
    const menu_text_h2 = "Pong game made with Zig.";
    const menu_text_h3 = "Author: Fillipe Meireles";
    const menu_text = "Press any key to start";

    rl.DrawText(menu_text_h1, 100, 70, 90, rl.GRAY);
    rl.DrawText(menu_text_h2, 100, 200, 13, rl.GRAY);
    rl.DrawText(menu_text_h3, 100, 220, 13, rl.GRAY);
    rl.DrawText(menu_text, 100, w_height - 40, 20, rl.GRAY);
}
