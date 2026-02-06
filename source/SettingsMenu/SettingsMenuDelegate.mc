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
        if (id.equals("count_interval")) {
            System.println("onSelect item called: " + id + " with value: " + item.getLabel());
            WatchUi.pushView(new $.TimePicker(), new $.TimePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        if (item instanceof ToggleMenuItem) {
            System.println("onSelect item called: " + id + " with value: " + item.isEnabled());

            if (id.equals("direction_toggle")) {
                Settings.setCountingUp(item.isEnabled());
            }
            if (id.equals("type_toggle")) {
                Settings.setMirrored(item.isEnabled());
            }
            if (id.equals("repeat_toggle")) {
                Settings.setRepeated(item.isEnabled());
            }
        }
        appDelegate.updateVariables();
    }
}