const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Player = struct {
    rect: rl.Rectangle,
    color: rl.Color,
    score: i32 = 0,
    pub fn drawPlayer(self: Player) void {
        rl.DrawRectangleRec(self.rect, self.color);
    }
};
