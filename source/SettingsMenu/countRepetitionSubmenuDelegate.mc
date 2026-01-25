//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Settings;

//! Input handler to respond to Count Repetition menu selections
class countRepetitionSubmenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Handle a menu item being selected
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        if (item == :menuRepeated) {
            System.println("Repeated");
            Settings.setRepeated(true);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (item == :menuOneTime) {
            System.println("One Time");
            Settings.setRepeated(false);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}
