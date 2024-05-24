@echo off
rem Author:  Brian Lynn, GEM LLC for ISDA
rem May 2003, updated Jan-Aug 2007
rem Copyright (c) 2002-2015
rem Usage:
rem 	copyxml [view] [all|schema|ex]
set VIEW=%1
if "%VIEW%" == "" set VIEW=all
set SCOPE=%2
if "%SCOPE%" == "" set SCOPE=all
call env %VIEW%
if  "%VIEW%" == "%MASTER%" goto end

if /i not "%VIEW%" == "ALL" goto xref
call copyXml %PRETRADE% %2
call copyXml %TRANSPARENCY% %2
call copyXml %RECORDKEEPING% %2
call copyXml %REPORTING% %2
call copyXml %CONFIRMATION% %2
call copyXml %LEGAL% %2
rem call copyXml regreporting %2

goto end

:xref
rem
echo Generate %VIEW% view
echo ======================
echo call env %VIEW%
call env %VIEW%
echo ======================
set TARGET=%XMLDIR%\%VIEW%
echo target is %TARGET%, version is %TARGET_VER%
echo ======================

if not exist %TARGET% md %TARGET%


if /i "%SCOPE%" == "ex" goto ex
del /q %TARGET%\*%XSDEXTENSION% > NUL 2>&1

rem generate schema files from source to xml directory 
set VERSION=%TARGET_VER%
call add-schema-versions %VERSION% %VIEW%

rem call tidy-schemas %XMLDIR%\%VIEW%


:ex
if /i "%SCOPE%" == "%SCHEMA%" goto end
del /s /q %TARGET%\*%XMLEXTENSION% > NUL 2>&1
call generate-view-examples %VERSION% %VIEW%
if "%VIEW%" == "%LEGAL%" goto gen
call tidy-examples %XMLDIR%\%VIEW%

if "%VIEW%" == "%CONFIRMATION%" goto excelConfirmation
goto gen

:excelConfirmation
copy "%SOURCEDIR%\%CONFIRMATION%%VIEWEXAMPLESDIR%\business-processes\execution-advice\Message Sequence Examples%EXCELEXTENSION%" "%XMLDIR%\%CONFIRMATION%\business-processes\execution-advice\Message Sequence Examples%EXCELEXTENSION%"


:gen
if "%VIEW%" == "%TRANSPARENCY%" goto trans
goto nxt
:trans
call gen-trans-examples
call trans-gen-public-disclosure-examples

:nxt

if NOT "%VIEW%" == "%RECORDKEEPING%" goto final

del /q  %XMLDIR%\%RECORDKEEPING%\%NEWEVENTSDIR%\*_%V2%%XMLEXTENSION%

if not exist %SCRIPTTMPDIR% md %SCRIPTTMPDIR%
call rpt-preprocess
call rpt-convert-to-reg-disclosure
call rpt-convert-regreport-to-flat-product

md %TARGET%\%SCRIPTDIR%
del /s /q %TARGET%\%SCRIPTDIR%\*.*
copy %SCRIPTDIR%\%RECORDKEEPING%-*%SCRIPTEXTENSION% %TARGET%\%SCRIPTDIR%
copy %SOURCEDIR%\%RECORDKEEPING%%VIEWEXAMPLESDIR%\%FPMLKEYPRODCUTFILES%%EXCELEXTENSION% %TARGET%\%SCRIPTDIR%\%FPMLKEYPRODCUTFILES%%EXCELEXTENSION%
copy %SOURCEDIR%\%RECORDKEEPING%%VIEWEXAMPLESDIR%\%PRODUCTDATA%%XMLEXTENSION% %TARGET%\%SCRIPTDIR%\%PRODUCTDATA%%XMLEXTENSION%

md %TARGET%\%BATCH%
del /s /q %TARGET%\%BATCH%\*.*
copy %RPT%-*%BATEXTENSION% %TARGET%\%BATCH%
ren %TARGET%\%BATCH%\%RPT%-%ENV%%BATEXTENSION% %ENV%%BATEXTENSION%
copy %GENFLATMESSAGES%%BATEXTENSION% %TARGET%\%BATCH%

md %TARGET%\%EXTERN%
del /s /q %TARGET%\%EXTERN%\*.*
copy %EXTERN%\%SAXON%*%JAREXTENSION% %TARGET%\%EXTERN%
rd /s /q %SCRIPTTMPDIR%
:final

copy %READMEFILE% %TARGET%
copy %FPMLSPP% %TARGET%

call deltildes.bat

rem delete empty folders
for /f "delims=" %%d in ('dir /s /b /ad xml ^| sort /r') do rd "%%d" 2>nul

:end
