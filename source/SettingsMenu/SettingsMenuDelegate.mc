import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var appDelegate = getDelegate();

    function initialize() {
        System.println("Menu Input Delegate initialized");
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();
        // System.println("onSelect item called: " + id);
        if (item instanceof ToggleMenuItem) {
            System.println("onSelect item called: " + id + " with value: " + item.isEnabled());
            
            if (id.equals("direction_toggle")) {
                System.println("Count Up: " + item.isEnabled());
                Settings.setCountingUp(item.isEnabled());
            }
            if (id.equals("type_toggle")) {
                System.println("Mirror Mode: " + item.isEnabled());
                Settings.setMirrored(item.isEnabled());
            }
            if (id.equals("repeat_toggle")) {
                System.println("Repeat Mode: " + item.isEnabled());
                Settings.setRepeated(item.isEnabled());
            }
        }
    }

    function onMenuItem(item) {
        var id = item.getId().toString();
        System.println("onSelect item called: " + id);
        switch (item) {
        case "interval":
            System.println("onMenuItem interval");
            break;
        case "direction":
            System.println("onMenuItem direction");
            break;
        case "repetition":  
            System.println("onMenuItem repetition");
            break;
        case "type":
            System.println("onMenuItem type");
            break;
        }
    }

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
    // function showIntervalPicker() {

    //     var picker = new WatchUi.NumberPicker(
    //         "Count Interval (sec)",
    //         1,          // min
    //         3600,       // max
    //         Settings.getInterval()
    //     );

    //     WatchUi.pushView(
    //         picker,
    //         new countIntervalPickerDelegate(),
    //         WatchUi.SLIDE_IMMEDIATE
    //     );
    // }

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
//! This is the menu input delegate shared by all the basic sub-menus in the application
class Menu2SampleSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _menu as WatchUi.Menu2;
    private var _dividerType as WatchUi.Menu2.DividerType? = WatchUi.Menu2.DIVIDER_TYPE_DEFAULT;
    private var _count as Number = 0;

    //! Constructor
    //! @param menu The menu to be used
    public function initialize(menu as WatchUi.Menu2) {
        _menu = menu;
        Menu2InputDelegate.initialize();
    }

    //! Handle an item being selected
    //! @param item The selected menu item
    // public function onSelect(item as MenuItem) as Void {
    //     // For IconMenuItems, we will change to the next icon state.
    //     // This demonstrates a custom toggle operation using icons.
    //     // Static icons can also be used in this layout.
    //     if (item instanceof WatchUi.IconMenuItem) {
    //         item.setSubLabel((item.getIcon() as CustomIcon).nextState());
    //     }
    //     WatchUi.requestUpdate();
    // }

    //! Handle the back key being pressed
    public function onBack() as Void {
        if (WatchUi.Menu2 has :setDividerType) {
            if (_count % 2 == 0) {
                _count++;
                if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_DEFAULT) {
                    _dividerType = WatchUi.Menu2.DIVIDER_TYPE_ICON;
                } else if (_dividerType == WatchUi.Menu2.DIVIDER_TYPE_ICON){
                    _dividerType = WatchUi.Menu2.DIVIDER_TYPE_DEFAULT;
                }
                _menu.setDividerType(_dividerType);
            } else {
                WatchUi.popView(WatchUi.SLIDE_DOWN);
            }
        } else {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    //! Handle the done item being selected
    public function onDone() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}