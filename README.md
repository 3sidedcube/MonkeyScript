# MonkeyScript

Install and test application asynchronously on all connected devices via the Android Monkey Tool.

## Install.sh

* Clears data for the given `package name` on **all connected devices**
* Installs the given `APK file` on **all connected devices**

Template: `install.sh PACKAGE APK`

Example: `install.sh com.jamie.gratitude gratitude.apk`

## Test.sh

* Tests the given `package name` on **all connected devices**
* With a `delay` between each event
* With the given `number of events`

Additional benefits:
* Produces consistent event timings as per these findings
* Allows you to accurately estimate the duration of the test

Template: `test.sh PACKAGE DELAY EVENTS`

Example: `test.sh com.jamie.gratitude 50 7000`

## Test-inconsistently.sh

*USE TEST.SH INSTEAD IF YOU WANT TO ESTIMATE THE DURATION OF THE TEST*

* Tests the given `package name` on **all connected devices**
* With a `delay` between each event
* With the given `number of events`

Template: `test.sh PACKAGE DELAY EVENTS`

Example: `test.sh com.jamie.gratitude 50 7000`
