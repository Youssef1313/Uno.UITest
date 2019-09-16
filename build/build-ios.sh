﻿#!/bin/bash

echo "Lising iOS simulators"
xcrun simctl list devices --json

/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator &

cd $BUILD_SOURCESDIRECTORY

msbuild /r /p:Configuration=Release $BUILD_SOURCESDIRECTORY/src/Sample/Sample.UITests/Sample.UITests.csproj
msbuild /r /p:Configuration=Release "/p:Platform=iPhoneSimulator" $BUILD_SOURCESDIRECTORY/src/Sample/Sample.iOS/Sample.iOS.csproj

cd $BUILD_SOURCESDIRECTORY/build

mono nuget.exe install NUnit.ConsoleRunner -Version 3.10.0

export UNO_UITEST_PLATFORM=iOS
export UNO_UITEST_IOSBUNDLE_PATH=$BUILD_SOURCESDIRECTORY/src/Sample/Sample.iOS/bin/iPhoneSimulator/Release/Sample.app
export UNO_UITEST_SCREENSHOT_PATH=$BUILD_ARTIFACTSTAGINGDIRECTORY/screenshots/ios

mkdir -p $UNO_UITEST_SCREENSHOT_PATH

mono $BUILD_SOURCESDIRECTORY/build/NUnit.ConsoleRunner.3.10.0/tools/nunit3-console.exe --inprocess --agents=1 --workers=1 $BUILD_SOURCESDIRECTORY/src/Sample/Sample.UITests/bin/Release/net47/Sample.UITests.dll > $BUILD_ARTIFACTSTAGINGDIRECTORY/screenshots/ios/nunit-log.txt 2>&1 
