import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;
using Toybox.Time.Gregorian as Date;

import DataProvider;

class WheelchairView extends WatchUi.WatchFace {
    private var screenWidth;
    private var screenHeight;
    private var pushesImage;
    private var connectedImage;
    private var disconnectedImage;
    private var heartImage;
    // forecast images
    private var sunnyImage;
    private var rainyImage;
    private var snowyImage;
    private var cloudyImage;
    private var thunderImage;
    private var config;

    function initialize() {
        WatchFace.initialize();
        var deviceInfo = System.getDeviceSettings();
        // 390*390 for vivoactive + venu3s
        if ( deviceInfo.screenWidth == 455 ){
            config = {
                "forecastX" => 50,
                "bluetooth" => 0,
                "pushesX" => 0,
                "weather" => 0
            };
        } else {
            // 454*454 for venu3
            config = {
                "forecastX" => 50,
                "bluetooth" => 0,
                "temperature" => 0,
                "weather" => 0
            };
        }
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
        sunnyImage = Application.loadResource(Rez.Drawables.sunny);
        rainyImage = Application.loadResource(Rez.Drawables.rain);
        snowyImage = Application.loadResource(Rez.Drawables.snow);
        cloudyImage = Application.loadResource(Rez.Drawables.cloudy);
        thunderImage = Application.loadResource(Rez.Drawables.thunder);
    }
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {}
    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        // Draw the UI
        drawRing(dc);
        drawHeartRate(dc, heartImage);
        drawPushes(dc);
        drawHoursMinutes(dc);
        drawDate(dc);
        drawBatteryBluetooth(dc);
        drawTemperature(dc);
        drawWeather(dc);
    }
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {}
    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {}
    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {}
    private function drawRing(dc) {
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var radius = screenWidth / 2;
        var startAngle = 0;
        var endAngle = 360;
        var attr = Graphics.ARC_COUNTER_CLOCKWISE;
        dc.setColor(Graphics.COLOR_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(16); // Adjust the thickness of the ring
        dc.drawArc(centerX, centerY, radius, attr, startAngle, endAngle);
    }
    private function drawHeartRate(dc, image) {
        var imageWidth = image.getWidth();
        var angle_deg = 225; // 7:30 PM on the clock in degrees
        var angle_rad = angle_deg * (Math.PI / 180);
        var radius = screenWidth / 2;
        var heartX = screenWidth / 2 + radius * Math.cos(angle_rad);
        var heartY = screenHeight / 2 - radius * Math.sin(angle_rad);
        var heartRate = DataProvider.getHeartRate();
        dc.setColor(
            (heartRate != null && heartRate > 120) ? Graphics.COLOR_DK_RED : Graphics.COLOR_LT_GRAY,
            Graphics.COLOR_TRANSPARENT
        );
        var x = heartX + imageWidth;
        var y = heartY + 20;
        var heartTextOffset = -5;
        if (heartRate != null && heartRate >= 100) {
            heartTextOffset = 0;
        }
        dc.drawBitmap(
            heartX,
            heartY + 10,
            heartImage 
        );
        dc.drawText(
            x + heartTextOffset,
            y,
            Graphics.FONT_SMALL,
            (heartRate == 0 || heartRate == null) ? "N/A" : heartRate.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER // Changed to center justify
        );
    }
    private function drawPushes(dc) {
        var pushes = DataProvider.getPushes();
        var pushesOffset = 0;
        if (pushes != null && pushes > 10000.0){
            pushesOffset = -5;
        }
        var pushesInK = pushes / 1000.0;
        var formattedPushes = pushesInK.format("%.1f") + "K";
        dc.setColor(
            pushes > 10000 ? Graphics.COLOR_DK_GREEN : Graphics.COLOR_LT_GRAY,
            Graphics.COLOR_TRANSPARENT
        );
        var angle_deg = 345; // 2:45 PM, symmetrical to 195 degrees for heart
        var angle_rad = angle_deg * (Math.PI / 180);
        var radius = screenWidth / 2;
        var x = screenWidth / 2 + radius * Math.cos(angle_rad);
        var y = screenHeight / 2 - radius * Math.sin(angle_rad);
        var imgWidth = pushesImage.getWidth();
        var imgHeight = pushesImage.getHeight();
        // Draw the pushes image to the left of the text
        dc.drawBitmap(
            x - imgWidth + pushesOffset, 
            y - imgHeight / 2,
            pushesImage
        );
        dc.drawText(
            x,
            y,
            Graphics.FONT_SMALL,
            formattedPushes,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
    private function drawHoursMinutes(dc) {
        var clockTime = DataProvider.getCurrentTime();
        var hours = clockTime.hour;
        if (hours > 12) {
            hours -= 12;
        }
        if (hours == 0) {
            hours = 12;
        }
        clockTime = System.getClockTime();
        var hour12 = clockTime.hour % 12;
        if (hour12 == 0) {
            hour12 = 12;
        }
        var timeString = Lang.format("$1$:$2$", [hour12.format("%d"), clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
    }
    private function drawDate(dc) {
        var date = DataProvider.getCurrentDate();
        var dateString = Lang.format("$1$ $2$ $3$", [date.day_of_week, date.month, date.day]);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            screenWidth / 2,
            60,
            Graphics.FONT_SMALL,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
    private function drawBatteryBluetooth(dc) {
        var battery = DataProvider.getBatteryLevel();
        var add100EdgeCase = 8;
        if (battery == 100) {
            add100EdgeCase = -4;
        }
        var batteryText = battery.format("%d") + "\u0025";
        var bluetoothState = DataProvider.getBluetoothStatus();
        // Check if connected
        var isConnected = (bluetoothState == 2); // Or use the appropriate enum if available
        var bluetoothImg = isConnected ? connectedImage : disconnectedImage; 
        var height = 24;
        var width = 48;
        // Coordinates for 2PM
        var angle_deg = 60; // 2 PM on the clock in degrees
        var angle_rad = angle_deg * (Math.PI / 180);
        var radius = screenWidth / 4;
        var x = screenWidth / 2 + radius * Math.cos(angle_rad) + add100EdgeCase - 8;
        var y = screenHeight / 2 - radius * Math.sin(angle_rad); // Note the '-' because of the coordinate system
        dc.setPenWidth(2);
        dc.setColor(
            battery <= 20 ? Graphics.COLOR_DK_RED : Graphics.COLOR_GREEN,
            Graphics.COLOR_TRANSPARENT
        );
        // Draw the outer rect
        dc.drawRoundedRectangle(
            x,
            y,
            width,
            height,
            2
        );
        // Draw the small + on the right
        dc.drawLine(
            x + width + 1,
            y + 3,
            x + width + 1,
            y + height - 3
        );
        // Fill the rect based on current battery
        dc.fillRectangle(
            x + 1,
            y,
            (width - 2) * battery / 100,
            height
        );
        // Adjust text position
        var text_x = x + width + 20; // Shift text 5 units to the right of the battery rectangle
        var text_y = y + height / 2 - 2; // Align the text vertically centered to the battery rectangle
        dc.drawText(
            text_x,
            text_y,
            Graphics.FONT_SMALL,
            batteryText,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER // Left justify and vertically center
        );
        // Draw the bluetooth to the right of the text
        dc.drawBitmap(
            x + 78 - add100EdgeCase, 
            y + height / 2,
            bluetoothImg
        );
    }
     private function drawTemperature(dc) {
        var tempOffset = 0;
        var temperature = DataProvider.getTemperature();
        if (temperature != null && temperature >= 100) {
            tempOffset = 5;
        }
        var tempString = (temperature == null) ? "N/A" : temperature.format("%d");
        var degreeSymbol = (temperature == null) ? "" : "°";
        var angle_deg = 155; // 10:30 in degrees
        var angle_rad = angle_deg * (Math.PI / 180);
        var radius = screenWidth / 2;
        var x = screenWidth / 2 + radius * Math.cos(angle_rad) + 105;
        var y = screenHeight / 2 - radius * Math.sin(angle_rad);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        // Draw the degree symbol, with a manual offset
        dc.drawText(
            x+10,
            y,
            Graphics.FONT_SMALL,
            tempString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            x + tempOffset + 30,
            y,
            Graphics.FONT_SMALL,
            degreeSymbol,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
    private function drawWeather(dc) {
        var weatherCondition = DataProvider.getForecast();
        if (weatherCondition == null) {
            weatherCondition = 0;
        }
        var weatherImage;
        // Assume weatherCondition is a number based on Garmin's API
        switch(weatherCondition) {
            // Clear conditions
            case 0:  // CONDITION_CLEAR
            case 22: // CONDITION_PARTLY_CLEAR
            case 23: // CONDITION_MOSTLY_CLEAR
            case 40: // CONDITION_FAIR
                weatherImage = sunnyImage;
                break;
            // Cloudy conditions
            case 1:  // CONDITION_PARTLY_CLOUDY
            case 2:  // CONDITION_MOSTLY_CLOUDY
            case 20: // CONDITION_CLOUDY
            case 52: // CONDITION_THIN_CLOUDS
                weatherImage = cloudyImage;
                break;
            // Rainy conditions
            case 3:  // CONDITION_RAIN
            case 14: // CONDITION_LIGHT_RAIN
            case 15: // CONDITION_HEAVY_RAIN
            case 25: // CONDITION_SHOWERS
            case 26: // CONDITION_HEAVY_SHOWERS
            case 27: // CONDITION_CHANCE_OF_SHOWERS
            case 45: // CONDITION_CLOUDY_CHANCE_OF_RAIN
                weatherImage = rainyImage;
                break;
            // Snowy conditions
            case 4:  // CONDITION_SNOW
            case 16: // CONDITION_LIGHT_SNOW
            case 17: // CONDITION_HEAVY_SNOW
            case 43: // CONDITION_CHANCE_OF_SNOW
            case 46: // CONDITION_CLOUDY_CHANCE_OF_SNOW
            case 48: // CONDITION_FLURRIES
                weatherImage = snowyImage;
                break;
            // Thunderstorm conditions
            case 6:  // CONDITION_THUNDERSTORMS
            case 12: // CONDITION_SCATTERED_THUNDERSTORMS
            case 28: // CONDITION_CHANCE_OF_THUNDERSTORMS
                weatherImage = thunderImage;
                break;
            // Unhandled cases
            default:
                weatherImage = sunnyImage;
                break;
        }
        var imgHeight = weatherImage.getHeight();
        var angle_deg = 155;
        var angle_rad = angle_deg * (Math.PI / 180);
        var radius = screenWidth / 2;
        var x = screenWidth / 2 + radius * Math.cos(angle_rad) + config["forecastX"]; 
        var y = screenHeight / 2 - radius * Math.sin(angle_rad);
        dc.drawBitmap(
            x,
            y - imgHeight / 2,
            weatherImage
        );
    }
}
