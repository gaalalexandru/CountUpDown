import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

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

    function onMenu() as Boolean {
        System.println("CountUpDownDelegate: onMenu()");
        WatchUi.pushView(new Rez.Menus.MainMenu(),
                         new $.CountUpDownMenuDelegate(),
                         WatchUi.SLIDE_UP);
        return true;
    }

    // function onBack() as Boolean {
    //     System.println("onBack()");
    //     if((timerValue == 0) && (isCounting == false)) {
    //         //System.println("Timer is at zero and not counting, cannot count down");
    //         isCountingUp = true;
    //         //System.println("Setting count direction to up from back key");
    //         startCounting();
    //     } else {
    //         //System.println("Reversing count direction from back key");
    //         isCountingUp = !isCountingUp;
    //     }

    //     if (isCountingUp) {
    //         //System.println("Counting Up started 1111");
    //         appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
    //     } else {
    //         //System.println("Counting Down started 1111");
    //         appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
    //     }
    //     appView.setCountingDirection(isCountingUp);
    //     return true;
    // }

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
            if (isCountingUp == true) {
                timerValue += 1;
            } else {
                timerValue -= 1;
            }
        }

        if (timerValue <= 0) {
            timerValue = 0;
            stopCounting();
            //System.println("Timer reached zero, stopping counting");
            appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
            isCountingUp = true;
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
            startCounting();
        }
    }

    function onDecrease() {
        System.println("onDecrease()");
        if (isCountingUp == true) {
            isCountingUp = false;
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
}