import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Graphics;

class CountUpDownDelegate extends WatchUi.BehaviorDelegate {
    private static var timerValue = 0;
    private var isCounting = false;
    private var isCountingUp = true;
    private var oneSecTimer;
    private var appView = getView();
    static var isCountingUpOld = true;
    private var _dialogHeaderString as String;

    function initialize()  {
        System.println("CountUpDownDelegate: initialize()");
        oneSecTimer = new Timer.Timer();
        oneSecTimer.start(method(:oneSecondCyclicFunction), 1000, true);
        appView.setCountingDirection(isCountingUp);
        BehaviorDelegate.initialize();
        _dialogHeaderString = WatchUi.loadResource($.Rez.Strings.DialogHeader) as String;
    }


    function onSelect() as Boolean {
        System.println("onSelect()");
        if(isCounting == false) {
            startCounting();
            if (isCountingUp) {
                //System.println("Counting Up started 1111");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                //System.println("Counting Down started 1111");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
        }
        else {
            stopCounting();
            //System.println("Counting stopped 1111");
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

    function oneSecondCyclicFunction() as Void {
        //System.println("10: One Second Timer Callback called");
        
        if(isCounting == true) {
            if (Settings.isCountingUp() == true) {
                timerValue += 1;
            } else {
                timerValue -= 1;
            }

            if (timerValue <= 0) {
                System.println("Timer reached zero");
                if (Settings.isRepeated() == true) {
                    // Reset or Mirror counting based on mode
                    System.print("Repeat counting, ");
                    if(Settings.isMirrored() == true) {
                        // Mirror mode: reverse direction
                        System.println("by reversing the counting direction ... ");
                        isCountingUp = !isCountingUp;
                        Settings.setCountingUp(isCountingUp);
                        System.println("isCountingUp = " + isCountingUp);
                    } else {
                        // Reset mode: reset timer to initial value
                        System.println("by reseting to the initial counter value ... ");
                        //AleGaa TODO: set to initial value
                        timerValue = 100;
                    }
                }
                else {
                    timerValue = 0;
                    stopCounting();
                }
                //System.println("Timer reached zero, stopping counting");
                appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
                isCountingUp = true;
            }
        }

        if (isCountingUp != isCountingUpOld) {
            // Direction changed, update description
            if (isCountingUp) {
                //System.println("Direction changed to Counting Up");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                //System.println("Direction changed to Counting Down");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
            isCountingUpOld = isCountingUp;
        }
        appView.setCountingDirection(isCountingUp);
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
        // var title = new $.DividerTitle();
        // if (!(WatchUi.Menu2 has :setDividerType)) {
        //     title = "App Settings";
        // }
        // var menu = new WatchUi.Menu2({:title=>title});

        menu.addItem(new WatchUi.ToggleMenuItem("Count Direction",
                                                {:enabled=>"Count Up", :disabled=>"Count Down"},
                                                "direction_toggle",
                                                Settings.isCountingUp(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        menu.addItem(new WatchUi.ToggleMenuItem("Count Type",
                                                {:enabled=>"Mirrored", :disabled=>"Reset"},
                                                "type_toggle",
                                                Settings.isMirrored(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        menu.addItem(new WatchUi.ToggleMenuItem("Count Repet",
                                                {:enabled=>"Repeated",
                                                :disabled=>"One Time"},
                                                "repeat_toggle",
                                                Settings.isRepeated(),
                                                {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}));

        // menu.addItem(new WatchUi.MenuItem("Custom", null, "custom", null));
        WatchUi.pushView(menu, new $.SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // function onMenu() as Boolean {
    //     System.println("CountUpDownDelegate: onMenu()");
    //     WatchUi.pushView(new Rez.Menus.MainMenu(),
    //                      new $.SettingsMenuDelegate(),
    //                      WatchUi.SLIDE_UP);
    //     return true;
    // }
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
        var settingsIcon = WatchUi.loadResource($.Rez.Drawables.Gear) as BitmapResource;
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