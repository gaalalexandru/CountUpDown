using Toybox.Application;

class Settings {
    // -------------------------------------------------
    // App version (read-only)
    // -------------------------------------------------
    static function getAppVersion() {
        return Application.Properties.getValue("appVersion");
    }

    // -------------------------------------------------
    // Count interval (seconds)
    // -------------------------------------------------
    static function getInterval() {
        return Application.Properties.getValue("countInterval");
    }

    static function setInterval(v) {
        Application.Properties.setValue("countInterval", v);
    }

    // -------------------------------------------------
    // Count direction
    // true  = Count Up
    // false = Count Down
    // -------------------------------------------------
    static function isCountingUp() {
        return Application.Properties.getValue("countDirectionUp");
    }

    static function setCountingUp(v) {
        Application.Properties.setValue("countDirectionUp", v);
    }

    // -------------------------------------------------
    // Count repetition
    // true  = Repeated
    // false = One time
    // -------------------------------------------------
    static function isRepeated() {
        return Application.Properties.getValue("countRepetitionMode");
    }

    static function setRepeated(v) {
        Application.Properties.setValue("countRepetitionMode", v);
    }

    // -------------------------------------------------
    // Count type
    // true  = Mirror mode
    // false = Reset mode
    // -------------------------------------------------
    static function isMirrored() {
        return Application.Properties.getValue("countTypeMirrored");
    }

    static function setMirrored(v) {
        Application.Properties.setValue("countTypeMirrored", v);
    }
    // // -------------------------------------------------
    // // Optional helpers
    // // -------------------------------------------------
    // static function resetToDefaults() {
    //     Application.Properties.clearAll();
    // }
}