mkdir build\dashel
pushd build\dashel
call cmake -G "MinGW Makefiles" "%WORKSPACE%\source\dashel"
call make
popd

mkdir build\enki
pushd build\enki
call cmake -G "MinGW Makefiles" "%WORKSPACE%\source\enki"
call make
popd

mkdir build\aseba
pushd build\aseba
call cmake -G "MinGW Makefiles"^
 -D "dashel_DIR=%WORKSPACE%\build\dashel"^
 -D "DASHEL_INCLUDE_DIR=%WORKSPACE%\source\dashel"^
 -D "DASHEL_LIBRARY=%WORKSPACE%\build\dashel\libdashel.dll.a"^
 -D "ENKI_INCLUDE_DIR=%WORKSPACE%\source\enki"^
 -D "ENKI_LIBRARY=%WORKSPACE%\build\enki\enki\libenki.a"^
 -D "ENKI_VIEWER_LIBRARY=%WORKSPACE%\build\enki\viewer\libenkiviewer.a"^
 -D "LIBXML2_INCLUDE_DIR=%ASEBA_DEP%\libxml2\include"^
 -D "LIBXML2_LIBRARIES=%ASEBA_DEP%\libxml2\win32\bin.mingw\libxml2.a"^
 -D "QWT_INCLUDE_DIR=%ASEBA_DEP%\qwt\qwt-5.2.1\src"^
 -D "QWT_LIBRARIES=%ASEBA_DEP%\qwt\qwt-5.2.1\lib\libqwt5.a"^
 "%WORKSPACE%\source\aseba"
call make
mkdir strip
for /f %%F in ('dir *.exe /s /b') do (
	call objcopy --strip-all %%F strip\%%~nxF
)
popd

mkdir build\package
pushd build\package
call makensis /Oaseba-package.log "/DASEBA_DEP=%ASEBA_DEP%" -- "%WORKSPACE%\source\package\aseba.nsi"
move "%WORKSPACE%\source\package\*.exe" .
popd
