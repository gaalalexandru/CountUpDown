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
            return ret;
        } else {
            return 60; // default value
        }
    }

    static function setInterval(v) {
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

    static function loadSettings() {
        System.println("Settings: Loading settings from storage");
        var isCountingUp = Storage.getValue("countDirectionUp");
        var isMirrored = Storage.getValue("countTypeMirrored");
        var isRepeated = Storage.getValue("countRepetitionMode");
        var timerValue = Storage.getValue("countInterval");
        System.println("Loaded Settings: isCountingUp = " + isCountingUp + ", isMirrored = " + isMirrored + ", isRepeated = " + isRepeated);
        System.println("Loaded timerValue = " + timerValue);

        setCountingUp(isCountingUp);
        setMirrored(isMirrored);
        setRepeated(isRepeated);
        setInterval(timerValue);
    }

    static function saveSettings() {
        System.println("Settings: Saving settings to storage");
        Storage.setValue("countDirectionUp", getCountingUp());
        Storage.setValue("countTypeMirrored", getMirrored());
        Storage.setValue("countRepetitionMode", getRepeated());
        Storage.setValue("countInterval", getInterval());
    }
}