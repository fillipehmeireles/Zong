const rl = @cImport({
    @cInclude("raylib.h");
});

const GameBorders = @import("game_screen.zig").GameBorders;
const Ball = @import("ball.zig").Ball;
const Player = @import("player.zig").Player;
const ScoreBoard = @import("scoreboard.zig").ScoreBoard;
const GameStage = @import("game_stage.zig").GameStage;

pub fn checkCollisionBallBorders(borders: GameBorders, ball: *Ball) void {
    if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.top_border.rect) or rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.bottom_border.rect)) {
        ball.stepY = -ball.stepY;
    }
}

pub fn checkCollisionBallPlayer(ball: *Ball, player: Player) void {
    if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, player.rect)) {
        ball.stepX = -ball.stepX;
    }
}

pub fn checkPlayerScored(p1: *Player, p2: *Player, ball: *Ball, borders: GameBorders, scoreBoard: *ScoreBoard) !void {
    if (!ball.active) {
        return;
    }
    if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.left_border.rect)) {
        p2.score += 1;
        try scoreBoard.update(p1.score, p2.score);
        ball.active = false;
    } else if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.right_border.rect)) {
        p1.score += 1;
        try scoreBoard.update(p1.score, p2.score);
        ball.active = false;
    }
}

pub fn manageGameStage(game_stage: *GameStage, p1_s: i32, p2_s: i32, winner: *i32) void {
    if (p1_s == 5 or p2_s == 5) {
        if (p1_s > p2_s) {
            winner.* = 1;
        } else {
            winner.* = 2;
        }
        game_stage.updateStage(GameStage.GAME_OVER);
    }
}
