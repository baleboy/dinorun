
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.System;

class dinorunView extends WatchUi.View {

    var lastFrameTime;
    const FRAME_RATE = 1000/20;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {

        $.game.loadResources(dc);

        lastFrameTime = System.getTimer();
        var myTimer = new Timer.Timer();
    	myTimer.start(method(:timerCallback), FRAME_RATE, true);
    }

    function timerCallback() as Void {
	    WatchUi.requestUpdate();
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        var thisTime = System.getTimer(); 
        var dt = thisTime - lastFrameTime;
        lastFrameTime = System.getTimer();

        $.game.update(dc, dt);
        $.game.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
