import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Graphics;
using Toybox.Application.Properties;
using Toybox.Attention;
// using Toybox.Application.Storage;

var isCountingUp;
var isMirrored;
var isRepeated;

class CountUpDownDelegate extends WatchUi.BehaviorDelegate {
    private static var timerValue = 0;
    private var isCounting = false;
    private var pendingReset = false;
    private var settingsIntervalAtOpen = 0;
    private var oneSecTimer;
    private var appView = getView();
    static var isCountingUpOld = true;
    private var _dialogHeaderString as String;

    var vibrateData1 = [
            new Attention.VibeProfile(75, 200),
            new Attention.VibeProfile(00, 400),
            new Attention.VibeProfile(75, 200)
            ];

    var vibrateData2 = [
            new Attention.VibeProfile(75, 500)
            ];

    function initialize()  {
        Utils.log("CountUpDownDelegate: initialize()");
        isCountingUp = Settings.getCountingUp();
        isMirrored = Settings.getMirrored();
        isRepeated = Settings.getRepeated();
        isCountingUpOld = isCountingUp;
        timerValue = Settings.getInterval();
        Utils.log("Initial Settings: isCountingUp = " + isCountingUp + ", isMirrored = " + isMirrored + ", isRepeated = " + isRepeated);
        Utils.log("Initial timerValue = " + timerValue);
        oneSecTimer = new Timer.Timer();
        oneSecTimer.start(method(:oneSecondCyclicFunction), 1000, true);
        appView.setCountingParameters(isCountingUp, isMirrored, isRepeated);
        BehaviorDelegate.initialize();
        _dialogHeaderString = WatchUi.loadResource($.Rez.Strings.DialogHeader) as String;
    }

    function onSelect() as Boolean {
        Utils.log("onSelect()");
        if(isCounting == false) {
            // If the counter is parked at its endpoint (0 while counting down, or
            // the target while counting up), restart from the configured starting
            // value instead of resuming at the endpoint. Resuming at the endpoint
            // would just re-trigger the endpoint on the next tick and stay paused.
            var interval = Settings.getInterval();
            var restarted = false;
            if (!isCountingUp && timerValue <= 0) {
                timerValue = interval; // restart the countdown from the target
                restarted = true;
            } else if (isCountingUp && timerValue >= interval) {
                timerValue = 0;        // restart the count-up from zero
                restarted = true;
            }
            startCounting();
            pendingReset = false;
            if (isCountingUp) {
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
            if (restarted) {
                refreshTimerView(interval);
            }
        }
        else {
            stopCounting();
            appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
        }
        return true;
    }

    function startCounting() as Void {
        Utils.log("startCounting()");
        isCounting = true;
    }

    function stopCounting() as Void {
        Utils.log("stopCounting()");
        isCounting = false;
    }

    //! Keep the counter paused and just reflect a new direction; the value stays put.
    private function refreshPausedDirection() as Void {
        var interval = Settings.getInterval();
        pendingReset = false;
        isCountingUpOld = isCountingUp;
        appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
        refreshTimerView(interval);
    }

    private function alertAtEndpoint(tone, vibrationProfile) as Void {
        if (Settings.getBeepEnabled() && (Attention has :playTone)) {
            Attention.playTone(tone);
        }
        if (Settings.getVibrateEnabled() && (Attention has :vibrate)) {
            Attention.vibrate(vibrationProfile);
        }
    }

    private function handleUpcount() as Void {
        var targetTimerValue = Settings.getInterval();
        if (pendingReset) {
            // Reset mode: the upper endpoint was shown for one tick; now reload zero.
            timerValue = 0;
            pendingReset = false;
            return;
        }
        if(timerValue < targetTimerValue) {
            timerValue += 1;
        }
        if (timerValue >= targetTimerValue) {
            timerValue = targetTimerValue;
            alertAtEndpoint(Attention.TONE_TIME_ALERT, vibrateData1);
            if (isRepeated == true) {
                // Reset or Mirror counting based on mode
                Utils.logWithNewline("Repeat counting, ", false);
                if(isMirrored == true) {
                    // Mirror mode: reverse direction
                    Utils.log("by reversing the counting direction ... ");
                    isCountingUp = false;
                    Settings.setCountingUp(isCountingUp);
                    Utils.log("isCountingUp = " + isCountingUp);
                } else {
                    // Reset mode: show the endpoint for one tick, then reload zero.
                    Utils.log("by reseting to zero on the next tick ... ");
                    if (targetTimerValue > 0) {
                        pendingReset = true;
                    }
                }
            }
            else
            {
                // One-time counting, stop at target value
                Utils.log("One-time counting, stopping at target value ... ");
                appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
                stopCounting();
            }
        }
    }

    private function handleDowncount() as Void {
        if (pendingReset) {
            // Reset mode: zero was shown for one tick; now reload the target.
            timerValue = Settings.getInterval();
            pendingReset = false;
            return;
        }
        if(timerValue > 0) {
            timerValue -= 1;
        }
        if (timerValue <= 0) {
            timerValue = 0;
            alertAtEndpoint(Attention.TONE_INTERVAL_ALERT, vibrateData2);
            if (isRepeated == true) {
                    // Reset or Mirror counting based on mode
                    Utils.logWithNewline("Repeat counting, ", false);
                    if(isMirrored == true) {
                        // Mirror mode: reverse direction
                        Utils.log("by reversing the counting direction ... ");
                        isCountingUp = true;
                        Settings.setCountingUp(isCountingUp);
                        Utils.log("isCountingUp = " + isCountingUp);
                    } else {
                        // Reset mode: show zero for one tick, then reload the target.
                        Utils.log("by reseting to the initial counter value on the next tick ... ");
                        if (Settings.getInterval() > 0) {
                            pendingReset = true;
                        }
                    }
            }
            else {
                // One-time counting, stop at zero
                Utils.log("One-time counting, stopping at zero ... ");
                appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
                stopCounting();
            }
        }
    }

    function oneSecondCyclicFunction() as Void {
        // Utils.log("10: One Second Timer Callback called");
        
        if(isCounting == true) {
            if (isCountingUp == true) {
                handleUpcount();
            } else {
                handleDowncount();
            }
        }

        if (isCountingUp != isCountingUpOld) {
            // Direction changed, update description
            if (isCountingUp) {
                Utils.log("Direction changed to Counting Up");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                Utils.log("Direction changed to Counting Down");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
            isCountingUpOld = isCountingUp;
        }
        Utils.log("Timer Value: " + timerValue);
        refreshTimerView(Settings.getInterval());
    }

    private function refreshTimerView(interval) as Void {
        appView.updataCountFromToElement(isCountingUp ? 0 : interval, isCountingUp ? interval : 0);
        appView.setCountingParameters(isCountingUp, isMirrored, isRepeated);
        appView.updateTimerValue(timerValue);
        WatchUi.requestUpdate();
    }

    function onIncrease() {
        Utils.log("onIncrease()");
        if (isCountingUp == false) {
            isCountingUp = true;
            Settings.setCountingUp(isCountingUp);
            pendingReset = false;
            if (isCounting == false) {
                // Up/Down only change direction; they never start counting.
                refreshPausedDirection();
            }
            // While counting, the direction changes and counting continues; the
            // one-second callback reports the new direction.
        }
    }

    function onDecrease() {
        Utils.log("onDecrease()");
        if (isCountingUp == true) {
            isCountingUp = false;
            Settings.setCountingUp(isCountingUp);
            pendingReset = false;
            if (isCounting == false) {
                // Up/Down only change direction; they never start counting.
                refreshPausedDirection();
            }
        }
    }

    function onExit() {
        // Clean up timer
        Utils.log("onExit called");
        oneSecTimer.stop();
    }

    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        Utils.log("Key Event received: " + key);
        if (key == WatchUi.KEY_UP) {
            onIncrease();
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            onDecrease();
            return true;
        }

        if (key == WatchUi.KEY_ENTER) {
            Utils.log("KEY_ENTER pressed");
            onSelect();
            return true;
        }

        if (key == WatchUi.KEY_ESC) {
            Utils.log("KEY_ESC pressed");
            return handleBack();
        }
        return false;
    }

    function onSwipe(evt) {
        var direction = evt.getDirection();

        Utils.log("Swipe Event received: " + direction);


        if (direction == WatchUi.SWIPE_UP) {
            onIncrease();
            return true;
        }

        if (direction == WatchUi.SWIPE_DOWN) {
            onDecrease();
            return true;
        }

        return false;
    }

    function onTap(evt) {
        onSelect();
        return true;
    }

    function handleBack() {
        Utils.log("handleBack(), isCounting = " + isCounting);
        if (isCounting == false) {
            confirmExit();
            return true;
        }

        // Default behavior when not paused
        return true;
    }

    function confirmExit() {
        WatchUi.pushView(new WatchUi.Confirmation(_dialogHeaderString),
                         new $.ConfirmationDialogDelegate(self, method(:onConfirmed)),
                         WatchUi.SLIDE_IMMEDIATE);
    }

    function onConfirmed(confirmed) {
        Utils.log("onConfirmed(): confirmed = " + confirmed);
        if (confirmed == WatchUi.CONFIRM_YES) {
            Settings.saveSettings();
            onExitCust();
        } else {
            // user cancelled
            Utils.log("User chose not to exit");
        }
    }

    function onExitCust() {
        Utils.log("Exiting application");
        System.exit();
    }
    
    private function openSettingsMenu() as Void {
        // Remember the interval so leaving Settings only resets the counter when
        // the interval actually changes; a direction change keeps the value.
        settingsIntervalAtOpen = Settings.getInterval();
        oneSecTimer.stop();
        stopCounting();
        // Generate a new Menu with a drawable Title
        var menu = new WatchUi.Menu2({:title=>new $.DrawableMenuTitle()});

        menu.addItem(new WatchUi.MenuItem("Count Interval",
                                          "(seconds)",
                                          "count_interval",
                                          {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        menu.addItem(new WatchUi.ToggleMenuItem("Count Direction",
                                                {:enabled=>"Count Up", :disabled=>"Count Down"},
                                                "direction_toggle",
                                                Settings.getCountingUp(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        menu.addItem(new WatchUi.ToggleMenuItem("Count Type",
                                                {:enabled=>"Mirrored", :disabled=>"Reset"},
                                                "type_toggle",
                                                Settings.getMirrored(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        menu.addItem(new WatchUi.ToggleMenuItem("Count Repet",
                                                {:enabled=>"Repeated",
                                                :disabled=>"One Time"},
                                                "repeat_toggle",
                                                Settings.getRepeated(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        if (Attention has :playTone) {
            menu.addItem(new WatchUi.ToggleMenuItem("Beep",
                                                    {:enabled=>"On", :disabled=>"Off"},
                                                    "beep_toggle", Settings.getBeepEnabled(),
                                                    {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));
        }

        menu.addItem(new WatchUi.ToggleMenuItem("Vibrate",
                                                {:enabled=>"On", :disabled=>"Off"},
                                                "vibrate_toggle", Settings.getVibrateEnabled(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        WatchUi.pushView(menu, new $.SettingsMenuDelegate(), WatchUi.SLIDE_UP);
    }

    function onMenu() as Boolean {
        openSettingsMenu();
        return true;
    }

    //! Touch devices without a physical Menu button (venu441mm, venu445mm, venux1,
    //! vivoactive6) open Settings with a long press on the screen.
    function onHold(evt) {
        openSettingsMenu();
        return true;
    }

    function restartFromSettings() as Void {
        isCountingUp = Settings.getCountingUp();
        isMirrored = Settings.getMirrored();
        isRepeated = Settings.getRepeated();
        var interval = Settings.getInterval();
        // Only an interval change resets the counter; a direction change keeps the
        // current value (same as Up/Down outside Settings).
        if (interval != settingsIntervalAtOpen) {
            timerValue = isCountingUp ? 0 : interval;
        }
        pendingReset = false;
        isCountingUpOld = isCountingUp;
        appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
        stopCounting();
        refreshTimerView(interval);
        oneSecTimer.start(method(:oneSecondCyclicFunction), 1000, true);
    }
}

//! This is the custom drawable we will use for our main menu title
class DrawableMenuTitle extends WatchUi.Drawable {

    //! Constructor
    public function initialize() {
        Drawable.initialize({});
    }

    //! Draw the settings screen icon and main menu title
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var spacing = 2;
        var settingsIcon = WatchUi.loadResource($.Rez.Drawables.GearIcon) as BitmapResource;
        var bitmapWidth = settingsIcon.getWidth();
        var labelWidth = dc.getTextWidthInPixels("Settings", Graphics.FONT_SMALL);

        var bitmapX = (dc.getWidth() - (bitmapWidth + spacing + labelWidth)) / 2;
        var bitmapY = (dc.getHeight() - settingsIcon.getHeight()) / 2;
        var labelX = bitmapX + bitmapWidth + spacing;
        var labelY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawBitmap(bitmapX, bitmapY, settingsIcon);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(labelX, labelY, Graphics.FONT_SMALL, "Settings", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
