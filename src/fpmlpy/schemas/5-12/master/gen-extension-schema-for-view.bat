rem @echo off
rem Author:  Brian Lynn, GEM, for ISDA
rem Nov 2007
rem Copyright (c) 2002-2015
rem
rem Generate a version of a schema file with a version in the file name,
rem from one with none.
rem
rem usage:
rem add-schema-version [sourcedir] [destdir] [filename] [ver] [view]


set SRC=%1
set DESTDIR=%2
set FN=%3
set VER=%4
set VIEW=%5

if "%FN%" == "%XMLDSIGCORESCHEMAFILEWITHOUTXSD%" goto copyfile

echo Generate ver %SRC%\%FN% to %DESTDIR%\%DESTFN%

set VIEW_PARAM=
if not "%VIEW%" == "" set VIEW_PARAM=view=%VIEW%

call env %VIEW%

if "%VER%" == "" set VER=%TARGET_VER%
set DESTFN=%FN%-%VER%

rem %XALAN% -IN %SRC%/%FN%.xsd -XSL %SCRIPTDIR%\add-version.xsl -OUT %DESTDIR%\%DESTFN%.xsd -PARAM version %VER%
rem \j2sdk1.4.2_02\bin\java -jar extern\saxon.jar -o %DESTDIR%\%DESTFN%.xsd %SRC%\%FN%.xsd %SCRIPTDIR%\add-version.xsl version=%VER%

rem must use saxon to copy namespaces

%SAXON8% -o %DESTDIR%\%DESTFN%%XSDEXTENSION% %SRC%\%FN%%XSDEXTENSION% %SCRIPTDIR%\%GENERATEEXTENSIONVIEW% version=%VER% %VIEW_PARAM% current.date="%DATE%"

if errorlevel 1 del  %DESTDIR%\%DESTFN%%XSDEXTENSION% 

goto end
:copyfile
echo Copy %SRC%\%FN%%XSDEXTENSION% to %DESTDIR%\%FN%%XSDEXTENSION%
copy /y %SRC%\%FN%%XSDEXTENSION% %DESTDIR%\%FN%%XSDEXTENSION%

:end


