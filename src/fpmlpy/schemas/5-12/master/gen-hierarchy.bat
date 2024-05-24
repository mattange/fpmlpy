REM do-schema-xml.bat
rem Copyright (c) 2002-2015
REM Generate the XML documentation for the schema files (to be converted to PDF)
echo Do XML version of Schema reference
echo ==================================
REM set up environment variables
call env

rem call do-merge.bat
@echo on
%SAXON% -o %TEMPDIR%\hierarchy.xml %TEMPDIR%\MERGED.$$$ scripts\gen-hierarchy.xsl 

