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
        System.println("CountUpDownDelegate: initialize()");
        isCountingUp = Settings.getCountingUp();
        isMirrored = Settings.getMirrored();
        isRepeated = Settings.getRepeated();
        timerValue = Settings.getInterval();
        System.println("Initial Settings: isCountingUp = " + isCountingUp + ", isMirrored = " + isMirrored + ", isRepeated = " + isRepeated);
        System.println("Initial timerValue = " + timerValue);
        oneSecTimer = new Timer.Timer();
        oneSecTimer.start(method(:oneSecondCyclicFunction), 1000, true);
        appView.setCountingParameters(isCountingUp, isMirrored, isRepeated);
        BehaviorDelegate.initialize();
        _dialogHeaderString = WatchUi.loadResource($.Rez.Strings.DialogHeader) as String;
    }

    function onSelect() as Boolean {
        System.println("onSelect()");
        if(isCounting == false) {
            startCounting();
            if (isCountingUp) {
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
        }
        else {
            stopCounting();
            appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
        }
        return true;
    }

    function startCounting() as Void {
        System.println("startCounting()");
        isCounting = true;
    }

    function stopCounting() as Void {
        System.println("stopCounting()");
        isCounting = false;
    }

    private function handleUpcount() as Void {
        var targetTimerValue = Settings.getInterval();
        if(timerValue < targetTimerValue) {
            timerValue += 1;
        }
        else {
            timerValue = targetTimerValue;
            Attention.playTone(Attention.TONE_TIME_ALERT);
            Attention.vibrate(self.vibrateData1);            
            if (isRepeated == true) {
                // Reset or Mirror counting based on mode
                System.print("Repeat counting, ");
                if(isMirrored == true) {
                    // Mirror mode: reverse direction
                    System.println("by reversing the counting direction ... ");
                    isCountingUp = false;
                    Settings.setCountingUp(isCountingUp);
                    System.println("isCountingUp = " + isCountingUp);
                } else {
                    // Reset mode: reset timer to zero
                    System.println("by reseting to zero ... ");
                    timerValue = 0;
                }
            }
            else
            {
                // One-time counting, stop at target value
                System.println("One-time counting, stopping at target value ... ");
                appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
                stopCounting();
            }
        }
    }

    private function handleDowncount() as Void {
        if(timerValue > 0) {
            timerValue -= 1;
        }
        else {
            timerValue = 0;
            Attention.playTone(Attention.TONE_INTERVAL_ALERT);
            Attention.vibrate(vibrateData2);
            // Attention.vibrate(Attention.VIBE_ALERT);
            if (isRepeated == true) {
                    // Reset or Mirror counting based on mode
                    System.print("Repeat counting, ");
                    if(isMirrored == true) {
                        // Mirror mode: reverse direction
                        System.println("by reversing the counting direction ... ");
                        isCountingUp = true;
                        Settings.setCountingUp(isCountingUp);
                        System.println("isCountingUp = " + isCountingUp);
                    } else {
                        // Reset mode: reset timer to initial value
                        System.println("by reseting to the initial counter value ... ");
                        timerValue = Settings.getInterval();
                    }
            }
            else {
                // One-time counting, stop at zero
                System.println("One-time counting, stopping at zero ... ");
                appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
                stopCounting();
            }
        }
    }

    function oneSecondCyclicFunction() as Void {
        // System.println("10: One Second Timer Callback called");
        
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
                System.println("Direction changed to Counting Up");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                System.println("Direction changed to Counting Down");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
            isCountingUpOld = isCountingUp;
        }
        var from = 0;
        var to = 0;
        if(isCountingUp == true) {
            from = 0;
            to = Settings.getInterval();
            System.println("Timer Value: " + timerValue);
        }
        else {
            from = Settings.getInterval();
            to = 0;
            System.println("Timer Value: " + timerValue);
        }
        appView.updataCountFromToElement(from,to);
        appView.setCountingParameters(isCountingUp, isMirrored, isRepeated );
        appView.updateTimerValue(timerValue);
        WatchUi.requestUpdate();
    }

    function onIncrease() {
        System.println("onIncrease()");
        if (isCountingUp == false) {
            isCountingUp = true;
            Settings.setCountingUp(isCountingUp);
            startCounting();
        }
    }

    function onDecrease() {
        System.println("onDecrease()");
        if (isCountingUp == true) {
            isCountingUp = false;
            Settings.setCountingUp(isCountingUp);
            startCounting();
        }
    }

    function onExit() {
        // Clean up timer
        System.println("onExit called");
        if (isCounting == false) {
            isCountingUp = true;
            startCounting();
        }
        oneSecTimer.stop();
    }

    public function onKey(evt as KeyEvent) as Boolean {
        var key = evt.getKey();
        System.println("Key Event received: " + key);
        if (key == WatchUi.KEY_UP) {
            onIncrease();
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            onDecrease();
            return true;
        }

        if (key == WatchUi.KEY_ENTER) {
            System.println("KEY_ENTER pressed");
            onSelect();
            return true;
        }

        if (key == WatchUi.KEY_ESC) {
            System.println("KEY_ESC pressed");
            return handleBack();
        }
        return false;
    }

    function onSwipe(evt) {
        var direction = evt.getDirection();

        System.println("Swipe Event received: " + direction);


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
        System.println("handleBack(), isCounting = " + isCounting);
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
        System.println("onConfirmed(): confirmed = " + confirmed);
        if (confirmed == WatchUi.CONFIRM_YES) {
            Settings.saveSettings();
            onExitCust();
        } else {
            // user cancelled
            System.println("User chose not to exit");
        }
    }

    function onExitCust() {
        System.println("Exiting application");
        System.exit();
    }
    
    function onMenu() as Boolean {
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

        WatchUi.pushView(menu, new $.SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function updateVariables() as Void {
        isCountingUp = Settings.getCountingUp();
        isMirrored = Settings.getMirrored();
        isRepeated = Settings.getRepeated();
        appView.setCountingParameters(isCountingUp, isMirrored, isRepeated);
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