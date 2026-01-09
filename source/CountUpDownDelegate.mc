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

    function initialize() {
        //System.println("5: App Delegate initialized");
        oneSecTimer = new Timer.Timer();
        oneSecTimer.start(method(:oneSecondCyclicFunction), 1000, true);
        appView.setCountingDirection(isCountingUp);
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        //System.println("11: App Delegate on Menu called");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new CountUpDownMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onBack() as Boolean {
        //System.println("Main View back key pressed 1111");
        if((timerValue == 0) && (isCounting == false)) {
            //System.println("Timer is at zero and not counting, cannot count down");
            isCountingUp = true;
            //System.println("Setting count direction to up from back key");
            startCounting();
        } else {
            //System.println("Reversing count direction from back key");
            isCountingUp = !isCountingUp;
        }

        if (isCountingUp) {
            //System.println("Counting Up started 1111");
            appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
        } else {
            //System.println("Counting Down started 1111");
            appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
        }
        appView.setCountingDirection(isCountingUp);
        return true;
    }

    function onSelect() as Boolean {
        //System.println("Main View item selected 1111");
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
        //System.println("Starting counting 1111");
        isCounting = true;
    }

    function stopCounting() as Void {
        //System.println("Stopping counting 1111");
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

}