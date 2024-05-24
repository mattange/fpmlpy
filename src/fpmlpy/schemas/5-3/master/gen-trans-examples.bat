@echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Jan 2006, updated 2009
rem Copyright (c) 2002-2012
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

call env.bat
if "%VERSION%" == "" set VERSION=%TARGET_VER%

set SRCVIEW=confirmation

set GENGROUP=%1\
if "%GENGROUP%" == "\" set GENGROUP=


:generate

echo Prefix is %GENPREFIX%
set SRC=%SOURCEDIR%\%SRCVIEW%-view-examples\%GENPREFIX%%GENGROUP%
echo SRC1 is %SRC%

rem if NOT "%GENPREFIX%" == "" set SRC=%SOURCEDIR%\%GENPREFIX%examples\%GENGROUP%
echo SRC2 is %SRC%
set BUMP=0
if NOT "%GENPREFIX%" == "" set BUMP=1

if NOT EXIST %SRC% goto notfound
set DEST=xml\transparency\generated-%GENPREFIX%%GENGROUP%

if EXIST %DEST% goto conv
MD %DEST%

:conv
echo Converting examples for [%SRC%] version %VERSION% into %DEST% with bump=%BUMP% and 

FOR %%I IN (%SRC%\*.xml) DO call gen-trans %SRC% %DEST% %%~nI %VERSION% %SRCVIEW% %BUMP%

FOR /d %%I IN (%SRC%\*.*) DO call gen-trans-examples %%~nI 


goto end

:skip
echo Skipping %SRC% in %SRCVIEW%
goto end

:notfound
echo Input %SRC% not found

:end
