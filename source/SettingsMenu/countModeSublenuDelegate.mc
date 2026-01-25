//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Input handler to respond to Count Mode menu selections
class countModeSubmenuDelegate extends WatchUi.MenuInputDelegate {

    //! Constructor
    public function initialize() {
        MenuInputDelegate.initialize();
    }

    //! Handle a menu item being selected
    //! @param item Symbol identifier of the menu item that was chosen
    public function onMenuItem(item as Symbol) as Void {
        if (item == :menuMirror) {
            System.println("Mirror Mode");
            Settings.setMirrored(true);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        } else if (item == :menuReset) {
            System.println("Reset Mode");
            Settings.setMirrored(false);
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }
}
