# MonkeyScript

Install & test asynchronously on all connected devices via the [Android Monkey](https://developer.android.com/studio/test/monkey.html)

# Android Monkey Overview

The Monkey is a command-line tool that you can run on any emulator instance or on a device. It sends "random" user events into the system, which acts as a stress test on the app

*Find out more by reading [MONKEY-README.md](MONKEY-README.md)*

# Scripts

## Install.sh

* Clears data for the given `package name` on *all connected devices*
* Installs the given `APK file` on **all connected devices**

Template: `install.sh PACKAGE APK`

Example: `install.sh com.example.app example.apk`

## Test.sh

* Tests the given `package name` on *all connected devices*
* With a `delay` between each event
* With the given `number of events`

Additional benefits:
* Produces consistent event timings [as per these findings](MONKEY-README.md#delaying-events)
* Allows you to accurately estimate the duration of the test

Template: `test.sh PACKAGE DELAY EVENTS`

Example: `test.sh com.example.app 50 7000`

## Test-inconsistently.sh

*If you wish to estimate the duration of the test you should instead use test.sh*

* Tests the given `package name` on *all connected devices*
* With a `delay` between each event
* With the given `number of events`

Template: `test.sh PACKAGE DELAY EVENTS`

Example: `test.sh com.example.app 50 7000`
