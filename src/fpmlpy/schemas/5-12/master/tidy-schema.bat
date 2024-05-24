REM do-schema-xml
rem Copyright (c) 2002-2015
REM Generate the XML documentation for the schema files (to be converted to PDF)
echo Do XML version of Schema reference
echo ==================================
REM set up environment variables
call env

cd src\schema
..\..\tidy -wrap 4096  -xml -utf8 < fpml-main-4-0.xsd > fpml-main-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-ird-4-0.xsd > fpml-ird-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-fx-4-0.xsd > fpml-fx-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-eqd-4-0.xsd > fpml-eqd-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-eqs-4-0.xsd > fpml-eqs-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-cd-4-0.xsd > fpml-cd-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-shared-4-0.xsd > fpml-shared-4-0.xml
..\..\tidy -wrap 4096  -xml -utf8 < fpml-enum-4-0.xsd > fpml-enum-4-0.xml
md bak
copy *.xsd bak
del fpml*.xsd
ren fpml-main-4-0.xml fpml-main-4-0.xsd
ren fpml-ird-4-0.xml fpml-ird-4-0.xsd
ren fpml-fx-4-0.xml fpml-fx-4-0.xsd
ren fpml-cd-4-0.xml fpml-cd-4-0.xsd
ren fpml-eqs-4-0.xml fpml-eqs-4-0.xsd
ren fpml-eqd-4-0.xml fpml-eqd-4-0.xsd
ren fpml-shared-4-0.xml fpml-shared-4-0.xsd
ren fpml-enum-4-0.xml fpml-enum-4-0.xsd

cd ..\..
