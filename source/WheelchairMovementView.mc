import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using DataProvider;

class WheelchairMovementView extends WatchUi.WatchFace {

    private var screenWidth;
    private var screenHeight;
    private var heartWidth = 0;
    private var pushesImage;
    private var connectedImage;
    private var disconnectedImage;
    private var heartImage;
    private var backgroundImage;

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
        
         // Set the color
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.setPenWidth(28);
        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );
        var last = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
        // Draw the text
        var x = 150;
        var y = 150;
        var offset = 1; // Adjust as needed
        var font = Graphics.FONT_SYSTEM_LARGE;

        dc.drawText(x + offset, y,font, "10:08", last);
        dc.drawText(x - offset, y,font, "10:08", last);
        dc.drawText(x, y + offset,font, "10:08", last);
        dc.drawText(x, y - offset,font,"10:08", last);
        dc.drawText(x, y,font, "10:08", last);
        drawRing(dc);
    }

     private function drawRing(dc) {
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var radius = screenWidth / 2 - 5; // 5 pixels from the edge
        var startAngle = 0;
        var endAngle = 360;
        var attr = Graphics.ARC_COUNTER_CLOCKWISE;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(6); // Adjust the thickness of the ring
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
