@echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Jan 2006, updated 2009
rem Copyright (c) 2002-2015
rem
rem Generate examples for a specific view
rem
rem Usage:
rem 	generate-trans-examples [prefix]
rem
rem E.g.:
rem 	generate-trans-examples  
rem


echo ***** Generate Trans   %1 

set GENPREFIX=products\

call env transparency
if "%VERSION%" == "" set VERSION=%TARGET_VER%

set SRCVIEW=%TRANSPARENCYSOURCEVIEW%

if "%1" == "%LOAN%" goto skip

set GENGROUP=%1\
if "%GENGROUP%" == "\" set GENGROUP=


:generate

rem echo Prefix is %GENPREFIX%
set SRC=%SOURCEDIR%\%SRCVIEW%%VIEWEXAMPLESDIR%\%GENPREFIX%%GENGROUP%
rem echo SRC1 is %SRC%

rem if NOT "%GENPREFIX%" == "" set SRC=%SOURCEDIR%\%GENPREFIX%examples\%GENGROUP%
rem echo SRC2 is %SRC%
set BUMP=0
if NOT "%GENPREFIX%" == "" set BUMP=1

if NOT EXIST %SRC% goto notfound
set DEST=%XMLDIR%\%TRANSPARENCY%\%GENERATED%-%GENPREFIX%%GENGROUP%

if EXIST %DEST% goto conv
MD %DEST%

:conv
echo Converting examples for [%SRC%] version %VERSION% into %DEST% with bump=%BUMP% and 

FOR %%I IN (%SRC%\*%XMLEXTENSION%) DO call gen-trans %SRC% %DEST% %%~nI %VERSION% %SRCVIEW% %BUMP%

FOR /d %%I IN (%SRC%\*.*) DO call gen-trans-examples %%~nI 


goto end

:skip
echo Skipping %SRC% in %SRCVIEW%
goto end

:notfound
echo Input %SRC% not found

:end
