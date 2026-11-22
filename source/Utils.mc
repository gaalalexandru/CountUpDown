import Toybox.Lang;
import Toybox.System;

//! Shared utility methods for the application.
class Utils {
    //! Write a value to the Connect IQ debug log.
    (:debug)
    static function log(message) as Void {
        Utils.logWithNewline(message, true);
    }

    //! When newline is false, continue printing on the current line.
    (:debug)
    static function logWithNewline(message, newline as Boolean) as Void {
        if (newline) {
            System.println(message);
        } else {
            System.print(message);
        }
    }

    (:release)
    static function log(message) as Void {
        // Logging is disabled in release builds.
    }

    (:release)
    static function logWithNewline(message, newline as Boolean) as Void {
        // Logging is disabled in release builds.
    }
}
