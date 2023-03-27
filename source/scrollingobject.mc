import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * An object that can be scrolled across the screen, and optionally looped back
 * to the start while also rotating through a list of images. Does not collide
 * with other objects.
 */ 
class ScrollingObject {
    var x;
    var y;
    var width;
    var height;
    var images;
    var imageCount;
    var currentImage;
    var speed;
    var looping = false;
    var start_x;
    var passed = 0;

    function initialize(x, y, imageResources, imageCount, speed) {
        self.x = x;
        self.y = y;
        self.imageCount = imageCount;
        self.images = new[imageCount];
        for (var i = 0; i < imageCount; i++) {
            self.images[i] = WatchUi.loadResource(imageResources[i]);
        }
        self.currentImage = 0;
        self.width = images[0].getWidth();
        self.height = images[0].getHeight();
        self.speed = speed;
    }

    function loopTo(start_x) {
        self.looping = true;
        self.start_x = start_x;
    }

    function draw(dc as Dc) as Void {
        dc.drawBitmap(x, y, images[currentImage]);
    }

    function update(dt) as Void {
        // loop to the start position and move to next image
        if (!self.isVisible() && looping) {
            self.place(start_x, y);
            currentImage = (currentImage + 1) % imageCount;
            width = images[currentImage].getWidth();
            height = images[currentImage].getHeight();
            passed++;
        }
        x -= speed * dt;
    }

    function isVisible() {
        return (x + images[currentImage].getWidth()) > 0;
    }

    function place(x, y) {
        self.x = x;
        self.y = y;
    }

    function reset() {
        self.place(start_x, y);
        currentImage = 0;
        width = images[0].getWidth();
        height = images[0].getHeight();
        passed = 0;
    }

    function getPassed() {
        return passed;
    }
}