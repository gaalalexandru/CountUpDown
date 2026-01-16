using Toybox.Application;

module Settings {
    // -------------------------------------------------
    // App version (read-only)
    // -------------------------------------------------
    function getAppVersion() {
        return Application.getProperty("appVersion");
    }

    // -------------------------------------------------
    // Count interval (seconds)
    // -------------------------------------------------
    function getInterval() {
        return Application.getProperty("countInterval");
    }

    function setInterval(v) {
        Application.setProperty("countInterval", v);
    }

    // -------------------------------------------------
    // Count direction
    // true  = Count Up
    // false = Count Down
    // -------------------------------------------------
    function isCountingUp() {
        return Application.getProperty("countDirectionUp");
    }

    function setCountingUp(v) {
        Application.setProperty("countDirectionUp", v);
    }

    // -------------------------------------------------
    // Count repetition
    // true  = Repeated
    // false = One time
    // -------------------------------------------------
    function isRepeated() {
        return Application.getProperty("countRepetitionMode");
    }

    function setRepeated(v) {
        Application.setProperty("countRepetitionMode", v);
    }

    // -------------------------------------------------
    // Count type
    // true  = Mirror mode
    // false = Reset mode
    // -------------------------------------------------
    function isMirrored() {
        return Application.getProperty("countTypeMirrored");
    }

    function setMirrored(v) {
        Application.setProperty("countTypeMirrored", v);
    }
    // -------------------------------------------------
    // Optional helpers
    // -------------------------------------------------
    function resetToDefaults() {
        Application.clearProperties();
    }
}