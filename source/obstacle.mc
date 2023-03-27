import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * An obstacle is a scrolling object that has a bounding box.
 */ 
class Obstacle extends ScrollingObject {

    const MARGIN_X = 20;
    const MARGIN_Y = 20;

    var boundingBox;

    function initialize(x, y, imageResources, imageCount, speed) {
        ScrollingObject.initialize(x, y, imageResources, imageCount, speed);

        boundingBox = new BoundingBox(x + MARGIN_X, y + MARGIN_Y, 
                                    width - 2 * MARGIN_X, 
                                    height - 2 * MARGIN_Y);
    }

    function draw(dc as Dc) as Void {
        ScrollingObject.draw(dc);
        if (SHOW_BOUNDING_BOXES) {
            boundingBox.draw(dc);
        }
    }

    function update(dt) as Void {
        ScrollingObject.update(dt);
        boundingBox.x = x + MARGIN_X;
    }

    function place(x, y) {
        ScrollingObject.place(x, y);
        boundingBox.x = x + MARGIN_X;
        boundingBox.y = y + MARGIN_Y;
    }
}
