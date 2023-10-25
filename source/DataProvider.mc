using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.System;
using Toybox.Time.Gregorian as Date;
using Toybox.Time as Time;
using Toybox.Weather as Weather;
using Toybox.WatchUi;
using Toybox.Position;

module DataProvider {
    function getHeartRate() {
        var heartRate = 0;
        var info = Activity.getActivityInfo();
        if (info != null && info.currentHeartRate != null) {
            heartRate = info.currentHeartRate;
        } else {
            var latestHeartRateSample = ActivityMonitor.getHeartRateHistory(1, true).next();
            if (latestHeartRateSample != null && latestHeartRateSample.heartRate != null) {
                heartRate = latestHeartRateSample.heartRate;
            }
        }
        return heartRate;
    }
    function getPushes() {
        var info = ActivityMonitor.getInfo();
        var pushes = 0;
        if (info != null && info.pushes != null) {
            pushes = info.pushes;
        }
        return pushes;
    }
    function getBatteryLevel() {
        return System.getSystemStats().battery;
    }
    function getBluetoothStatus() {
        var deviceSettings = System.getDeviceSettings();
        return deviceSettings.connectionInfo[:bluetooth].state;
    }
    function getCurrentTime() {
        return System.getClockTime();
    }
    function getCurrentDate() {
        return Date.info(Time.now(), Time.FORMAT_MEDIUM);
    }
    function getTemperature() {
        var conditions = Weather.getCurrentConditions();
        if (conditions != null) {
            var tempCelsius = conditions.temperature;
            if (tempCelsius == null) {
                return null;
            }
            var tempFahrenheit = (tempCelsius * 9/5) + 32;
            return tempFahrenheit;
        }
        return null; 
    }
    function getForecast() {
        var conditions = Weather.getCurrentConditions();
        if (conditions != null) {
            return conditions.condition;
        }
        return null; 
    }
}
