@echo off
rem Copyright (c) 2002-2012
set CURDIR="%~dp0"

echo TIDY %1 FROM %CURDIR%
cd %CURDIR%%1

del /s *.*~
FOR %%I IN (*.xml) DO call %CURDIR%tidy-example.bat %%~nI.xml 
del tidy.log

FOR /d %%I IN (*) DO call %CURDIR%tidy-examples.bat %1\%%~nI

cd %CURDIR%
