@echo off
rem Author: Brian Lynn, GEM LLC, for ISDA, 
rem Modified by Marc Gratacos, ISDA
rem Modified by Irina Yermakova, ISDA
rem Created:  March., 2003.
rem Mofidified: March 2004.
rem Last Time Mofidified: January 2008.
rem Copyright (c) 2002-2012, ISDA
rem
rem Generate Documentation for FpML spec 
rem Usage:
rem 	do-all [all|master|<view>|intro]  [intro|xref|schema|misc|nocopy]
rem
set GENVIEW=%1
set GENTYPE=%2
if "%GENVIEW%" == "" set GENVIEW=all
if /i "%GENVIEW%" == "intro" set GENTYPE=intro
if /i "%GENVIEW%" == "intro" set GENVIEW=all
if /i "%GENVIEW%" == "xref" set GENTYPE=xref
if /i "%GENVIEW%" == "xref" set GENVIEW=all
if /i "%GENVIEW%" == "schema" set GENTYPE=schema
if /i "%GENVIEW%" == "schema" set GENVIEW=all
if /i "%GENVIEW%" == "misc" set GENTYPE=misc
if /i "%GENVIEW%" == "misc" set GENVIEW=all
if /i "%GENVIEW%" == "nocopy" set GENTYPE=nocopy
if /i "%GENVIEW%" == "nocopy" set GENVIEW=all

if "%GENTYPE%" == "" set GENTYPE=all
if /i not "%GENVIEW%" == "ALL"  goto gen
rem if exist html del /s /q html\*.*
if exist html rd /s /q html
md html
rem if exist tmp del /s /q tmp\*.*
if exist tmp rd /s /q tmp
md tmp

call do-all reporting  %GENTYPE%
call do-all confirmation %GENTYPE%
call do-all transparency %GENTYPE%
call do-all recordkeeping %GENTYPE%
rem **** The generation of Master or Pre-trade schemas have been disabled as they are not currently being distributed. 
rem **** You can re-enable the following commands if  you need to generate your own extensions based on these views.
rem call do-all master
rem call do-all pretrade

goto end

:gen
echo Generate FpML spec for %GENVIEW%
echo ==============================
echo .
del /s *.*~
if not exist html\%GENVIEW% md html\%GENVIEW%

if /i "%GENTYPE%" == "intro" goto intro
if /i "%GENTYPE%" == "xref" goto xref
if /i "%GENTYPE%" == "schema" goto schema
if /i "%GENTYPE%" == "misc" goto misc
if /i "%GENTYPE%" == "nocopy" goto xref

rem copy SVG files from Turbo XML directory 
rem DISABLED (switch to oXygen documentation) call fetch-svg %GENVIEW%
rem copy examples and schema files
echo  --------------------------------------------------------------------
echo Generating schemas and examples for %GENVIEW%
echo ---------------------
call copyXml %GENVIEW%

if /i "%GENTYPE%" == "nocopy" goto xref
if /i not "%GENTYPE%" == "ALL"  goto end

:xref
rem Generate cross-refs
echo ---------------------
echo Generating cross-refs for %GENVIEW%
echo ---------------------
call do-xref %GENVIEW%
set FILE=%HTMLDIR%\%GENVIEW%\fpml-%TARGET_VER%-index.html
if exist %FILE% del %FILE%
%SAXON% -o %FILE% %TEMPDIR%\%GENVIEW%_xref.xml %SCRIPTDIR%\documentBase.xsl date="%DATE%" time="%TIME%" view="%VIEW%"

if /i "%GENTYPE%" == "nocopy" goto intro
if /i not "%GENTYPE%" == "ALL"  goto end

:intro

rem Generate HTML intro sections (copies images, too)
echo  --------------------------------------------------------------------
echo Generating intros for %GENVIEW%
echo ---------------------
copy src\fpml.css html\%GENVIEW%
rem file added for future use html documentation css
copy src\display.css html\%GENVIEW%
rem file added for future use html documentation js for collapsiable sections and toggle views
copy src\javascript\htmlDocumentation.js html\%GENVIEW%
call do-intro-html.bat %GENVIEW%
rem Generate Menu for Navigation
echo  --------------------------------------------------------------------
call do-left-menu.bat %GENVIEW%
rem Generate HTML intro sections but broken into multiple files
echo  --------------------------------------------------------------------
call do-intro-html-multiple-files.bat %GENVIEW%
rem Generate Menu for Navigation (multiple files) 
echo  --------------------------------------------------------------------
call do-left-menu-multiple-files.bat %GENVIEW%
rem Generate Schema Reference Documentation
rem echo  --------------------------------------------------------------------
rem echo Generating schema documentation for %GENVIEW%
rem DISABLED (switch to oXygen documentation) call generate-all-schema-doc HTML %GENVIEW%

if /i "%GENTYPE%" == "nocopy" goto schema
if /i not "%GENTYPE%" == "ALL"  goto end
:schema
echo  --------------------------------------------------------------------
echo Generate schema documentation using XMLSpy  for %GENVIEW%
call do-schemaDocumentation.bat %GENVIEW%
echo  --------------------------------------------------------------------
if /i "%GENTYPE%" == "nocopy" goto misc
if /i not "%GENTYPE%" == "ALL"  goto end
:misc
echo  --------------------------------------------------------------------
rem Generate pdf paper confirmations for confirmation view only
echo Generate pdf-confirmations for confirmation only
call do-all-pdf-confirmations.bat %GENVIEW%
rem echo  --------------------------------------------------------------------
rem Generate individual files for coding Schemes
rem echo Generating coding scheme documentation for %GENVIEW%
rem call do-scheme-files.bat %GENVIEW%
echo  --------------------------------------------------------------------
rem Generate individual HTML files for validation rules
echo Generating validation rules documentation for %GENVIEW%
call do-validation-rules.bat %GENVIEW%
echo  --------------------------------------------------------------------
rem Merge subschemas into one master schema.
rem echo Generating merged schema for %GENVIEW%
rem call do-schema-merge-xsd.bat %GENVIEW%
rem echo  --------------------------------------------------------------------

:end

