import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;

class CountUpDownView extends WatchUi.View {
    private var timeOfTheDayElement_hm;
    private var timeOfTheDayElement_sec;
    private var currentTimerElement;
    private var currentDirectionDescriptionElement;
    private var upArrowBitmap;
    private var downArrowBitmap;
    private var repeatOnceBitmap;
    private var repeatForeverBitmap;
    private var countUpResetBitmap;
    private var countDownResetBitmap;
    private var countMirroredBitmap;
    private var screenWidth;
    private var screenHeight;
    private var iconXLeft;
    private var iconXRight;
    private var iconXCenter;
    private var iconYTop;
    private var iconYBottom;
    private var isCountingUpView = false;
    private var isRepeatedView = false;
    private var isMirroredView = false;

    function initialize() {
        System.println("4: App View initialized");
        View.initialize();
        isCountingUpView = Settings.getCountingUp();
        isRepeatedView = Settings.getRepeated();
        isMirroredView = Settings.getMirrored();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        System.println("6: App View on Layout called");
        setLayout(Rez.Layouts.MainLayout(dc));
        timeOfTheDayElement_hm = findDrawableById("timeHM") as Text;
        timeOfTheDayElement_sec = findDrawableById("timeSec") as Text;

        currentTimerElement = findDrawableById("currentTimer") as Text;
        currentDirectionDescriptionElement = findDrawableById("currentDirectionDescription") as Text;
        upArrowBitmap = WatchUi.loadResource(Rez.Drawables.UpIcon);
        downArrowBitmap = WatchUi.loadResource(Rez.Drawables.DownIcon);
        repeatForeverBitmap = WatchUi.loadResource(Rez.Drawables.RepeatForeverIcon);
        repeatOnceBitmap = WatchUi.loadResource(Rez.Drawables.RepeatOnceIcon);
        countUpResetBitmap = WatchUi.loadResource(Rez.Drawables.CountUpResetIcon);
        countDownResetBitmap = WatchUi.loadResource(Rez.Drawables.CountDownResetIcon);
        countMirroredBitmap = WatchUi.loadResource(Rez.Drawables.CountMirroredIcon);
        screenWidth  = dc.getWidth();
        screenHeight = dc.getHeight();

        // Center the heart icon
        iconXLeft = ((screenWidth / 10 ) * 1.5) + (upArrowBitmap.getWidth() / 2); //15% from left
        iconXRight = ((screenWidth / 10 ) * 8 ) - (upArrowBitmap.getWidth() / 2); //80% from left or 20% from right :)
        iconXCenter = (screenWidth / 2) - (countMirroredBitmap.getWidth() / 2); //centered
        iconYTop = ((screenHeight / 10 ) * 6.8 ) + (upArrowBitmap.getHeight() / 2); //70% from top
        iconYBottom = ((screenHeight / 10 ) * 8 ) + (countMirroredBitmap.getHeight() / 2); //80% from top

        // updateTimeOfTheDay();
        // updateTimerValue(158);
        // updateCurrentDirectionDescription(CountDirectionType.CountDown);
        // updateCurrentDirectionDescription(1);

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        System.println("7: App View on Show called");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // System.println("8: App View on Update called");
        updateTimeOfTheDay();

        // var clockTime = System.getClockTime();
        // var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
        // timeOfTheDayElement.setText(timeString);
        // currentTimerElement.setText(Lang.format("$1$:$2$", [ (timerValue / 60).format("%02d"), (timerValue % 60).format("%02d") ]));
        // Call the parent onUpdate function to redraw the layout
        
        View.onUpdate(dc);
        if (isCountingUpView == true) {
            dc.drawBitmap(iconXLeft, iconYTop, upArrowBitmap);
        } else {
            dc.drawBitmap(iconXLeft, iconYTop, downArrowBitmap);
        }
        
        if (isRepeatedView == true) {
            dc.drawBitmap(iconXRight,  iconYTop, repeatForeverBitmap);
        } else {
            dc.drawBitmap(iconXRight,  iconYTop, repeatOnceBitmap);
        }

        if (isMirroredView == true) {
            dc.drawBitmap(iconXCenter,  iconYBottom, countMirroredBitmap);
        } else {
            if(isCountingUpView == true) {
                dc.drawBitmap(iconXCenter,  iconYBottom, countUpResetBitmap);
            } else {
                dc.drawBitmap(iconXCenter,  iconYBottom, countDownResetBitmap);
            }
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        System.println("9: App View on Hide called");
    }

    function updateTimeOfTheDay() as Void {
        var clockTime = System.getClockTime();
        var timeHM = Lang.format("$1$:$2$",[clockTime.hour, clockTime.min.format("%02d")]);
        var timeSec = clockTime.sec.format("%02d");
        timeOfTheDayElement_hm.setText(timeHM);
        timeOfTheDayElement_sec.setText(":" + timeSec);
    }

    // function updateCurrentDirectionDescription(countDirection as CountDirectionType) as Void {
    function updateCurrentDirectionDescription(countDirection) as Void {
        var label = "Paused";
        var color = Graphics.COLOR_YELLOW;

        switch (countDirection) {
            case CountDirectionType.CountUp:
                label = "Count Up";
                color = Graphics.COLOR_GREEN;
                break;
            case CountDirectionType.CountDown:
                label = "Count Down";
                color = Graphics.COLOR_GREEN;
                break;
            case CountDirectionType.Paused:
                label = "Paused";
                color = Graphics.COLOR_YELLOW;
                break;
        }
        
        currentDirectionDescriptionElement.setText(label);
        currentDirectionDescriptionElement.setColor(color);
        // WatchUi.requestUpdate();
    }

    function updateTimerValue(value) as Void {
        var minutes = (value / 60);
        var seconds = (value % 60);
        currentTimerElement.setText(Lang.format("$1$:$2$", [ minutes.format("%02d"), seconds.format("%02d") ]));
        // WatchUi.requestUpdate();
    }

    function setCountingParameters(isUp, isMir, isRep) as Void {
        var requestUpd = false;
        if (isCountingUpView != isUp) {
            isCountingUpView = isUp;
        }

        if (isMirroredView != isMir) {
            isMirroredView = isMir;
            requestUpd = true;
        }

        if (isRepeatedView != isRep) {
            isRepeatedView   = isRep;
            requestUpd = true;
        }

        if (requestUpd == true) {
            WatchUi.requestUpdate(); // redraw ONLY when changed
        }
    }

}
