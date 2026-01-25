using Toybox.Application;

class Settings {
    // -------------------------------------------------
    // App version (read-only)
    // -------------------------------------------------
    function getAppVersion() {
        return Application.Properties.getValue("appVersion");
    }

    // -------------------------------------------------
    // Count interval (seconds)
    // -------------------------------------------------
    function getInterval() {
        return Application.Properties.getValue("countInterval");
    }

    function setInterval(v) {
        Application.Properties.setValue("countInterval", v);
    }

    // -------------------------------------------------
    // Count direction
    // true  = Count Up
    // false = Count Down
    // -------------------------------------------------
    function isCountingUp() {
        return Application.Properties.getValue("countDirectionUp");
    }

    function setCountingUp(v) {
        Application.Properties.setValue("countDirectionUp", v);
    }

    // -------------------------------------------------
    // Count repetition
    // true  = Repeated
    // false = One time
    // -------------------------------------------------
    function isRepeated() {
        return Application.Properties.getValue("countRepetitionMode");
    }

    function setRepeated(v) {
        Application.Properties.setValue("countRepetitionMode", v);
    }

    // -------------------------------------------------
    // Count type
    // true  = Mirror mode
    // false = Reset mode
    // -------------------------------------------------
    function isMirrored() {
        return Application.Properties.getValue("countTypeMirrored");
    }

    function setMirrored(v) {
        Application.Properties.setValue("countTypeMirrored", v);
    }
    // // -------------------------------------------------
    // // Optional helpers
    // // -------------------------------------------------
    // function resetToDefaults() {
    //     Application.Properties.clearAll();
    // }
}