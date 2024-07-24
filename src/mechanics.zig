const rl = @cImport({
    @cInclude("raylib.h");
});

const GameBorders = @import("game_screen.zig").GameBorders;
const Ball = @import("ball.zig").Ball;
const Player = @import("player.zig").Player;

pub fn checkCollisionBallBorders(borders: GameBorders, ball: *Ball) void {
    if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.top_border.rect) or rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.bottom_border.rect)) {
        ball.stepY = -ball.stepY;
    }
}

pub fn checkPlayerScored(p1: *Player, p2: *Player, ball: *Ball, borders: GameBorders) void {
    if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.left_border.rect)) {
        p1.score += 1;
    } else if (rl.CheckCollisionCircleRec(rl.Vector2{ .x = @floatFromInt(ball.cX), .y = @floatFromInt(ball.cY) }, ball.radius, borders.right_border.rect)) {
        p2.score += 1;
    }
}
