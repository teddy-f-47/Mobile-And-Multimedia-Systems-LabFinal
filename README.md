# city_guide

This repository contains the work for Final Project for Laboratorium of Mobile and Multimedia Systems. The application is developed with ***Flutter***.

This application is developed by following the "City guide v1" requirements, as it is submitted before the deadline for v1 on 19-May-2022 23:59:59.

## The built Android app

The APK file built for Android is available at:

build\app\outputs\flutter-apk\app-release.apk

The Appbundle file for Android is available at:

build\app\outputs\bundle\release\app-release.aab

## Screenshots

![Alt text](/dev_screenshots/1.PNG?raw=true "Main Page")
![Alt text](/dev_screenshots/2.PNG?raw=true "Events List")
![Alt text](/dev_screenshots/3.PNG?raw=true "Event Details")
![Alt text](/dev_screenshots/4.PNG?raw=true "Places List")
![Alt text](/dev_screenshots/5.PNG?raw=true "Place Details 1")
![Alt text](/dev_screenshots/6.PNG?raw=true "Place Details 2")
![Alt text](/dev_screenshots/7.PNG?raw=true "Accommodations List")
![Alt text](/dev_screenshots/8.PNG?raw=true "Accommodation Details")
![Alt text](/dev_screenshots/9.PNG?raw=true "Reviews")
![Alt text](/dev_screenshots/10.PNG?raw=true "Write Review")
![Alt text](/dev_screenshots/11.PNG?raw=true "Guided Tours List")
![Alt text](/dev_screenshots/12.PNG?raw=true "Guided Tour Details")

## The code

All of the code for developing the app is available in the directory lib/.

Map with route functionality is implemented using Google's APIs: Maps SDK for Android, Geocoding API, Directions API.

Rating and review functionality is implemented using Google's Places API; the option for the user to write a review is implemented by launching the browser to open the review writing page on the object's Google Place page.

Voice description functionality is implemented by using Android's text-to-speech engine that is made available via the flutter_tts package.

Video functionality is implemented by embedding YouTube videos. If a Place has more than one video, "Prev" and "Next" buttons are available to navigate between these videos.

Data like names, descriptions, placeIds, and videoIds for the modules are provided locally by four json files in the assets folder: events.json, places.json, accommodations.json, tours.json.

## Dependencies

Information about dependencies can be found in the file pubspec.yaml.
