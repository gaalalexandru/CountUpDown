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
    private var screenWidth;
    private var screenHeight;
    private var iconX;
    private var iconY;
    var isCountingUp = true;

    function initialize() {
        //System.println("4: App View initialized");
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //System.println("6: App View on Layout called");
        setLayout(Rez.Layouts.MainLayout(dc));
        timeOfTheDayElement_hm = findDrawableById("timeHM") as Text;
        timeOfTheDayElement_sec = findDrawableById("timeSec") as Text;

        currentTimerElement = findDrawableById("currentTimer") as Text;
        currentDirectionDescriptionElement = findDrawableById("currentDirectionDescription") as Text;
        upArrowBitmap = WatchUi.loadResource(Rez.Drawables.UpIcon);
        downArrowBitmap = WatchUi.loadResource(Rez.Drawables.DownIcon);
        screenWidth  = dc.getWidth();
        screenHeight = dc.getHeight();

        // Center the heart icon
        iconX = ((screenWidth / 10 ) * 1.5 ) + (upArrowBitmap.getWidth() / 2);
        iconY = ((screenHeight / 10 ) * 7 ) + (upArrowBitmap.getHeight() / 2);

        // updateTimeOfTheDay();
        // updateTimerValue(158);
        // updateCurrentDirectionDescription(CountDirectionType.CountDown);
        // updateCurrentDirectionDescription(1);

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        //System.println("7: App View on Show called");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        //System.println("8: App View on Update called");
        updateTimeOfTheDay();

        // var clockTime = System.getClockTime();
        // var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
        // timeOfTheDayElement.setText(timeString);
        // currentTimerElement.setText(Lang.format("$1$:$2$", [ (timerValue / 60).format("%02d"), (timerValue % 60).format("%02d") ]));
        // Call the parent onUpdate function to redraw the layout
        
        View.onUpdate(dc);
        if (isCountingUp == true) {
            dc.drawBitmap(iconX, iconY, upArrowBitmap);
        } else {
            dc.drawBitmap(iconX, iconY, downArrowBitmap);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        //System.println("9: App View on Hide called");
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
                color = Graphics.COLOR_DK_RED;
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
        // timerValue = value;
        currentTimerElement.setText(Lang.format("$1$:$2$", [ minutes.format("%02d"), seconds.format("%02d") ]));
        // WatchUi.requestUpdate();
    }

    function setCountingDirection(isUp) {
        if (isCountingUp != isUp) {
            isCountingUp = isUp;
            WatchUi.requestUpdate(); // redraw ONLY when changed
        }
    }

}
