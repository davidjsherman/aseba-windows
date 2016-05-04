#!/bin/sh
echo QT PATH is ${QTDIR:='/mingw32'}
echo QWT PATH is ${QWTDIR:='/mingw32'}
echo ASEBA DEP is ${ASEBA_DEP:='/mingw32/bin'}
set -eu

[ -d "$WORKSPACE/source" -o -L "$WORKSPACE/source" ] || ln -s . "$WORKSPACE/source"

mkdir -p "$WORKSPACE/build/dashel"
cd "$WORKSPACE/build/dashel"
cmake\
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "BUILD_SHARED_LIBS=OFF"\
 "$WORKSPACE/source/dashel"
make

mkdir -p "$WORKSPACE/build/enki"
cd "$WORKSPACE/build/enki"
cmake\
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "BUILD_SHARED_LIBS=OFF"\
 "$WORKSPACE/source/enki"
make

mkdir -p "$WORKSPACE/build/aseba"
cd "$WORKSPACE/build/aseba"
cmake\
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "dashel_DIR=$WORKSPACE/build/dashel"\
 -D "DASHEL_INCLUDE_DIR=$WORKSPACE/source/dashel"\
 -D "DASHEL_LIBRARY=$WORKSPACE/build/dashel/libdashel.dylib"\
 -D "ENKI_INCLUDE_DIR=$WORKSPACE/source/enki"\
 -D "ENKI_LIBRARY=$WORKSPACE/build/enki/enki/libenki.a"\
 -D "ENKI_VIEWER_LIBRARY=$WORKSPACE/build/enki/viewer/libenkiviewer.a"\
 -D "QWT_INCLUDE_DIR=$QWTDIR/include/qwt"\
 -D "QWT_LIBRARIES=$QWTDIR/lib/libqwt.a"\
 "$WORKSPACE/source/aseba"
make

mkdir -p "$WORKSPACE/build/packager"
cd "$WORKSPACE/build/packager"
makensis \
    -D"ASEBA_DEP=$ASEBA_DEP" \
    -D"QTDIR=$QTDIR" \
    -- "$WORKSPACE/source/package/aseba.nsi"

cd "$WORKSPACE"
mv "$WORKSPACE/source/package/*.exe" .
env

