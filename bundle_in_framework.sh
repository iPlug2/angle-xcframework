#!/bin/zsh

cd `dirname $0`

create_framework()
{
  echo "Creating framework for $1"
  cp $1.dylib temp.dylib
  install_name_tool -id "@rpath/$1.framework/Versions/A/$1" temp.dylib
  install_name_tool -change "./$1.dylib" "@rpath/$1.framework/Versions/A/$1" temp.dylib
#  install_name_tool -add_rpath "@executable_path/Frameworks" temp.dylib
#  install_name_tool -add_rpath "@loader_path/Frameworks" temp.dylib
  echo "Cleaning up"
  rm -rf $1.framework/Resources
  rm -rf $1.framework/$1
  rm -rf $1.framework/Versions/Current
  mkdir -p $1.framework/Versions/A/Resources
  mv temp.dylib $1.framework/Versions/A/$1
  cd $1.framework
  ln -s Versions/Current/Resources Resources
  ln -s Versions/Current/$1 $1
  cd Versions
  ln -s A Current
  cd ../..
  echo "Move dsym"
  mv $1.dylib.dSYM $1.dSYM
  mv $1.dSYM/Contents/Resources/DWARF/$1.dylib $1.dSYM/Contents/Resources/DWARF/$1
}

create_framework "libEGL"
create_framework "libGLESv2"
