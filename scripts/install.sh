# This script should be called with 2 parameters:
# 1st parameter: package name e.g. uk.co.jamiecruwys.gratitude
# 2nd parameter: location of APK
PACKAGE=$1
APK=$2

# Uninstall the app on all connected devices
for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do
  echo "*** Clearing data for " + $PACKAGE + " on device: " + $SERIAL;
  adb -s $SERIAL shell pm clear $PACKAGE

  echo "*** Uninstalling " + $PACKAGE + " from the device";
  adb -s $SERIAL uninstall $PACKAGE
done

# Install the app on all connected devices
for SERIAL in $(adb devices | tail -n +2 | cut -sf 1);
do
  echo "*** Installing " + $APK + " on device: " + $SERIAL;
  adb -s $SERIAL install -r $APK
done
