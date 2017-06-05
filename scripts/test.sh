# This script should be called with 3 parameters:
# 1st parameter: package name e.g. uk.co.jamiecruwys.gratitude
# 2nd parameter: delay between events
# 3rd paramter: number of events to test with
PACKAGE=$1
DELAY=$2
EVENT_COUNT=$3

for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do
  echo "*** Testing [" + $PACKAGE + "] on device [" + $SERIAL + "] with [" + $EVENT_COUNT + "] events, each with a delay of [" + $DELAY + "]ms";

  # See README.md for the reasoning behind using these particular event percentages. TLDR: to make the timing consistent.
  adb -s $SERIAL shell monkey -p $PACKAGE -v3 --pct-touch 34 --pct-motion 0 --pct-pinchzoom 0 --pct-trackball 0 --pct-rotation 0 --pct-nav 33 --pct-majornav 33 --pct-syskeys 0 --pct-appswitch 0 --pct-flip 0 --pct-anyevent 0 --throttle $DELAY --monitor-native-crashes --ignore-crashes $EVENT_COUNT &
done
