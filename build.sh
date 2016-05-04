#!/bin/sh
echo QT PATH is ${QTDIR:='/mingw32'}
echo QWT PATH is ${QWTDIR:='/mingw32'}
echo ASEBA DEP is ${ASEBA_DEP:='/mingw32/bin'}
set -eu

mkdir -p "$WORKSPACE/build/dashel"
cd "$WORKSPACE/build/dashel"
cmake\
 -G "Unix Makefiles" \
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "BUILD_SHARED_LIBS=OFF"\
 "$WORKSPACE/dashel"
make

mkdir -p "$WORKSPACE/build/enki"
cd "$WORKSPACE/build/enki"
cmake\
 -G "Unix Makefiles" \
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "BUILD_SHARED_LIBS=OFF"\
 "$WORKSPACE/enki"
make

mkdir -p "$WORKSPACE/build/aseba"
cd "$WORKSPACE/build/aseba"
cmake\
 -G "Unix Makefiles" \
 -D "CMAKE_BUILD_TYPE=Release"\
 -D "dashel_DIR=$WORKSPACE/build/dashel"\
 -D "DASHEL_INCLUDE_DIR=$WORKSPACE/dashel"\
 -D "DASHEL_LIBRARY=$WORKSPACE/build/dashel/libdashel.a"\
 -D "ENKI_INCLUDE_DIR=$WORKSPACE/enki"\
 -D "ENKI_LIBRARY=$WORKSPACE/build/enki/enki/libenki.a"\
 -D "ENKI_VIEWER_LIBRARY=$WORKSPACE/build/enki/viewer/libenkiviewer.a"\
 -D "QWT_INCLUDE_DIR=$QWTDIR/include/qwt"\
 -D "QWT_LIBRARIES=$QWTDIR/lib/libqwt.a"\
 "$WORKSPACE/aseba"
make
mkdir -p strip
rm -rf strip/*
for f in *.exe; do
    objcopy.exe --strip-all "$f" strip/"$f"
done
rm -f *.exe

mkdir -p "$WORKSPACE/build/packager"
cd "$WORKSPACE/build/packager"
makensis \
    -D"ASEBA_DEP=$ASEBA_DEP" \
    -D"QTDIR=$QTDIR" \
    -- "$WORKSPACE/package/aseba.nsi"

cd "$WORKSPACE"
mv "$WORKSPACE/package/*.exe" .
env
