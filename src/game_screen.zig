const rl = @cImport({
    @cInclude("raylib.h");
});

pub const GameScreen = struct {
    width: c_int,
    height: c_int,

    pub fn init(w: c_int, h: c_int) GameScreen {
        return GameScreen{
            .width = w,
            .height = h,
        };
    }
};

pub const Border = struct {
    rect: rl.Rectangle,
};

pub const GameBorders = struct {
    top_border: Border,
    bottom_border: Border,
    left_border: Border,
    right_border: Border,

    pub fn drawBorders(self: GameBorders) void {
        rl.DrawRectangleRec(self.top_border.rect, rl.GRAY);
        rl.DrawRectangleRec(self.bottom_border.rect, rl.GRAY);
        rl.DrawRectangleRec(self.left_border.rect, rl.GRAY);
        rl.DrawRectangleRec(self.right_border.rect, rl.GRAY);
    }
};

pub const Net = struct {
    rect: rl.Rectangle,

    pub fn drawNet(self: Net) void {
        rl.DrawRectangleRec(self.rect, rl.GRAY);
    }
};
