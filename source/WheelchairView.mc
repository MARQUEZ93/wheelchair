import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using DataProvider;

class WheelchairView extends WatchUi.WatchFace {

    private var screenWidth;
    private var screenHeight;
    private var heartWidth = 0;
    private var pushesImage;
    private var connectedImage;
    private var disconnectedImage;
    private var heartImage;
    private var backgroundImage;
    private var copperFont;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        screenWidth = dc.getWidth();
        screenHeight = dc.getHeight();
        pushesImage = Application.loadResource(Rez.Drawables.pushes);
        disconnectedImage = Application.loadResource(Rez.Drawables.disconnected);
        connectedImage = Application.loadResource(Rez.Drawables.connected);
        heartImage = Application.loadResource(Rez.Drawables.heart);
        backgroundImage = Application.loadResource(Rez.Drawables.purple);
        copperFont = Application.loadResource(Rez.Fonts.CopperFont);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setBlendMode(Graphics.BLEND_MODE_SOURCE); // Ensure there's no blending while drawing the background
        dc.drawBitmap(0, 0, backgroundImage);
        
        timeString = "12:34";  // Your time string

        // Create or load a custom font if necessary
        var font = copperFont;  // For example

        dc.drawBitmap(0, 0, backgroundImage);

        var d = 75; // Adjust this value to increase/decrease the distance between characters
        var theta = 10 * (Math.PI / 180); 
        var dx = Math.round(d * Math.cos(theta));
        var dy = Math.round(d * Math.sin(theta));

        var startX = screenWidth / 5;
        var startY = screenHeight / 3;

        var ascCoords = [];

        // Calculate ascCoords
        for (var i = 0; i < timeString.length(); i++) {
            ascCoords.add([startX + i * dx, startY - i * dy]);
        }

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

        var j = 0;
        for (var i = 0; i < timeString.length(); i++) {
            var char = timeString.substring(i, i + 1);
            dc.drawText(ascCoords[j][0], ascCoords[j][1], font, char, Graphics.TEXT_JUSTIFY_CENTER);
            j++;
        }
        drawRing(dc);
    }

    private function drawRing(dc) {
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var radius = screenWidth / 2;
        var startAngle = 0;
        var endAngle = 360;
        var attr = Graphics.ARC_COUNTER_CLOCKWISE;
        dc.drawArc(centerX, centerY, radius, attr, startAngle, endAngle);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
