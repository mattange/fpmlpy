@echo off
rem Copyright (c) 2002-2015
set CURDIR="%~dp0"

echo Tidying %1 FROM %CURDIR%
cd %CURDIR%%1

del /s /q *.*~ > NUL 2>&1
FOR %%I IN (*.xsd) DO call %CURDIR%tidy-example.bat %%~nI.xsd 

del /q $*.xsd > NUL 2>&1

cd %CURDIR%
