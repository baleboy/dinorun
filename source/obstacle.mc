import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * The obstacle class represents an object in the game that a player needs
  * to avoid. The class adds a bounding box to a scrolling object.
 */ 
class Obstacle extends ScrollingObject {

    // The margins for the bounding box, which are used to make 
    // the bounding box smaller than the image.
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
