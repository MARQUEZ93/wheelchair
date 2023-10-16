# The Wheelchair Movement

## Compatible Devices

1) Garmin Forerunner 255m 
2) Garmin Forerunner 255

<!-- <p align="center"><img src="https://i.imgur.com/NadKoiL.jpg" width="200px" /></p> -->

## Features
- 🕚 Time (Hours:Minutes)
- 📅 Date (Day.Month.Day of Week)
- 🔋 Battery
- 💗 Heart Rate
- 📶 Bluetooth Connection Status
- ♿ Today's Pushes

## Origin

I originally began developing a watchface for Dexcom/Diabetic users (I am Type 1 Diabetic).

During development, I learned the Garmin SDK does not allow a Watch Face app to access the
[Dexcom Data Field](https://apps.garmin.com/en-US/apps/9040cc1d-13de-4d48-a859-6c2a0cedec3e)

This is sad (I reached out to both Dexcom & Garmin. Received no response). 

Irregardless, I spent too much time w/ the Garmin SDK to not publish something. 

While looking over API Documentation, I noticed the [pushDistance](https://developer.garmin.com/connect-iq/api-docs/Toybox/ActivityMonitor/Info.html#pushDistance-var) field. I found zero results for 'Wheelchair' or 'Wheel Chair' in the Garmin IQ Connect Store (Diabetes/Dexcom doesn't have many options neither). 

My goal is for one download & one positive review :) 

## Credits

- [Kai Hao](https://kaihao.dev/posts/Develop-a-Garmin-watch-face)

## Design

I used the existing [Movement](https://apps.garmin.com/en-US/apps/1653693f-7231-46ef-8951-04d51e58b6d6) design as a template

## Contact

showmethecodevideos@gmail.com

Email me any bugs, edge cases not handled, improvements etc. I rely on the CIQ Simulator for testing different devices. 
