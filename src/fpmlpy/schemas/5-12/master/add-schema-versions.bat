@echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Jan 2007
rem Copyright (c) 2002-2015
rem
rem Generate a version of the schema files with a version in the file name.
rem
rem Usage:
rem 	add-schema-versions [version] [view]
rem
rem E.g.:
rem 	add-schema-versions 4-3
rem

set VERSION=%1
set VIEW=%2
call env %VIEW%
if "%VERSION%" == "" set VERSION=%TARGET_VER%
echo version: %VERSION% view: %VIEW%



if NOT "%VIEW%" == "" goto genstart
call add-schema-versions %VERSION% %REPORTING%
call add-schema-versions %VERSION% %CONFIRMATION%
call add-schema-versions %VERSION% %TRANSPARENCY%
call add-schema-versions %VERSION% %RECORDKEEPING%
call add-schema-versions %VERSION% %PRETRADE%
call add-schema-versions %VERSION% %LEGAL%

goto end
:genstart
set DESTDIR=%XMLDIR%
if NOT "%VIEW%" == "" set DESTDIR=%XMLDIR%\%VIEW%

if EXIST %DESTDIR% goto clean
if not EXIST %XMLDIR% MD %XMLDIR%
MD %DESTDIR%

:clean
del /q %DESTDIR%\*.*

echo Generating example of an extension
call gen-extension-schema-for-view %SOURCE_SCHEMA_DIR% %DESTDIR% example-extension %VERSION% %VIEW%

echo gen reg reporting extension schema
call gen-rr-extension-schema-for-view %SOURCE_SCHEMA_DIR% %DESTDIR% reg-reporting-example-extension %VERSION% %VIEW%

:genschemas
echo Generating version %VERSION% into %DESTDIR%

FOR %%I IN (%SOURCE_SCHEMA_DIR%\%FPML%-*%XSDEXTENSION%) DO call add-schema-version %SOURCE_SCHEMA_DIR% %DESTDIR% %%~nI %VERSION% %VIEW%

copy %SOURCE_SCHEMA_DIR%\%XMLDSIGCORESCHEMAFILEWITHOUTXSD%%XSDEXTENSION% %DESTDIR%

call tidy-schemas %DESTDIR%

:end
