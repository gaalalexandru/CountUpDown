import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SettingsMenuDelegate extends WatchUi.MenuInputDelegate {

    private var appDelegate = getDelegate();

    function initialize() {
        System.println("Menu Input Delegate initialized");
        MenuInputDelegate.initialize();
    }


    function onMenuItem(item) as Void {
        System.println("on Menu item called: " + item);
        // var id = item.getId();
        switch (item) {
        case "interval":
            showIntervalPicker();
            break;
        case "direction":
            showDirectionPicker();
            break;
        case "repetition":  
            showRepetitionPicker();
            break;
        case "type":  
            showTypePicker();
            break;
        }
    }

    // function onMenuItem(item as Symbol) as Void {
    //     System.println("on Menu item called: " + item);
    //     if (item == :item_1) {
    //         System.println("Reverse count direction");
    //         appDelegate.isCountingUp = !appDelegate.isCountingUp;
    //         //appView.setCountingDirection(isCountingUp);
    //     } else if (item == :item_2) {
    //         System.println("item 2");
    //     } else if (item == :item_3) {
    //         System.println("item 3");
    //     } else if (item == :item_4) {
    //         System.println("item 4");
    //     }
    // }

    // function onBack() as Boolean {
    //     System.println("Menu back key pressed 2222");
    //     return true;
    // }

    // function onSelect() as Boolean {
    //     System.println("Menu item selected 2222");
    //     return true;
    // }
// -------------------------------------------------
    // 1. Count Interval (NumberPicker)
    // -------------------------------------------------
    function showIntervalPicker() {

        var picker = new WatchUi.NumberPicker(
            "Count Interval (sec)",
            1,          // min
            3600,       // max
            Settings.getInterval()
        );

        WatchUi.pushView(
            picker,
            new countIntervalPickerDelegate(),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    // -------------------------------------------------
    // 2. Count Direction (Up / Down)
    // -------------------------------------------------
    function showDirectionPicker() {
        System.println("Showing count direction picker");
        WatchUi.pushView(new Rez.Menus.countDirectionSubmenu(),
                         new $.countDirectionSubmenuDelegate(),
                         WatchUi.SLIDE_UP);
        return true;
        // var menu = new WatchUi.Menu("Count Direction");

        // menu.addItem(new MenuItem("Count Up",   true,  null));
        // menu.addItem(new MenuItem("Count Down", false, null));

        // WatchUi.pushView(
        //     menu,
        //     new DirectionPickerDelegate(),
        //     WatchUi.SLIDE_IMMEDIATE
        // );
    }

    // -------------------------------------------------
    // 3. Count Repetition (Repeated / One Time)
    // -------------------------------------------------
    function showRepetitionPicker() {
        System.println("Showing repetition picker");
        WatchUi.pushView(new Rez.Menus.countRepetitionSubmenu(),
                         new $.countRepetitionSubmenuDelegate(),
                         WatchUi.SLIDE_UP);
        return true;
        // var menu = new WatchUi.Menu("Repetition Mode");

        // menu.addItem(new MenuItem("Repeated", true,  null));
        // menu.addItem(new MenuItem("One Time", false, null));


        // WatchUi.pushView(
        //     menu,
        //     new RepetitionPickerDelegate(),
        //     WatchUi.SLIDE_IMMEDIATE
        // );
    }

    // -------------------------------------------------
    // 4. Count Type (Mirror / Reset)
    // -------------------------------------------------
    function showTypePicker() {
        System.println("Showing count mode picker");
        WatchUi.pushView(new Rez.Menus.countModeSubmenu(),
                         new $.countModeSubmenuDelegate(),
                         WatchUi.SLIDE_UP);
        return true;
        // var menu = new WatchUi.Menu("Count Type");

        // menu.addItem(new MenuItem("Mirror Mode", true,  null));
        // menu.addItem(new MenuItem("Reset Mode",  false, null));

        // WatchUi.pushView(
        //     menu,
        //     new TypePickerDelegate(),
        //     WatchUi.SLIDE_IMMEDIATE
        // );
    }
}