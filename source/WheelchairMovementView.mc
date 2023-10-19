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
        
         // Set the color
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.setPenWidth(10);
        // Declare coordinates and dimensions
        
        var timeX = 160;  // Center X of the text
        var timeY = 125;  // Center Y of the text
        
        timeString = "12:34AM";  // Your time string

        // Create or load a custom font if necessary
        var font = copperFont;  // For example
        // var font = Ui.loadResource(Rez.Fonts.CustomFont);  // Assuming a custom font is loaded

        dc.drawBitmap(0, 0, backgroundImage);

        // Create and draw the clipping mask
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(timeX, timeY, font, timeString, Graphics.TEXT_JUSTIFY_CENTER);
        drawRing(dc);
    }

     private function drawRing(dc) {
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var radius = screenWidth / 2;
        var startAngle = 0;
        var endAngle = 360;
        var attr = Graphics.ARC_COUNTER_CLOCKWISE;

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(10); // Adjust the thickness of the ring
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
