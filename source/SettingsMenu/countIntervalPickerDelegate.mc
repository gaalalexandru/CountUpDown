// import Toybox.Application.Storage;
// import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

// class countIntervalPicker extends WatchUi.Picker {

//     private var intervals = [5, 10, 15, 20, 25, 30, 45, 60];
//     private var intervalLabels = ["5 sec", "10 sec", "15 sec", "20 sec", "25 sec", "30 sec", "45 sec", "60 sec"];

//     //! Constructor
//     public function initialize() {
//         var title = new WatchUi.Text({:text=>$.Rez.Strings.countIntervalPickerTitle, :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
//             :locY=>WatchUi.LAYOUT_HALIGN_CENTER, :color=>Graphics.COLOR_WHITE});
            


//         var currentInterval = Settings.getInterval();
//         var selectedIndex = 0;
//         for (var i = 0; i < intervals.size(); i += 1) {
//             if (intervals[i] == currentInterval) {
//                 selectedIndex = i;
//                 break;
//             }
//         }
//         setItems(intervalLabels);
//         setSelectedIndex(selectedIndex);

//         Picker.initialize({:title=>title, :pattern=>factories, :defaults=>defaults});
//     }
// }
class countIntervalPickerDelegate extends WatchUi.PickerDelegate {

    //! Constructor
    public function initialize() {
        PickerDelegate.initialize();
    }

    //! Handle a cancel event
    //! @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    //! Handle a confirm event
    //! @param values The values chosen
    //! @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        // Storage.setValue("color", values[0] as Number);
        Settings.setInterval(values[0] as Number);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}