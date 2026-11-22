import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Graphics;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    private var appDelegate = getDelegate();

    function initialize() {
        Utils.log("Menu Input Delegate initialized");
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();
        if (id.equals("count_interval")) {
            Utils.log("onSelect item called => " + id + " with value: " + item.getLabel());
            WatchUi.pushView(new $.TimePicker(), new $.TimePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
        if (item instanceof ToggleMenuItem) {
            Utils.log("onSelect item called => " + id + " with value: " + item.isEnabled());

            if (id.equals("direction_toggle")) {
                Settings.setCountingUp(item.isEnabled());
            }
            if (id.equals("type_toggle")) {
                Settings.setMirrored(item.isEnabled());
            }
            if (id.equals("repeat_toggle")) {
                Settings.setRepeated(item.isEnabled());
            }
            if (id.equals("beep_toggle")) {
                Settings.setBeepEnabled(item.isEnabled());
            }
            if (id.equals("vibrate_toggle")) {
                Settings.setVibrateEnabled(item.isEnabled());
            }
        }
    }

    function onBack() as Void {
        Menu2InputDelegate.onBack();
        appDelegate.restartFromSettings();
    }
}
