@echo off
rem Copyright (c) 2002-2015
set CURDIR="%~dp0"

echo Tidying %1 FROM %CURDIR%
cd %CURDIR%%1

del /s *.*~ > NUL 2>&1

FOR %%I IN (*.xml) DO call %CURDIR%tidy-example.bat %%~nI.xml 
del tidy.log > NUL 2>&1

FOR /d %%I IN (*) DO call %CURDIR%tidy-examples.bat %1\%%~nI

cd %CURDIR%
