//TODO Error handling

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
const ScoreBoard = @import("scoreboard.zig").ScoreBoard;
const GameMenu = @import("game_stage.zig").GameMenu;
const GameOver = @import("game_stage.zig").GameOver;
const GameStage = @import("game_stage.zig").GameStage;
const mechanics = @import("mechanics.zig");

const W_WIDTH: c_int = 800;
const W_HEIGHT: c_int = 450;

pub fn main() !void {
    //var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //defer _ = gpa.deinit();
    // const allocator = gpa.allocator();
    const game_screen = GameScreen.init(W_WIDTH, W_HEIGHT);
    rl.InitWindow(game_screen.width, game_screen.height, "Zong");
    const game_borders: GameBorders = .{
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
    const game_net: Net = .{ .rect = rl.Rectangle{ .y = game_borders.top_border.rect.height, .x = W_WIDTH / 2, .width = 10, .height = W_HEIGHT - (game_borders.top_border.rect.height + game_borders.bottom_border.rect.height) } };
    var p1: Player = .{ .rect = rl.Rectangle{ .y = W_HEIGHT / 2, .x = game_borders.left_border.rect.width, .width = 8, .height = 80 }, .color = rl.WHITE };
    var p2 = Player{ .rect = rl.Rectangle{ .y = W_HEIGHT / 2, .x = W_WIDTH - game_borders.right_border.rect.width - 10, .width = 10, .height = 80 }, .color = rl.WHITE };

    var winner: i32 = undefined;
    var ball = Ball{ .cX = W_WIDTH / 2, .cY = W_HEIGHT / 2, .radius = 8, .color = rl.WHITE };

    var score_board = try ScoreBoard.init(p1.score, p2.score);

    const interval: f32 = 2;
    var timer: f32 = 0;
    var game_stage: GameStage = GameStage.GAME_MENU;
    defer rl.CloseWindow();
    rl.SetTargetFPS(60);
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.ClearBackground(rl.BLACK);
        switch (game_stage) {
            GameStage.GAME_MENU => {
                GameMenu(W_HEIGHT);
                if (rl.GetKeyPressed() != 0) {
                    game_stage.updateStage(GameStage.GAME_GAMEPLAY);
                }
            },
            GameStage.GAME_OVER => {
                try GameOver(W_WIDTH, W_HEIGHT, &winner);
                if (rl.GetKeyPressed() != 0) {
                    game_stage.updateStage(GameStage.GAME_MENU);
                    p1.score = 0;
                    p2.score = 0;
                    try score_board.update(0, 0);
                }
            },

            GameStage.GAME_GAMEPLAY => {
                if (!ball.active) {
                    const dt = rl.GetFrameTime();
                    timer += dt;
                    if (timer >= interval) {
                        ball = Ball{ .cX = W_WIDTH / 2, .cY = W_HEIGHT / 2, .radius = 8, .color = rl.WHITE };
                        timer = 0;
                    }
                }
                mechanics.manageGameStage(&game_stage, p1.score, p2.score, &winner);
                game_borders.drawBorders();
                game_net.drawNet();
                p1.drawPlayer();
                p2.drawPlayer();
                try score_board.draw(game_screen.width, game_borders);
                ball.draw();
                ball.move();
                mechanics.checkCollisionBallBorders(game_borders, &ball);
                try mechanics.checkPlayerScored(&p1, &p2, &ball, game_borders, &score_board);
                mechanics.checkCollisionBallPlayer(&ball, p1);
                mechanics.checkCollisionBallPlayer(&ball, p2);
                var p1_key_pressed: rl.KeyboardKey = 0;
                var p2_key_pressed: rl.KeyboardKey = 0;
                if (rl.IsKeyDown(rl.KEY_DOWN)) p1_key_pressed = rl.KEY_DOWN;
                if (rl.IsKeyDown(rl.KEY_UP)) p1_key_pressed = rl.KEY_UP;
                if (rl.IsKeyDown(rl.KEY_W)) p2_key_pressed = rl.KEY_W;
                if (rl.IsKeyDown(rl.KEY_S)) p2_key_pressed = rl.KEY_S;
                if (p1_key_pressed != 0) {
                    p1.move(p1_key_pressed, game_borders);
                }
                if (p2_key_pressed != 0) {
                    p2.move(p2_key_pressed, game_borders);
                }
            },
        }
    }
}
