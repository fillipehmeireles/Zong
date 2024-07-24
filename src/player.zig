const rl = @cImport({
    @cInclude("raylib.h");
});
const GameBorders = @import("game_screen.zig").GameBorders;

pub const Player = struct {
    rect: rl.Rectangle,
    color: rl.Color,
    score: i32 = 0,
    step: f32 = 4,

    pub fn drawPlayer(self: Player) void {
        rl.DrawRectangleRec(self.rect, self.color);
    }

    pub fn move(self: *Player, key_pressed: rl.KeyboardKey, borders: GameBorders) void {
        if (key_pressed == rl.KEY_UP or key_pressed == rl.KEY_W) {
            if (rl.CheckCollisionRecs(self.rect, borders.top_border.rect)) {
                return;
            }
            self.rect.y -= self.step;
        } else if (key_pressed == rl.KEY_DOWN or key_pressed == rl.KEY_S) {
            if (rl.CheckCollisionRecs(self.rect, borders.bottom_border.rect)) {
                return;
            }
            self.rect.y += self.step;
        }
    }
};
