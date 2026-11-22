import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class CountDirectionType {
    enum {
        CountUp,
        CountDown,
        Paused
    }
}

class CountUpDownApp extends Application.AppBase {
    private var appView;
    private var appDelegate;

    function initialize() {
        Utils.log("CountUpDownApp: initialize()");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        Utils.log("CountUpDownApp: onStart()");
        Settings.loadSettings();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Utils.log("CountUpDownApp: onStop()");
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        appView = new CountUpDownView();
        appDelegate = new CountUpDownDelegate();
        Utils.log("CountUpDownApp: getInitialView()");
        return [ appView, appDelegate ];
    }

    function getView() {
        Utils.log("CountUpDownApp: getView()");
        return appView;
    }

    function getDelegate() {
        Utils.log("CountUpDownApp: getDelegate()");
        return appDelegate;
    }
}

function getApp() as CountUpDownApp {
    Utils.log("CountUpDownApp: Getting App instance");
    return Application.getApp() as CountUpDownApp;
}

function getView() as CountUpDownView {
    Utils.log("CountUpDownApp: Getting View instance");
    return Application.getApp().getView() as CountUpDownView;
}

function getDelegate() as CountUpDownDelegate {
    Utils.log("CountUpDownApp: Getting Delegate instance");
    return Application.getApp().getDelegate() as CountUpDownDelegate;
}