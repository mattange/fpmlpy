@echo off
rem Copyright (c) 2002-2012
set CURDIR="%~dp0"

echo TIDY %1 FROM %CURDIR%
cd %CURDIR%%1

del /s /q *.*~
FOR %%I IN (*.xsd) DO call %CURDIR%tidy-example.bat %%~nI.xsd 

del /q $*.xsd

cd %CURDIR%
