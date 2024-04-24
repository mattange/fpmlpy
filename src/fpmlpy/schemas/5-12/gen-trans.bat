rem @echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Jan 2006
rem Copyright (c) 2002-2015
rem
rem Generate a version of a schema file with a version in the file name,
rem from one with none.
rem
rem usage:
rem gen-trans [sourcedir] [destdir] [filename] [ver] [view] [bump-level]


set SRC=%1
set DESTDIR=%2
set FN=%3
set VER=%4
set VIEW=%5
call env %VIEW%
if "%VER%" == "" set VER=%TARGET_VER%
set BUMP=%6

set DESTFN=%FN%

echo Generate ver %SRC%\%FN% to %DESTDIR%\%DESTFN%, view=%VIEW%



rem echo %XALAN% -IN %SRC%/%FN%.xml -XSL %SCRIPTDIR%\add-version.xsl -OUT %DESTDIR%\%DESTFN%.xml -PARAM version "%VER%" -PARAM bump.level %BUMP%
rem %XALAN% -IN %SRC%/%FN%.xml -XSL %SCRIPTDIR%\generate-view-examples.xsl -OUT %DESTDIR%\%DESTFN%.xml -PARAM version "%VER%" -PARAM bump.level %BUMP% -PARAM view %VIEW%
rem
rem use saxon 8 to support xslt 2.0, e.g. for *:myelem syntax
%SAXON8%  -o %DESTDIR%\%DESTFN%%XMLEXTENSION% %SRC%/%FN%%XMLEXTENSION% %SCRIPTDIR%\%CONVERTTOTRANSPARENCYFILE% oyear=%ORIGINALYEAR% version="%VER%" bump.level=%BUMP% view=%VIEW% current.date="%DATE%" 

if errorlevel 1 del  %DESTDIR%\%DESTFN%%XMLEXTENSION% 
