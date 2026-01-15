//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.WatchUi;

//! Input handler for the confirmation dialog
class ConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {
    var _caller;
    var _callback;

    //! Constructor
    //! @param view The app view
    public function initialize(caller, callback) {
        System.println("ConfirmationDialogDelegate: initialize()");
        
        ConfirmationDelegate.initialize();
        _caller = caller;
        _callback = callback;
    }

    //! Handle a confirmation selection
    //! @param value The confirmation value
    //! @return true if handled, false otherwise
    public function onResponse(value as Confirm) as Boolean {
        System.println("ConfirmationDialogDelegate: onResponse() value = " + value);
        if (value == WatchUi.CONFIRM_NO) {
            System.println("ConfirmationDialogDelegate: onResponse() CONFIRM_NO");
        } else {
            System.println("ConfirmationDialogDelegate: onResponse() CONFIRM_YES");
        }
        // Signal back
        _callback.invoke(value);
        return true;
    }
}