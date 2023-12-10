import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class WheelchairApp extends Application.AppBase {

    var view = null;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {}

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        view= new WheelchairView();
        return [ view ] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() {
        if(view!=null) {
            view.load();
            WatchUi.requestUpdate();
        }
    }

}

function getApp() as WheelchairApp {
    return Application.getApp() as WheelchairApp;
}