import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class CountUpDownDelegate extends WatchUi.BehaviorDelegate {
    private static var timerValue = 0;
    private var timerRunning = false;
    var isCountingUp = true;
    var oneSecTimer;
    private var appView = getView();
    static var isCountingUpOld = true;
    // var timerValue = 0;

    function initialize() {
        System.println("5: App Delegate initialized");
        oneSecTimer = new Timer.Timer();

        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        System.println("11: App Delegate on Menu called");
        WatchUi.pushView(new Rez.Menus.MainMenu(), new CountUpDownMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onBack() as Boolean {
        System.println("Main View back key pressed 1111");
        if(timerRunning == true) {
                isCountingUp = !isCountingUp;
                System.println("Reversing count direction from back key");
        } else {
            if(isCountingUp == false) {
                isCountingUp = true;
                System.println("Setting count direction to up from back key");
                startCounting();
            }
        }


        return true;
    }

    function onSelect() as Boolean {
        System.println("Main View item selected 1111");
        if(timerRunning == false) {
            timerRunning = true;
            startCounting();
            if (isCountingUp) {
                System.println("Counting Up started 1111");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountUp);
            } else {
                System.println("Counting Down started 1111");
                appView.updateCurrentDirectionDescription(CountDirectionType.CountDown);
            }
        }
        else {
            timerRunning = false;
            stopCounting();
            System.println("Counting stopped 1111");
            appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
        }

        return true;
    }

    function startCounting() as Void {
        System.println("Starting counting 1111");
        oneSecTimer.start(method(:oneSecondTimerCallback), 1000, true);
    }

    function stopCounting() as Void {
        System.println("Stopping counting 1111");
        oneSecTimer.stop();
    }

    function oneSecondTimerCallback() as Void {
        
        System.println("10: One Second Timer Callback called");

        if (isCountingUp == true) {
            timerValue += 1;
        } else {
            timerValue -= 1;
        }

        if (timerValue <= 0) {
            timerValue = 0;
            stopCounting();
            System.println("Timer reached zero, stopping counting");
            appView.updateCurrentDirectionDescription(CountDirectionType.Paused);
            isCountingUp = true;
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
        appView.updateTimerValue(timerValue);
        // WatchUi.requestUpdate();
    }

}