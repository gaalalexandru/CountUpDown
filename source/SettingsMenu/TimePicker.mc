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
        Settings.setInterval(time);

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}


//! Factory that controls which numbers can be picked
class NumberFactory extends WatchUi.PickerFactory {
    private var _start as Number;
    private var _stop as Number;
    private var _increment as Number;
    private var _formatString as String;
    private var _font as FontDefinition;

    //! Constructor
    //! @param start Number to start with
    //! @param stop Number to end with
    //! @param increment How far apart the numbers should be
    //! @param options Dictionary of options
    //! @option options :font The font to use
    //! @option options :format The number format to display
    public function initialize(start as Number, stop as Number, increment as Number, options as {
        :font as FontDefinition,
        :format as String
    }) {
        PickerFactory.initialize();

        _start = start;
        _stop = stop;
        _increment = increment;

        var format = options.get(:format);
        if (format != null) {
            _formatString = format;
        } else {
            _formatString = "%d";
        }

        var font = options.get(:font);
        if (font != null) {
            _font = font;
        } else {
            _font = Graphics.FONT_NUMBER_MEDIUM;
        }
    }

    //! Get the index of a number item
    //! @param value The number to get the index of
    //! @return The index of the number
    public function getIndex(value as Number) as Number {
        return (value / _increment) - _start;
    }

    //! Generate a Drawable instance for an item
    //! @param index The item index
    //! @param selected true if the current item is selected, false otherwise
    //! @return Drawable for the item
    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var value = getValue(index);
        var text = "No item";
        if (value instanceof Number) {
            text = value.format(_formatString);
        }
        return new WatchUi.Text({:text=>text, :color=>Graphics.COLOR_RED, :font=>_font,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER});
    }

    //! Get the value of the item at the given index
    //! @param index Index of the item to get the value of
    //! @return Value of the item
    public function getValue(index as Number) as Object? {
        return _start + (index * _increment);
    }

    //! Get the number of picker items
    //! @return Number of items
    public function getSize() as Number {
        return (_stop - _start) / _increment + 1;
    }
}
