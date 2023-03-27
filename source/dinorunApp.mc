import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var game;

class dinorunApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();

        game = new Game();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new dinorunView(), new dinorunDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as dinorunApp {
    return Application.getApp() as dinorunApp;
}