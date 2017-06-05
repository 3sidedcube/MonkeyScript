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

  # This will produce inconsistent timings. See README.md for more details.
  adb -s $SERIAL shell monkey -p $PACKAGE -v3 --throttle $DELAY --monitor-native-crashes --ignore-crashes $EVENT_COUNT &
done
