@echo off
rem Copyright (c) 2002-2015
REM do-example
REM Generate the XML documentation for the schema files (to be converted to PDF)
REM set up environment variables

rem assumes we are in an examples directory
rem echo Tidying %1
set TIDY=%ROOTDIR%%TIDYEXE%

find  "<style>" %1 > NUL
if %ERRORLEVEL% == 0 goto style
%TIDY% -wrap 4096  -xml -utf8 < %1 > _%1 2> %TIDIOUTPUTLOGFILE%
rem ren %1 $%1
del %1 
ren _%1 %1

goto end


:style
echo style found, skipping
goto end


:notfound
echo TIDY not found

:end
