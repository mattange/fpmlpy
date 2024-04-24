@echo off
rem Copyright (c) 2002-2012
REM do-example
REM Generate the XML documentation for the schema files (to be converted to PDF)
REM set up environment variables

rem assumes we are in an examples directory
echo Tidying %1
set TIDY=tidy
if not exist %TIDY%.exe set TIDY=..\%TIDY%
if not exist %TIDY%.exe set TIDY=..\%TIDY%
if not exist %TIDY%.exe set TIDY=..\%TIDY%
if not exist %TIDY%.exe set TIDY=..\%TIDY%
if not exist %TIDY%.exe goto notfound
%TIDY% -wrap 4096  -xml -utf8 < %1 > _%1 2> tidy.log
rem ren %1 $%1
del %1 
ren _%1 %1

goto end

:notfound
echo TIDY not found

:end
