import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CountUpDownMenuDelegate extends WatchUi.MenuInputDelegate {

    private var appDelegate = getDelegate();

    function initialize() {
        System.println("Menu Input Delegate initialized");
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        System.println("on Menu item called: " + item);
        if (item == :item_1) {
            System.println("Reverse count direction");
            appDelegate.isCountingUp = !appDelegate.isCountingUp;
        } else if (item == :item_2) {
            System.println("item 2");
        } else if (item == :item_3) {
            System.println("item 3");
        } else if (item == :item_4) {
            System.println("item 4");
        }
    }

    function onBack() as Boolean {
        System.println("Menu back key pressed 2222");
        return true;
    }

    function onSelect() as Boolean {
        System.println("Menu item selected 2222");
        return true;
    }

}