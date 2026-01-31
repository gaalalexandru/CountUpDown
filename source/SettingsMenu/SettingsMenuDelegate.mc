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
        if (id.equals("count_interval")) {
            System.println("onSelect item called: " + id + " with value: " + item.getLabel());
            WatchUi.pushView(new $.TimePicker(), new $.TimePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        if (item instanceof ToggleMenuItem) {
            System.println("onSelect item called: " + id + " with value: " + item.isEnabled());

            if (id.equals("direction_toggle")) {
                isCountingUp = item.isEnabled();
                System.println("Count Up: " + isCountingUp);
                Settings.setCountingUp(isCountingUp);
            }
            if (id.equals("type_toggle")) {
                isMirrored = item.isEnabled();
                System.println("Mirror Mode: " + isMirrored);
                Settings.setMirrored(isMirrored);
            }
            if (id.equals("repeat_toggle")) {
                isRepeated = item.isEnabled();
                System.println("Repeat Mode: " + isRepeated);
                Settings.setRepeated(isRepeated);
            }
        }
    }

    // function onMenuItem(item) {
    //     var id = item.getId().toString();
    //     System.println("onSelect item called: " + id);
    //     switch (item) {
    //     case "interval":
    //         System.println("onMenuItem interval");
    //         break;
    //     case "direction":
    //         System.println("onMenuItem direction");
    //         break;
    //     case "repetition":  
    //         System.println("onMenuItem repetition");
    //         break;
    //     case "type":
    //         System.println("onMenuItem type");
    //         break;
    //     }
    // }
}