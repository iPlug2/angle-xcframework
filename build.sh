#!/bin/zsh

cd `dirname $0`

check_success()
{
  if [ $? -eq 0 ]; then
    echo "Succeeded"
  else
    echo "Failed"
    exit
  fi
}

echo "Fecthing depot tools"
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
check_success

export PATH=`pwd`/depot_tools:$PATH

mkdir angle
cd angle

echo "Fetching source code"
fetch angle
check_success

echo "Apply Apple ANGLE patch"
git apply ../angle.apple.patch --ignore-whitespace --whitespace=nowarn
check_success

cd build
echo "Apply Apple chromium build patch"
git apply ../../chromium.build.apple.patch --ignore-whitespace --whitespace=nowarn
check_success

cd ..

build_angle()
{
  echo "Building for $1 $2"
  mkdir -p out/$1/$2/
  check_success

  cp ../$1.$2.args.gn out/$1/$2/args.gn
  check_success

  gn gen out/$1/$2/
  check_success

  autoninja -j4 -C out/$1/$2/
  check_success

  if [ "$1" == "Mac" ]; then
    cp ../bundle_in_framework.sh out/$1/$2/
    check_success
    sh out/$1/$2/bundle_in_framework.sh
    check_success
    if [ "$2" == "arm64" ]; then
      MIN_MAC_VERSION=11.0
    else
      MIN_MAC_VERSION=10.15
    fi
    sh ../generate_info_plist.sh `pwd`/../Info.plist `pwd`/out/$1/$2/libEGL.framework/Versions/A/Resources/Info.plist org.chromium.ost.libEGL libEGL $MIN_MAC_VERSION
    sh ../generate_info_plist.sh `pwd`/../Info.plist `pwd`/out/$1/$2/libGLESv2.framework/Versions/A/Resources/Info.plist org.chromium.ost.libGLESv2 libGLESv2 $MIN_MAC_VERSION
  fi
}

complete_framework()
{
  for FRAMEWORK in 'libEGL' 'libGLESv2';
  do
    if [ "$1" == "Mac" ] || [ "$1" == "Catalyst" ]; then
      cp -r ../resources/$FRAMEWORK/Headers out/$1/$2/$FRAMEWORK.framework/Versions/A
      cp -r ../resources/$FRAMEWORK/Modules out/$1/$2/$FRAMEWORK.framework/Versions/A
      cd out/$1/$2/$FRAMEWORK.framework
      ln -s Versions/Current/Headers Headers
      ln -s Versions/Current/Modules Modules
      cd ../../../..
    else
      cp -r ../resources/$FRAMEWORK/Headers out/$1/$2/$FRAMEWORK.framework
      cp -r ../resources/$FRAMEWORK/Modules out/$1/$2/$FRAMEWORK.framework
    fi
  done
}

build_angle $1 $2
complete_framework $1 $2
check_success

tar -czvf $1.$2.tar.gz out/
