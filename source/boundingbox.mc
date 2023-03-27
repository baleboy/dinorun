import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * A bounding box that can collide with other bounding boxes.
 * Can be drawn as a red rectangle for debugging purposes. 
 */
class BoundingBox {
    var x;
    var y;
    var width;
    var height;

    function initialize(x, y, width, height) {
        self.x = x;
        self.y = y;
        self.width = width;
        self.height = height;
    }

    function isColliding(other as BoundingBox) {
        return (x < other.x + other.width) && (x + width > other.x) && (y < other.y + other.height) && (y + height > other.y);
    }

    function draw(dc as Dc) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.drawRectangle(x, y, width, height);
    }
}