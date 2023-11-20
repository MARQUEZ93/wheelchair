# A Free Wheelchair Watchface for Garmin Devices

## Garmin Connect IQ Store

The Wheelchair Watchface for Garmin Devices is available here: [Garmin Connect IQ Store](https://apps.garmin.com/en-US/apps/d8257408-647d-410f-adcb-bfcde86541a0)

## Compatible Devices (Since API Level 4.2.3)

Per [Garmin documentation](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor/Info.html#pushDistance-var), only three devices support Wheelchair push count:

1) Venu® 3
2) Venu® 3S
3) vívoactive® 5

<p align="center"><img src="https://i.imgur.com/IrHsYCD.png" width="200px" /></p>

## Features
- 🕚 Time (Hours:Minutes)
- 📅 Date (Day.Month.Day of Week)
- 🔋 Battery
- 💗 Heart Rate
- 📶 Bluetooth Connection Status
- ♿ Today's Pushes
- 🔔 Notifications 

## Origin

I originally began developing a watchface for Dexcom/Diabetic users (I am Type 1 Diabetic). There are only two options when searching either Diabetes/Dexcom/Diabetic. Both require the user to provide their Dexcom credentials.

During development, I learned the Garmin SDK does not allow a Watch Face app to access the
[Dexcom Data Field](https://apps.garmin.com/en-US/apps/9040cc1d-13de-4d48-a859-6c2a0cedec3e)

This is sad (I reached out to both Dexcom & Garmin. Received no response). 

Irregardless, I spent too much time w/ the Garmin SDK to not publish something. 

While looking over API Documentation to resolve my Dexcom Data Field problem, I noticed the [pushDistance](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor/Info.html#pushDistance-var) field. I found zero results for 'Wheelchair' or 'Wheel Chair' in the Garmin IQ Connect Store.

## Credits

- [Kai Hao](https://kaihao.dev/posts/Develop-a-Garmin-watch-face)

## Development

This project was developed using Visual Studio Code with the [Monkey C VS Code extension](https://developer.garmin.com/connect-iq/reference-guides/visual-studio-code-extension/). Testing was done via the CIQ Simulator.

## Contact

showmethecodevideos@gmail.com

Email me any improvements and/or edge cases not handled etc. I rely on the CIQ Simulator for testing different devices.
