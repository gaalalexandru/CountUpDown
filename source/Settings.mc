using Toybox.Application.Storage;
using Toybox.Application.Properties;
using Toybox.System;

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
        var ret =  Properties.getValue("countInterval");
        if (ret != null)
        {
            if (ret < 1) {
                return 1; // minimum interval is one second
            }
            return ret;
        } else {
            return 60; // default value
        }
    }

    static function setInterval(v) {
        if (v != null && v < 1) {
            v = 1; // minimum interval is one second
        }
        Properties.setValue("countInterval", v);
    }

    // -------------------------------------------------
    // Count direction
    // true  = Count Up
    // false = Count Down
    // -------------------------------------------------
    static function getCountingUp() {
        var ret =  Properties.getValue("countDirectionUp");
        if (ret != null)
        {
            return ret;
        } else {
            return false;
        }
    }

    static function setCountingUp(v) {
        Properties.setValue("countDirectionUp", v);
    }

    // -------------------------------------------------
    // Count repetition
    // true  = Repeated
    // false = One time
    // -------------------------------------------------
    static function getRepeated() {
        var ret =  Properties.getValue("countRepetitionMode");
        if (ret != null)
        {
            return ret;
        } else {
            return false;
        }
    }

    static function setRepeated(v) {
        Properties.setValue("countRepetitionMode", v);
    }

    // -------------------------------------------------
    // Count type
    // true  = Mirror mode
    // false = Reset mode
    // -------------------------------------------------
    static function getMirrored() {
        var ret =  Properties.getValue("countTypeMirrored");
        if (ret != null)
        {
            return ret;
        } else {
            return false;
        }
    }

    static function setMirrored(v) {
        Properties.setValue("countTypeMirrored", v);
    }

    static function getBeepEnabled() {
        return Properties.getValue("beepEnabled");
    }

    static function setBeepEnabled(enabled) {
        Properties.setValue("beepEnabled", enabled);
    }

    static function getVibrateEnabled() {
        return Properties.getValue("vibrateEnabled");
    }

    static function setVibrateEnabled(enabled) {
        Properties.setValue("vibrateEnabled", enabled);
    }

    static function loadSettings() {
        Utils.log("Settings: Loading settings from storage");
        var isCountingUp = Storage.getValue("countDirectionUp");
        var isMirrored = Storage.getValue("countTypeMirrored");
        var isRepeated = Storage.getValue("countRepetitionMode");
        var timerValue = Storage.getValue("countInterval");
        Utils.log("Loaded Settings: isCountingUp = " + isCountingUp + ", isMirrored = " + isMirrored + ", isRepeated = " + isRepeated);
        Utils.log("Loaded timerValue = " + timerValue);

        setCountingUp(isCountingUp);
        setMirrored(isMirrored);
        setRepeated(isRepeated);
        setInterval(timerValue);
    }

    static function saveSettings() {
        Utils.log("Settings: Saving settings to storage");
        Storage.setValue("countDirectionUp", getCountingUp());
        Storage.setValue("countTypeMirrored", getMirrored());
        Storage.setValue("countRepetitionMode", getRepeated());
        Storage.setValue("countInterval", getInterval());
    }
}
