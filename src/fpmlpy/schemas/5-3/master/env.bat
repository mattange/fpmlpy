@echo off
rem Author:  Brian Lynn, Gem Soup LLC for ISDA
rem May 2003
rem Copyright (c) 2002-2012
rem
rem Set environment variables for your environment
rem You may need to adjust your java path if you have multiple versions installed

set TARGET_VER=5-3

:setdirs
rem Directories containing jars, sources, etc.
set LIBDIR=extern\fop\lib
set FOPDIR=extern\fop\build
set FOPBASEDIR=extern\fop
set SAXONDIR=extern
set SOURCEDIR=src
set SOURCE_SCHEMA_DIR=%SOURCEDIR%\schema
set SCRIPTDIR=scripts
set HTMLDIR=html
set PDFDIR=pdf
set SCHEMEDIR=coding-scheme
set TEMPDIR=tmp
set XMLDIR=xml
set SCHEMAMERGEDDIR=merged-schema
set SCHEMADOCDIR="c:\Program Files\TIBCOExtensibility\Turbo\schemaDocs"

rem Java
rem you may need to edit the following lines depending on your java version & location
rem Set this to the java version you use
if NOT "%JAVA_HOME%" == "" GOTO gotjavahome

goto error
rem In the following, set JAVA_HOME to the home directory of your java installation
rem (be sure not to put a trailing space on the java home variable value!)
rem set JAVA_HOME=\JRE\1.3.1_07
rem set JAVA_HOME="C:\Sun\AppServer\jdk"
:gotjavahome
set JAVAEXE="%JAVA_HOME%\bin\java"
set JAVA_VER=1.4

:xerces
set XERCESPATH=%LIBDIR%\xercesImpl-2.2.1.jar;%LIBDIR%\xercesSamples.jar;%LIBDIR%\xml-apis.jar

:saxon
rem Saxon
rem we use Saxon for some things because Xalan is having a hard time resolving external entity references
set SAXON=%JAVAEXE% -Xmx400m -jar %SAXONDIR%\saxon.jar 
set SAXON8=%JAVAEXE% -jar %SAXONDIR%\saxon8.jar 
rem echo "JAVAEXE is %JAVAEXE%

:xalan
rem Xalan
rem we use Xalan for things requiring Andrew Jacobs' extension functions, which Saxon doesn't like
set XALANDIR=extern/fop/lib
set XALANPATH=%XALANDIR%/xalan-2.4.1.jar;%XALANDIR%/xml-apis.jar;%XALANDIR%/xercesImpl-2.2.1.jar
rem set XALANPATH=%XALANDIR%\xalan.jar;%XERCESDIR%\xerces.jar

if "%JAVA_VER%" == "1.3" set XALAN=%JAVAEXE% -cp %XALANPATH%;ibmext.jar org.apache.xalan.xslt.Process -DIAG
if "%JAVA_VER%" == "1.4" set XALAN=%JAVAEXE% -Xbootclasspath/p:%XALANPATH%;ibmext.jar -Xms128m -Xmx256m org.apache.xalan.xslt.Process 

rem echo Java Ver: %JAVA_VER%
rem echo Xalan: %XALAN%
rem echo Saxon: %SAXON%

rem FOP

rem Class path for FOP ... FOP, hacked version of Batik, Xalan/Xerces, logging stuff
set FOPCLASSPATH=%FOPBASEDIR%\build\fop.jar;%LIBDIR%\batik-fixed.jar;%LIBDIR%\xalan-2.4.1.jar;%LIBDIR%\xercesImpl-2.2.1.jar;%LIBDIR%\xml-apis.jar;%LIBDIR%\avalon-framework-cvs-20020806.jar;%LIBDIR%\jimi-1.0.jar

rem Max memory to be used by FOP ... adjust if necessary
rem Too little -> lots of garbage collection & may run out; too much -> thrashing
set FOPMAXMEM=-Xmx300m 
rem Initial memory to be used by FOP ... set to largest comfortable amount
rem Too little -> more garbage collection (runs a little slower), too much -> thrashing
set FOPINITMEM=-Xms100m 
rem These values should work for many machines

set FOP=%JAVAEXE% %FOPINITMEM% %FOPMAXMEM% -cp %FOPCLASSPATH% org.apache.fop.apps.Fop -c scripts\fopconfig.xml 

:batik

set BATIK=%JAVAEXE% -Xms100m -Xmx200m -jar %FOPBASEDIR%\batik-rasterizer.jar 

goto :end
:error

echo ERROR: JAVA_HOME not found in your environment, or Java version not known
echo Please, set the JAVA_HOME variable in your environment to match the
echo location of the Java Virtual Machine you want to use.
exit /b 1
:end

rem set LOCALCLASSPATH=

