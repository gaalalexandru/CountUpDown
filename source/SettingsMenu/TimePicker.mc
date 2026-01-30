//
// Copyright 2015-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;


const FACTORY_SIZE = 3; // Minutes + Separator + Seconds
const TWO_DECIMAL_FORMAT = "%02d";

//! Picker that allows the user to choose a time
class TimePicker extends WatchUi.Picker {

    //! Constructor
    public function initialize() {
        var title = new WatchUi.Text({:text=>$.Rez.Strings.timePickerTitle,
                                      :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                                      :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM,
                                      :color=>Graphics.COLOR_GREEN,
                                      :font=>Graphics.FONT_MEDIUM});

        var factories = new Array<PickerFactory or Text>[$.FACTORY_SIZE];

        factories[0] = new $.NumberFactory(0, 59, 1, {:format=>$.TWO_DECIMAL_FORMAT,
                                                      :color=>Graphics.COLOR_GREEN,
                                                      :font=>Graphics.FONT_MEDIUM});
        factories[1] = new WatchUi.Text({:text=>$.Rez.Strings.timeSeparator,
                                         :font=>Graphics.FONT_MEDIUM,
                                         :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                                         :locY=>WatchUi.LAYOUT_VALIGN_CENTER, 
                                        //  :color=>Graphics.COLOR_GREEN
                                        });
        factories[2] = new $.NumberFactory(0, 59, 1, {:format=>$.TWO_DECIMAL_FORMAT,
                                                      :color=>Graphics.COLOR_GREEN,
                                                      :font=>Graphics.FONT_MEDIUM});

        var time = getStoredTimerValue();

        var defaults = new Array<Number>[factories.size()];
        
        if (time != null) {
            var min = time[0];
            if (min != null) {
                defaults[0] = (factories[0] as NumberFactory).getIndex(min);
            }
            var sec = time[1];
            if (sec != null) {
                defaults[2] = (factories[2] as NumberFactory).getIndex(sec);
            }
        }
        Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
// 

        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        // dc.clear();

        // dc.drawBitmap(bitmapX, bitmapY, settingsIcon);
        // dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);



    }

    //! Get the stored time in an array
    //! @param factoryCount Number of factories used to make the time
    //! @return Array with the stored time values or null if no stored time
    private function getStoredTimerValue() as Array<Number>? {
        // var storedValue = Storage.getValue("countInterval");
        var storedValue = Settings.getInterval();
        if (storedValue instanceof Number) {
            var defaults =  new Array<Number>[2];
            defaults[0] = ((storedValue / 60) as Number); // Minutes
            defaults[1] = ((storedValue % 60) as Number); // Seconds 
        return defaults;
        }
        return null;
    }
}

//! Responds to a time picker selection or cancellation
class TimePickerDelegate extends WatchUi.PickerDelegate {

    //! Constructor
    public function initialize() {
        PickerDelegate.initialize();
    }

    //! Handle a cancel event from the picker
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle a confirm event from the picker
    //! @param values The values chosen in the picker
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        var min = values[0] as Number;
        var sec = values[2] as Number;
        System.println("TimePickerDelegate.onAccept: min=" + min + " sec=" + sec);
        
        // var time = min + (WatchUi.loadResource($.Rez.Strings.timeSeparator) as String) + sec.format($.TWO_DECIMAL_FORMAT);
        var time = (min * 60) + sec;
        // Storage.setValue("countInterval", time);
        Settings.setInterval(time);

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
