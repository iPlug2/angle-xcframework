#!/bin/zsh

cd `dirname $0`

echo "Cleaning up"
rm -rf **/Universal

build_xcframwork()
{
  echo "Building XCFramework for $1"
  mkdir -p Mac/Universal
  cp -a Mac/x64/$1.framework Mac/Universal
  lipo -create Mac/arm64/$1.framework/$1 Mac/x64/$1.framework/$1 -o temp
  mv temp Mac/Universal/$1.framework/Versions/A/$1

  mkdir -p Catalyst/Universal
  cp -a Catalyst/x64/$1.framework Catalyst/Universal
  lipo -create Catalyst/arm64/$1.framework/$1 Catalyst/x64/$1.framework/$1 -o temp
  mv temp Catalyst/Universal/$1.framework/Versions/A/$1

  mkdir -p Simulator/Universal
  cp -a Simulator/x64/$1.framework Simulator/Universal
  lipo -create Simulator/arm64/$1.framework/$1 Simulator/x64/$1.framework/$1 -o temp
  mv temp Simulator/Universal/$1.framework/$1

  mkdir -p VisionOSSimulator/Universal
  cp -a VisionOSSimulator/x64/$1.framework VisionOSSimulator/Universal
  lipo -create VisionOSSimulator/arm64/$1.framework/$1 VisionOSSimulator/x64/$1.framework/$1 -o temp
  mv temp VisionOSSimulator/Universal/$1.framework/$1

  xcodebuild -create-xcframework -framework iOS/arm64/$1.framework -framework VisionOS/arm64/$1.framework -framework VisionOSSimulator/Universal/$1.framework -framework Catalyst/Universal/$1.framework -framework Simulator/Universal/$1.framework -framework Mac/Universal/$1.framework -output $1.xcframework
}

build_xcframwork "libEGL"
build_xcframwork "libGLESv2"
