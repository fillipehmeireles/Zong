const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
const GameScreen = @import("game_screen.zig").GameScreen;
const GameBorders = @import("game_screen.zig").GameBorders;
const Border = @import("game_screen.zig").Border;
const Net = @import("game_screen.zig").Net;
const Player = @import("player.zig").Player;
const Ball = @import("ball.zig").Ball;
const mechanics = @import("mechanics.zig");

const W_WIDTH: c_int = 800;
const W_HEIGHT: c_int = 450;

pub fn main() !void {
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    // const allocator = gpa.allocator();
    const game_screen = GameScreen.init(W_WIDTH, W_HEIGHT);
    rl.InitWindow(game_screen.width, game_screen.height, "Zong");
    const game_borders = GameBorders{
        .top_border = Border{
            .rect = rl.Rectangle{ .y = 0, .x = 0, .width = W_WIDTH, .height = 8 },
        },
        .bottom_border = Border{
            .rect = rl.Rectangle{ .y = W_HEIGHT - 8, .x = 0, .width = W_WIDTH, .height = 8 },
        },
        .left_border = Border{
            .rect = rl.Rectangle{ .y = 0, .x = 0, .width = 8, .height = W_HEIGHT },
        },
        .right_border = Border{
            .rect = rl.Rectangle{ .y = 0, .x = W_WIDTH - 8, .width = 8, .height = W_HEIGHT },
        },
    };
    const game_net = Net{ .rect = rl.Rectangle{ .y = game_borders.top_border.rect.height, .x = W_WIDTH / 2, .width = 10, .height = W_HEIGHT - (game_borders.top_border.rect.height + game_borders.bottom_border.rect.height) } };
    var p1 = Player{ .rect = rl.Rectangle{ .y = W_HEIGHT / 2, .x = game_borders.left_border.rect.width, .width = 8, .height = 80 }, .color = rl.WHITE };
    var p2 = Player{ .rect = rl.Rectangle{ .y = W_HEIGHT / 2, .x = W_WIDTH - game_borders.right_border.rect.width - 10, .width = 10, .height = 80 }, .color = rl.WHITE };

    var ball = Ball{ .cX = W_WIDTH / 2, .cY = W_HEIGHT / 2, .radius = 8, .color = rl.WHITE };

    const score_text: [*c]const u8 = "0 : 0";
    // TODO dyn score
    // TODO player movements
    //_ = try std.fmt.bufPrint(&score_text, "{d} : {d}", .{ p1.score, p2.score });

    defer rl.CloseWindow();
    rl.SetTargetFPS(60);
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.ClearBackground(rl.BLACK);
        rl.DrawText(score_text, W_WIDTH / 2 - 10, game_borders.top_border.rect.height + 4, 30, rl.RED);
        game_borders.drawBorders();
        game_net.drawNet();
        p1.drawPlayer();
        p2.drawPlayer();
        ball.draw();
        ball.move();
        mechanics.checkCollisionBallBorders(game_borders, &ball);
        mechanics.checkPlayerScored(&p1, &p2, &ball, game_borders);
    }
}
