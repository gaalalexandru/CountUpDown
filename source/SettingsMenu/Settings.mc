using Toybox.Application.Storage;
using Toybox.Application.Properties;

class Settings {
    // -------------------------------------------------
    // App version (read-only)
    // -------------------------------------------------
    static function getAppVersion() {
        return Properties.getValue("appVersion");
    }

    // -------------------------------------------------
    // Count interval (seconds)
    // -------------------------------------------------
    static function getInterval() {
        return Properties.getValue("countInterval");
    }

    static function setInterval(v) {
        Properties.setValue("countInterval", v);
    }

    // -------------------------------------------------
    // Count direction
    // true  = Count Up
    // false = Count Down
    // -------------------------------------------------
    static function isCountingUp() {
        return Properties.getValue("countDirectionUp");
    }

    static function setCountingUp(v) {
        Properties.setValue("countDirectionUp", v);
    }

    // -------------------------------------------------
    // Count repetition
    // true  = Repeated
    // false = One time
    // -------------------------------------------------
    static function isRepeated() {
        return Properties.getValue("countRepetitionMode");
    }

    static function setRepeated(v) {
        Properties.setValue("countRepetitionMode", v);
    }

    // -------------------------------------------------
    // Count type
    // true  = Mirror mode
    // false = Reset mode
    // -------------------------------------------------
    static function isMirrored() {
        return Properties.getValue("countTypeMirrored");
    }

    static function setMirrored(v) {
        Properties.setValue("countTypeMirrored", v);
    }

    static function loadSettings() {
        Properties.setValue("countDirectionUp", Storage.getValue("countDirectionUp"));
        Properties.setValue("countTypeMirrored", Storage.getValue("countTypeMirrored"));
        Properties.setValue("countRepetitionMode", Storage.getValue("countRepetitionMode"));
        Properties.setValue("countInterval", Storage.getValue("countInterval"));
    }

    static function saveSettings() {
        Storage.setValue("countDirectionUp", isCountingUp());
        Storage.setValue("countTypeMirrored", isMirrored());
        Storage.setValue("countRepetitionMode", isRepeated());
        Storage.setValue("countInterval", getInterval());
    }
    // // -------------------------------------------------
    // // Optional helpers
    // // -------------------------------------------------
    // static function resetToDefaults() {
    //     Properties.clearAll();
    // }
}