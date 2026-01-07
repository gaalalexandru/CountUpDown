import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class CountUpDownApp extends Application.AppBase {
    private var appView;
    private var appDelegate;

    function initialize() {
        System.println("1: App initialized");
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("2: App started");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        System.println("10: App stopped");
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        appView = new CountUpDownView();
        appDelegate = new CountUpDownDelegate();
        System.println("3: Getting initial view and delegate");
        return [ appView, appDelegate ];
    }

    function getView() {
        System.println("Getting App View instance");
        return appView;
    }

    function getDelegate() {
        System.println("Getting App Delegate instance");
        return appDelegate;
    }

}

function getApp() as CountUpDownApp {
    System.println("Getting App instance");
    return Application.getApp() as CountUpDownApp;
}

function getView() as CountUpDownView {
    System.println("Getting View instance from App");
    return Application.getApp().getView() as CountUpDownView;
}

function getDelegate() as CountUpDownDelegate {
    System.println("Getting Delegate instance from App");
    return Application.getApp().getDelegate() as CountUpDownDelegate;
}