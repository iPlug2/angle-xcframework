#!/bin/zsh

cd `dirname $0`

# Get the Xcode version number from the command line output
XCODE_VERSION=$(echo `xcodebuild -version` | awk '{print $2}')

# Split the version number into major, minor and patch parts
major=$(echo "${XCODE_VERSION}" | cut -d '.' -f 1)
minor=$(echo "${XCODE_VERSION}" | cut -d '.' -f 2)
patch=$(echo "${XCODE_VERSION}" | cut -d '.' -f 3)

# Add leading zeros if necessary
if [[ ${#major} -eq 1 ]]; then
    major="0${major}"
fi

# Add leading zeros if necessary
if [[ ${#patch} -eq 0 ]]; then
    patch="0"
fi

# Combine the major, minor and patch parts and remove the decimal points
XCODE_VERSION="${major}${minor}${patch}"

cp $1 $2

plutil -insert DTPlatformVersion -string `xcrun -sdk macosx --show-sdk-version` $2
plutil -insert DTPlatformBuild -string `xcrun -sdk macosx --show-sdk-build-version` $2
plutil -insert DTSDKBuild -string `xcrun -sdk macosx --show-sdk-build-version` $2
plutil -insert DTSDKName -string "macosx`xcrun -sdk macosx --show-sdk-version`" $2
plutil -insert DTXcodeBuild -string `xcodebuild -version | grep -o 'Build version [^ ]*' | cut -d ' ' -f3` $2
plutil -insert DTXcode -string "$XCODE_VERSION" $2
plutil -insert BuildMachineOSBuild -string `sw_vers -buildVersion` $2
plutil -insert CFBundleIdentifier -string $3 $2
plutil -insert CFBundleExecutable -string $4 $2
plutil -insert MinimumOSVersion -string $5 $2
