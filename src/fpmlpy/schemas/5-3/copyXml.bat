rem @echo off
rem Author:  Brian Lynn, GEM LLC for ISDA
rem May 2003, updated Jan-Aug 2007
rem Copyright (c) 2002-2012
rem Usage:
rem 	copyxml [view] [all|schema|ex]
set VIEW=%1
if "%VIEW%" == "" set VIEW=all
set SCOPE=%2
if "%SCOPE%" == "" set SCOPE=all

if  "%VIEW%" == "master" goto end

if /i not "%VIEW%" == "ALL" goto xref
call copyXml pretrade %2
call copyXml transparency %2
call copyXml recordkeeping %2
call copyXml reporting %2
call copyXml confirmation %2

goto end

:xref
rem
echo Generate %VIEW% view
echo ======================
call env
set TARGET=%XMLDIR%\%VIEW%

if not exist %TARGET% md %TARGET%


if /i "%SCOPE%" == "ex" goto ex
del /q %TARGET%\*.xsd

rem generate schema files from source to xml directory 
set VERSION=%TARGET_VER%
call add-schema-versions %VERSION% %VIEW%
call tidy-schemas xml\%VIEW%

:ex
if /i "%SCOPE%" == "schema" goto end
del /s /q %TARGET%\*.xml
call generate-view-examples %VERSION% %VIEW%
call tidy-examples xml\%VIEW%
if "%VIEW%" == "transparency" call gen-trans-examples

rem call update-all-example-versions

copy src\Readme.txt %TARGET%
copy FpML.spp %TARGET%

call deltildes.bat

:end
