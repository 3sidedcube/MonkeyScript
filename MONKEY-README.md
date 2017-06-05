# UI/Application Exerciser Monkey

## Overview

The Monkey is a command-line tool that you can run on any emulator instance or on a device. It sends "random" user events into the system, which acts as a stress test on the app.

## Monkey events
The Monkey inputs "random" events to the device that are one of the following types of events:

### Touch

* Down-up event in a single place on the screen

### Motion

* A down event somewhere on the screen, a series of pseudo-random movements, and an up event.

### Trackball

* One or more random movements, sometimes followed by a click

### Navigation

* Up/down/left/right, as input from a directional input device

### Major navigation

* Events that will typically cause actions within your UI, such as the center button in a 5-way pad, the back key, or the menu key.

### System keys

* Events that are generally reserved for use by the system, such as Home, Back, Start Call, End Call, or Volume controls.

### App Switching

* Issued at random intervals to maximize coverage of all sections in the app.

### Any Event

* Catch-all for all other types of events such as keypresses, other less-used buttons on the device, and so forth.

## How to use Monkey

A basic command to start the Monkey is:
```
adb shell monkey -p com.example.app --throttle 100 1000
```

1. `adb` uses the adb tool to interface with the connected device
2. `shell` goes into the shell of the given device, which we need acces to in order to use the Monkey
3. `monkey` sends the commands after this to the Monkey tool
4. `-p com.example.app` tells Monkey to limit the input to the given package name.
5. `--throttle 100` tells Monkey to wait 100ms after every event
5. `1000` tells monkey to execute this number of events. This parameter should always be at the end.

## Delaying events

The documentation for the `throttle` parameter says:

> Inserts a fixed delay between events. You can use this option to slow down the Monkey. If not specified, there is no delay and the events are generated as rapidly as possible.

Based on this, you may assume that it would do an event, wait the given `delay` and then proceed to the next event. This may lead to a naive assumption of the following calculation to work out the test duration:

```
10 events x 100 ms delay = 1000 ms total test time
```

## Issues with calculating test duration

### Event duration

The problem with estimating the duration of the tests is that *events have different execution times*. This make sense, as some events may have to wait until the UI is ready before it can do certain events.

This is outlined the table below, which is the results for a test with 1,000 events and no delay set:

| Event         | Total time | Average time |
|:--------------|-----------:|-------------:|
| Touch         |  1,698 ms  |  1.69 ms     |
| Motion        |  1,034 ms  |  1.03 ms     |
| Trackball     |    541 ms  |  0.54 ms     |
| Nav           |    712 ms  |  0.71 ms     |
| Major Nav     |    783 ms  |  0.78 ms     |
| System Keys   | 45,015 ms  | 45.01 ms     |
| App Switching |  2,644 ms  |  2.64 ms     |
| Any Event     |  2,135 ms  |  2.13 ms     |

### Delay duration

In the documentation regarding delays, it says that it:

> Inserts a fixed delay between events. You can use this option to slow down the Monkey. If not specified, there is no delay and the events are generated as rapidly as possible.

However, after extensive testing it appears that this is not correct. A quick Google shows this comment that Google employee `parentej@google.com` made on a [related issue](https://issuetracker.google.com/issues/36963075):

> Note: 100 events, also includes "ACTION_MOVE" events, but the sleep of 400ms is only after "ACTION_UP", so expect a lot less that 40secs.

This alludes to the fact that **the delay does not apply to all events**, contradicting the official documentation.

I looked into this further by performing and recording the results of these two tests for every event type:
1. 1000 events with no delay
2. 1000 events with 100 ms delay

| Event         | No Delay  | With Delay | Difference |
|:--------------|----------:|-----------:|-----------:|
| Touch         |  1,698 ms |  51,882 ms |  50,184 ms |
| Motion        |  1,034 ms |  17,242 ms |  16,208 ms |
| Trackball     |    541 ms |   1,758 ms |   1,217 ms |
| Nav           |    712 ms |  50,891 ms |  50,179 ms |
| Major Nav     |    783 ms |  50,943 ms |  50,160 ms |
| System Keys   | 45,015 ms |  97,951 ms |  52,936 ms |
| App Switching |  2,644 ms | 116,746 ms | 114,102 ms |
| Any Event     |  2,135 ms |  52,205 ms |  50,070 ms |

These results are *very* interesting. Using our naive estimation, we would assume that the delayed result would be at least:

```
1,000 events x 100ms = 100,000 ms
```

However the average difference is **48,132**. This supports the statement made by `parentej@google.com` that the delay only applies to `ACTION_UP` events. Based on his/her advice, for calculating touch events, you would half the result. This is because only half of the events are `ACTION_UP` events, which have a delay:

```
(1,000 events x 100 ms) / 2 = 50,000 ms
```

## Delayable events

Based on the previous results, we can see that the following events are delayable:
* Touch
* Nav
* Major Nav
* System Keys
* Any Event

The following events do not appear to delay:
* Motion
* Trackball
* App Switching

These results are probably based on which events have a `TOUCH_UP` event.

## Testing delayable events

Retesting with 1000 *delayable events* with/without a 100 ms delay results in the following:

| # Events | No Delay | With Delay | Difference | Expected   |
|---------:|---------:|-----------:|-----------:|-----------:|
| 1,000    | 2,984 ms |  52,354 ms |  49,370 ms |  50,000 ms |
| 2,000    | 4,058 ms | 105,400 ms | 101,342 ms | 100,000 ms |

These results confirm the idea that the delay only applies to `TOUCH_UP` events and other relevant actions within events.

# Conclusion

**By limiting the Monkey to the delayable events, we are able to estimate test execution times within 2%.**

We can now use the following formulae:
```
Time = Events / Delay x 2
e.g. 50,000 ms = (1,000 / 100) x 2

Events = (Time / Delay) x 2
e.g. 1,000 = (50,000 / 100) x 2

Delay = (Time / Events) x 2
e.g. 100 = (50,000 / 1,000) x 2
```
