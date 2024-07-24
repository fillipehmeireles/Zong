const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Ball = struct {
    cX: c_int,
    cY: c_int,
    radius: f32,
    color: rl.Color,
    stepX: i32 = 4,
    stepY: i32 = 4,
    active: bool = true,

    pub fn draw(self: Ball) void {
        if (self.active) {
            rl.DrawCircle(self.cX, self.cY, self.radius, self.color);
        }
    }

    pub fn move(self: *Ball) void {
        self.cX -= self.stepX;
        self.cY += self.stepY;
    }
};
