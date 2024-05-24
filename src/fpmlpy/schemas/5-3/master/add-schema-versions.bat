@echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Jan 2007
rem Copyright (c) 2002-2012
rem
rem Generate a version of the schema files with a version in the file name.
rem
rem Usage:
rem 	add-schema-versions [version] [view]
rem
rem E.g.:
rem 	add-schema-versions 4-3
rem

call env

set VERSION=%1
if "%VERSION%" == "" set VERSION=%TARGET_VER%
set VIEW=%2
set DESTDIR=%XMLDIR%
if NOT "%VIEW%" == "" set DESTDIR=%XMLDIR%\%VIEW%

if EXIST %DESTDIR% goto clean
if not EXIST %XMLDIR% MD %XMLDIR%
MD %DESTDIR%

:clean
del /q %DESTDIR%\*.*

echo Generating example of an extension
call gen-extension-schema-for-view %SOURCE_SCHEMA_DIR% %DESTDIR% example-extension %VERSION% %VIEW%

echo Generating version %VERSION% into %DESTDIR%

FOR %%I IN (%SOURCE_SCHEMA_DIR%\fpml-*.xsd) DO call add-schema-version %SOURCE_SCHEMA_DIR% %DESTDIR% %%~nI %VERSION% %VIEW%

copy %SOURCE_SCHEMA_DIR%\xmldsig-core-schema.xsd %DESTDIR%

call tidy-schemas %DESTDIR%
