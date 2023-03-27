import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * An animated sprite that loops through a series of frames
 * specified as a list of bitmaps. The speed of the animation 
 * can be slowed down by specifying a number of ticks (game frames)
 * to wait before advancing to the next frame.
 */
class Animation {

    var frames;
    var framesPerTick;
    var frameIndex;
    var frameCount;
    var elapsedTicks;

    function initialize(frames, frameCount, framesPerTick) {
        self.frames = new [frameCount];
        for (var i = 0; i < frameCount; i++) {
            self.frames[i] = frames[i];
        }
        self.framesPerTick = framesPerTick;
        self.frameIndex = 0;
        self.frameCount = frameCount;
        self.elapsedTicks = 0;
    }

    function update() {
        elapsedTicks++;
        if (elapsedTicks >= framesPerTick) {
            elapsedTicks = 0;
            frameIndex++;
            if (frameIndex >= frameCount) {
                frameIndex = 0;
            }
        }
    }

    function getCurrentFrame() as Bitmap {
        return frames[frameIndex];
    }

    function draw(dc, x, y) as Void {
        dc.drawBitmap(x, y, frames[frameIndex]);
    }
}