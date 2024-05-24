@echo off
rem Author:  Brian Lynn, Gem Soup LLC for ISDA
rem May 2003
rem Copyright (c) 2002-2021
rem
rem Set environment variables for your environment
rem You may need to adjust your java path if you have multiple versions installed
rem
rem usage:
rem env [view]

:setGeneralVersionInformation
rem current version
rem used in: copyXml.bat, do-intro-html-multiple-files.bat, do-intro-html.bat and do-left-menu.bat
set TARGET_VER=5-12
rem current major version of the current version
rem used in: createEntities.bat
set MAJOR_VERSION=5
rem current minor version of the current version
rem used in: createEntities.bat
set MINOR_VERSION=12
rem current status of the current version
rem used in: createEntities.bat
set VERSIONSTATUS=rec
rem version status extended expression of the current version
rem used in: createEntities.bat
set VERSIONSTATUSEXTENDED=Recommendation
rem status revision of the current version
rem used in: createEntities.bat
set STATUSREVISION=1
rem build numer of the current version
rem used in: createEntities.bat
set BUILDNUMBER=4
rem previous version url
rem used in: createEntities.bat
set PREVIOUSVERSIONURL=https://www.fpml.org/spec/fpml-5-12-3-tr-1/
rem base uri to build different uris
rem used in createEntities.bat 
set BASEURI=http://www.fpml.org/spec
rem uri for the license
rem used in createEntities.bat
set LICENSEURI=http://www.fpml.org/the_standard/fpml-public-license/

rem this year refers to the year when the first release of the current major version was published
rem used in createEntities.bat
set ORIGINALYEAR=2021

rem this day refers to when the current build is published
rem used in createEntities.bat
set ORIGINALDATEDAY=20

rem this month refers to when the current build is published
rem used in createEntities.bat
set ORIGINALDATEMONTH=September

rem this month number refers to when the current build is published
rem used in createEntities.bat
set ORIGINALDATEMONTHNUMBER=9

rem this year refers to when the current build is published
rem used in createEntities.bat
set ORIGINALDATEYEAR=2021

:setArchitectureVersionSection

rem current major version of the architecture html documentation
rem used in createEntities.bat
set ARCH_MAJOR_VERSION=3

rem current minor version of the architecture html documentation
rem used in createEntities.bat
set ARCH_MINOR_VERSION=1

rem current version of the architecture html documentation
rem used in createEntities.bat
set ARCH_VERSION=%ARCH_MAJOR_VERSION%-%ARCH_MINOR_VERSION%

rem current version of the architecture html documentation
rem used in createEntities.bat
set ARCH_VERSION_DOT=%ARCH_MAJOR_VERSION%.%ARCH_MINOR_VERSION%

rem current build number of the architecture html documentation
rem used in createEntities.bat
set ARCH_BUILD_NUMBER=5

rem current status revision of the architecture html documentation
rem used in createEntities.bat
set ARCH_STATUSREVISION=1

rem current status of the architecture html documentation
rem used in createEntities.bat
set ARCH_VERSION_STATUS=rec

rem current status of the architecture html documentation
rem used in createEntities.bat
set ARCH_VERSION_STATUS_EXTENDED=Recomendation

rem current version url of the architecture html documentation
rem used in createEntities.bat
set ARCHTHISVERSIONURL=%BASEURI%/fpml-arch-%ARCH_VERSION%-%ARCH_VERSION_STATUS%-%ARCH_BUILD_NUMBER%

rem previous version url of the architecture html documentation
rem used in createEntities.bat
set ARCHPREVIOUSVERSIONURL=https://www.fpml.org/spec/fpml-arch-3-1-tr-4

rem lastest recomendation version url of the architecture html documentation
rem used in createEntities.bat
set ARCHLASTESTRECURI=http://www.fpml.org/spec/fpml-arch-3-1-rec-5

rem this day refers to when the current architecture build is published
rem used in createEntities.bat
set ARCHPUBLICATIONDAY=20

rem this month refers to when the current architecture build is published
rem used in createEntities.bat
set ARCHPUBLICATIONMONTH=February

rem this month number refers to when the current architecture build is published
rem used in createEntities.bat
set ARCHPUBLICATIONMONTHNUMBER=2

rem this year refers to when the current architecture build is published
rem used in createEntities.bat
set ARCHPUBLICATIONYEAR=2020


if NOT "%1" == "" set VIEW=%1

:validation

rem validation folder name
rem used in do-validation-handCoded-repository.bat
set VALIDATIONDIRECTORY=validation
rem merged schemes directory
rem used in do-validation-handCoded-repository.bat
set MERGED_SCHEMES_DIRECTORY=merged-schemes
rem files repository directory
rem used in do-validation-handCoded-repository.bat
set FILESREPOSITORYDIRECTORY=files-repository
rem validation errors repository directory
rem used in do-validation-handCoded-repository.bat
set VALIDATIONERRORSREPOSITORYDIRECTORY=validation_errors_repository
rem pattern used to detect a file open entry
rem used in do-validation-handCoded-repository.bat
set fileOpenPattern="<file"
rem pattern used to detect a file close entry
rem used in do-validation-handCoded-repository.bat
set fileClosePattern="/file"
rem pattern used to detect a validation error entry
rem used in do-validation-handCoded-repository.bat
set validationErrorPattern="validationError"
rem pattern used to detect a syntax error entry
rem used in do-validation-handCoded-repository.bat
set syntaxErrorPattern="syntaxError"
rem name of schemes
rem used in do-validation-handCoded-repository.bat
set SCHEMESNAME=schemes

rem syntax and business error message
rem used in do-validation-handCoded-repository.bat
set SYNTAXANDBUSINESSERRORMESSAGE=[ERROR] Found XSD schema and business errors in report
rem business error message
rem used in do-validation-handCoded-repository.bat
set BUSINESSERRORMESSAGE=[WARNING] Found business errors in report
rem syntax error message
rem used in do-validation-handCoded-repository.bat
set SYNTAXERRORMESSAGE=[ERROR] Found XSD schema errors in report

rem syntax and business final error message
rem used in do-validation-handCoded-repository.bat
set SYNTAXERRORFINALMESSAGE=[FATAL] Generated FpML schemas are not valid and cannot be published.
rem business final error message
rem used in do-validation-handCoded-repository.bat
set WARNERRORFINALMESSAGE=[WARNING] Some FpML samples contain business errors and should be revised.
rem all valid final message
rem used in do-validation-handCoded-repository.bat
set INFOERRORFINALMESSAGE=[INFO] All FpML schemas and samples are valid.

rem Directories containing jars, sources, etc.
:setGenerationdirs
rem folder where external libraries are
rem used in: env.bat
set LIBDIR=extern\fop\lib

rem base folder for fop jar and external libraries
rem used in: env.bat
set FOPBASEDIR=extern\fop

rem folder where saxon jar files are
rem used in: env.bat
set SAXONDIR=extern

rem source folder that contains the master schema, html documentation images, version changes log file, css files for html documentation and xml example files
rem used in: add-schema-version.bat, check-schema.bat, do-all-pdf-confirmations.bat, do-arch-spec.bat, do-commodity-scheme.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-scheme-files.bat, do-scheme-html.bat, do-scheme-html.bat, do-validation-rules.bat, do-xref.bat, env.bat, gen-extension-schema-for-view.bat, gen-rr-extension-schema-for-view.bat, gen-trans-examples.bat, gen-trans.bat, generate-example.bat, generate-examples.bat, makepdf.bat, sort-schemas.bat, strip-schema-version.bat, strip-schema-versions.bat, update-example-version.bat, update-example-versions.bat, validate-products.bat, validate-surveillance-fields.bat and validation\do-scheme-merge.bat
set SOURCEDIR=src

rem source folder that contains the master schema
rem used in: add-schema-versions.bat, env.bat and strip-schema-versions.bat
set SOURCE_SCHEMA_DIR=%SOURCEDIR%\schema

rem source folder that contains the xsl scripts used to generate schemas and examples for every view
rem used in: add-schema-version.bat, check-file-ms.bat, check-schema.bat, check-scheme.bat, do-all.bat, do-arch-spec.bat, do-commodity-scheme.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-schema-merge-xsd.bat, do-scheme-files.bat, do-scheme-html.bat, do-scheme-merge.bat, do-sortcode-xml.bat, do-xref.bat, env.bat, gen-extension-schema-for-view.bat, gen-rr-extension-schema-for-view.bat, gen-trans.bat, generate-example.bat, makepdf.bat, sort-schemas.bat, strip-schema-version.bat, update-example-version.bat, validate-products.bat, validate-surveillance-fields.bat and validation\do-scheme-merge.bat
set SCRIPTDIR=scripts

rem folder where html documentation will be placed
rem used in: call-toolkit.bat, check-all-orphans.bat, clean.bat, copyimages.bat, do-all-pdf-confirmations.bat, do-all.bat, do-arch-spec.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-schemaDocumentation.bat, do-validation-rules.bat, env.bat
set HTMLDIR=html

rem folder where pdf documentation will be placed
rem used in: clean.bat, do-all-pdf-confirmations.bat, env.bat and makepdf.bat 
set PDFDIR=pdf

rem folder where scheme documentation will be placed (from validation)
rem used in: do-scheme-html.bat, do-scheme-merge.bat, env.bat and validation\do-scheme-merge.bat
set SCHEMEDIR=coding-scheme

rem folder used for temporal files
rem used in: check-schema-dangling.bat, clean.bat, do-all.bat, do-intro-html-multiple-files.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-merge.bat, do-schema-merge-xsd.bat, do-xref.bat, env.bat, gen-hierarchy.bat, gen-view-overrides.bat, generate-spy-index.bat, makepdf.bat, merge-master.bat, render-view-overrides.bat, run-msg-check.bat and search.bat
set TEMPDIR=tmp

rem folder where xml files (schema and examples) will be placed
rem used in: add-schema-versions.bat, call-toolkit.bat, check-all-orphans.bat, clean.bat, copyXml.bat, do-schema-merge-xsd.bat, do-schemaDocumentation.bat, do-xref.bat, env.bat, gen-trans-examples.bat, generate-examples.bat and update-example-versions.bat
set XMLDIR=xml

rem folder (%HTMLDIR%\%VIEW%\%SCHEMAREF%) where schemaDocumentation is placed
rem used in: do-schemaDocumentation.bat and env.bat
set SCHEMAREF=schemaRef

rem used to locate root directory indepenendly of the system used
rem used in: tidy-example.bat
set ROOTDIR=%~dp0

rem lib folder used in docflex library
rem used in: do-schemaDocumentation.bat
set LIB=lib


set SAMPLEDIR=%XMLDIR%\recordkeeping\samples
set XPATHDIR=..\%SOURCEDIR%\recordkeeping-view-examples

rem temporal file for scripts
rem used in copyXml.bat
set SCRIPTTMPDIR=intermediate

rem new events examples folder
rem used in copyXml.bat
set NEWEVENTSDIR=new-events

:setGenerationFiles

rem set files involved in generation process
rem used in: do-all.bat
set FPMLCSS=src\fpml.css

rem display style file for html documentation
rem used in: do-all.bat
set DISPLAYCSS=src\display.css

rem htmlDocumentation javastcript file that is copyed to html\view
rem used in: do-all.bat
set JAVASCRIPTHTMLDOCUMENTATION=src\javascript\htmlDocumentation.js

rem readme file where schema and example files disposition are explained
rem used in: copyXml.bat
set READMEFILE=src\Readme.txt

rem this file, that is an altova project file, is copyed to every xml\view folder
rem used in: copyXml.bat
set FPMLSPP=FpML.spp

rem this is the name of the xmldsig file
rem used in: add-schema-version.bat, add-schema-versions.bat, gen-extension-schema-for-view.bat
set XMLDSIGCORESCHEMAFILEWITHOUTXSD=xmldsig-core-schema

rem xsl script used to generate schema
rem used in: gen-extension-schema-for-view.bat
set GENERATEEXTENSIONVIEW=generate-extension-view.xsl

rem xsl script used to add the version to the schema
rem used in: add-schema-version.bat
set ADDVERSIONXSL=add-version.xsl

rem xsl script used to generate xml examples
rem used in: generate-example.bat
set GENERATEVIEWEXAMPLESFILE=generate-view-examples.xsl

rem xsl script used to generate xml examples for transparency view
rem used in: gen-trans.bat
set CONVERTTOTRANSPARENCYFILE=convert-to-transparency.xsl

rem log file for tidy process
rem used in: tidy-example.bat
set TIDIOUTPUTLOGFILE=tidy.log

rem html index generated for every view
rem used in: do-all.bat and do-left-menu-multiple-files.bat
set INDEXHTMLFILE=index.html

rem %VIEW%%XREFXMLFILE% is the name of the file generated in the temporal directory in the xref process
rem used in: do-all.bat, do-left-menu-multiple-files.bat, do-xref.bat and env.bat
set XREFXMLFILE=xref.xml

rem xsl script used to generate the xref file
rem used in: do-xref.bat
set GENXREFXSLFILE=gen-xref.xsl

rem Fpml key product file name
rem used in copyXml.bat
set FPMLKEYPRODCUTFILES=FpML_Key_Product_Fields

rem product data file name
rem used in copyXml.bat
set PRODUCTDATA=ProductData

rem gen flat messages file name
rem used in copyXml.bat
set GENFLATMESSAGES=gen-flat-messages

rem reporting abbreviation
rem used in copyXml.bat
set RPT=rpt

rem env file where all enviroment variables are generated
rem used in copyXml.bat
set ENV=env

rem master schema and keys zip file name
rem used in moveFiles.bat
set MASTERSCHEMAANDKEYS=-master-schema-and-key-gen-scripts

:setGenerationNames

rem fpml name for different usages
rem used in: add-schema-versions.bat, do-all.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-schemaDocumentation.bat and do-xref.bat
set FPML=fpml

rem used to compose folder and file names for examples
rem used in: gen-trans-examples.bat, generate-examples.bat and generate-view-examples.bat
set VIEWEXAMPLESDIR=-view-examples

rem this is the view used by the gen-trans-examples to base the generation of the transparency examples
rem used in: gen-trans-examples.bat
set TRANSPARENCYSOURCEVIEW=confirmation

rem transparency view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all.bat, do-validation-rules.bat, gen-trans-examples.bat and generate-view-examples.bat
set TRANSPARENCY=transparency

rem legal view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all.bat and generate-view-examples.bat
set LEGAL=legal

rem confirmation view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all-pdf-confirmations.bat, do-all.bat, do-intro-html-multiple-files.bat, do-validation-rules.bat, do-xref.bat and generate-view-examples.bat
set CONFIRMATION=confirmation

rem reporting view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all.bat, do-schemaDocumentation.bat, do-validation-rules.bat, do-xref.bat and generate-view-examples.bat
set REPORTING=reporting

rem recordkeeping view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all.bat, do-validation-rules.bat and generate-view-examples.bat
set RECORDKEEPING=recordkeeping

rem loan view name
rem used in: do-all-pdf-confirmations.bat, do-validation-rules.bat and gen-trans-examples.bat
set LOAN=loan

rem pretrade view name
rem used in: add-schema-versions.bat, copyXml.bat, do-all.bat, do-validation-rules.bat and generate-view-examples.bat
set PRETRADE=pretrade

rem part of a composate name used in the generation of the transparency examples
rem used in: gen-trans-examples.bat
set GENERATED=generated

rem name of a scope used in copyXml to do specific parts of the process
rem used in: copyXml.bat and do-xref.bat
set SCHEMA=schema

rem name used in multiple files refering to the master view (the one in the source)
rem used in: copyXml.bat, do-all-pdf-confirmations.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-validation-rules.bat and do-xref.bat
set MASTER=master

rem part of the name of temporal files genered in the do-xref process
rem used in: do-xref.bat
set MERGED=MERGED

rem part of the nam used during the do-schemaDocumentation process
rem used in: do-schemaDocumentation.bat
set MAIN=main

rem name used to iterate throw the views if a script is called withot a view as an argument
rem used in: do-all-pdf-confirmations.bat
set ALLCAPS=ALL

rem name used in the xml recordkeeping examples creation
rem used in copyXml.bat
set V2=v2

rem name of the folder created inside the xml recordkeeping example folder to store batch files
rem used in copyXml.bat
set BATCH=batch

rem folder where external libraries are stored
rem used in copyXml.bat
set EXTERN=extern

rem library name
rem used in copyXml.bat
set SAXON=saxon

:setDocumentationDirs

rem directory where the javavascript files used in the html documentation process are located
rem used in: do-left-menu-multiple-files.bat and do-left-menu.bat
set JAVASCRIPTDIR=src\javascript

rem folder where the html documentation of the validation rules is placed
rem used in: do-validation-rules.bat
set VALIDATIONRULESDIR=validation-rules

rem subfolder where the validation xml and xsl source files are placed (%SOURCEDIR%\%VALIDATION%)
rem used in: do-validation-rules.bat and env.bat
set VALIDATION=validation

rem subfolder containing the xsl validation files (%SOURCEDIR%\%VALIDATION%\%XSLDIR%)
rem used in: do-validation-rules.bat
set XSLDIR=XSL


:setDocumentationFiles

rem part of some target files generated in the html documentation process
rem used in: do-intro-html.bat, do-left-menu-multiple-files.bat and do-left-menu.bat
set INTROHTMLFILE=-intro.html

rem source file used in the html documentation process
rem used in: do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat and do-left-menu.bat
set FPMLMAINXMLFILE=fpml-main.xml

rem xsl script used in the html docuemntation process
rem used in: do-all.bat, do-intro-html-multiple-files.bat and do-intro-html.bat
set DOCUMENTBASEXSLFILE=documentBase.xsl

set DOCUMENTBASEEXTERNALVARIABLESXSLFILE=documentBaseExternalVariables.xsl

rem part of some target files generated in the html documentation process
rem used in: do-intro-html-multiple-files.bat, do-intro-html.bat and do-left-menu-multiple-files.bat
set EXAMPLESHTMLFILE=examples.html

rem source file used in the html documentation process
rem used in: do-intro-html.bat
set EXAMPLESXMLFILE=examples.xml

rem part of the errata file generated in the html documentation process
rem used in: do-intro-html.bat
set ERRATAHTMLFILE=errata.html

rem source file used in the html documentation process (errata subprocess)
rem used in: do-intro-html.bat
set FPMLERRATAXMLFILE=fpml-errata.xml

rem xsl script file used to generate the errata file
rem used in: do-intro-html.bat
set CREATEERRATAXSLFILE=createErrata.xsl

rem partial file name for html documentation process
rem used in: do-left-menu.bat
set PARTIALINTROFRAMEHTMLFILE=intro-frame.html

rem xsl script file used to generate frames in the html documentation process
rem used in: do-left-menu-multiple-files.bat and do-left-menu.bat
set CREATEFRAMEXSLFILE=createFrame.xsl

rem javascript file used to generate HTML Intro frame
rem used in: do-left-menu.bat
set TOCTABFILE1=tocTab1.js

rem javascript file used to generate HTML Examples frame
rem used in: do-left-menu-multiple-files.bat and do-left-menu.bat
set TOCTABFILE2=tocTab2.js

rem javascript file used to generate HTML Index frame
rem used in: do-left-menu-multiple-files.bat
set TOCTABFILE3=tocTab3.js

rem javascript file used to generate HTML Intro frame
rem used in: do-left-menu-multiple-files.bat
set TOCTABFILE1_1=tocTab1_1.js

rem xsl script file used to generate tocTab javascript files
rem used in: do-left-menu-multiple-files.bat and do-left-menu.bat
set CREATETOCTABXSLFILE=createTocTab.xsl

rem html file where the HTML Examples frame is created
rem used in: do-left-menu-multiple-files.bat and do-left-menu.bat
set EXAMPLESFRAMEHTMLFILE=examples-frame.html

rem source file used to generate HTML Examples frame
rem used in: do-intro-html-multiple-files.bat, do-left-menu-multiple-files.bat and do-left-menu.bat
set FPMLEXAMPLESXMLFILE=fpml-examples.xml

rem xsl script used to generate HTML version of intro files
rem used in: do-intro-html-multiple-files.bat
set DOCUMENTBASESPLITFILES=documentBaseSplitFiles.xsl

rem xsl script used to generate tocTab javascript file
rem used in: do-left-menu-multiple-files.bat
set CREATETOCTABMULTIPLEFILESXSLFILE=createTocTabMultipleFiles.xsl

rem part of the file generated in the generate HTML Index frame process
rem used in: do-left-menu-multiple-files.bat
set INDEXFRAMEHTMLFILE=index-frame.html

rem part of the name of the source file used in the generate cross-refs process and generate tocTab file
rem used in: do-all.bat, do-left-menu-multiple-files.bat, do-xref.bat and env.bat
set XREFXMLFILE=xref.xml

rem source file used in validation rules generation process
rem used in: do-validation-rules.bat
set RULESCSSFILE=rules.css

rem html file generated in the validation rules generation process
rem used in: do-validation-rules.bat
set RULESFUNCTIONSHTMLFILE=rules-functions.html

rem source file used to generate validation rules html documentation
rem used in: do-validation-rules.bat
set RULESFUNCTIONXMLFILE=rules-functions.xml

rem xsl script file used to generate validation rules html documentation
rem used in: do-validation-rules.bat
set RULEFUNCTIONSXSLFILE=rule_functions.xsl

rem xsl script file used to generate HTML for confirmation components
rem used in: do-validation-rules.bat
set RULEGROUPEDXSLFILE=rule_grouped.xsl
rem xml file that contains the version
rem used in createEntities.bat
set VERSIONFILE=fpml-version-section.xml

rem xml file that contains the version
rem used in createEntities.bat
set VERSIONFILEARCH=fpml-version-section-arch.xml

rem script used to create the updated entities in src
call createEntities

:setDocumentationNames

rem name used to test if view being generated or documented is MASTER or not
rem used in: do-intro-html.bat and do-xref.bat
set MASTERCAPS=MASTER

rem name of the file that contains the pdf documentation of the examples
rem used in: do-all-pdf-confirmations.bat, do-intro-html-multiple-files.bat and do-intro-html.bat
set CONFIRMATIONS=confirmations

rem part of the name of a file used in the html documentation process
rem used in: do-intro-html-multiple-files.bat
set INTRO=intro

rem asset class name
rem used in: do-all-pdf-confirmations.bat
set CREDITDERIVATIVES=credit-derivatives

rem asset class name
rem used in: do-all-pdf-confirmations.bat
set COMMODITYDERIVATIVES=commodity-derivatives

rem asset class name
rem used in: do-all-pdf-confirmations.bat
set INTERESTRATEDERIVATIVES=interest-rate-derivatives

rem asset class name
rem used in: do-all-pdf-confirmations.bat
set FXDERIVATIVES=fx-derivatives

rem directory used in the pdf confirmations process and part of a file name in the do-validation-rules process
rem used in: do-all-pdf-confirmations.bat and do-validation-rules.bat
set REPO=repo

rem asset class name
rem used in: do-all-pdf-confirmations.bat, do-validation-rules.bat and gen-trans-examples.bat
set LOAN=loan

rem part of the name of the xsl script used to generate the validation rules html documentation process
rem used in: do-validation-rules.bat
set RULESENGLISH=rules-english

rem part of the name of files used in the validation rules html documentation process
rem used in: do-validation-rules.bat
set CREDITDERIVATIVESSHORT=cd

rem asset class name
rem used in: do-validation-rules.bat
set EQD=eqd

rem asset class name
rem used in: do-validation-rules.bat
set FX=fx

rem asset class name
rem used in: do-validation-rules.bat
set IRD=ird

rem used in: do-all-pdf-confirmations.bat and do-validation-rules.bat
set REPO=repo

rem used in: do-validation-rules.bat
set SECLEN=sec-lending

rem used in: do-validation-rules.bat
set REPOSFTR=repo-sftr

rem used in: do-validation-rules.bat
set SECLENSFTR=sec-lending-sftr

rem business process
rem used in: do-validation-rules.bat
set BP=bp

rem type of rules generated in the validation rules html documentation process
rem used in: do-validation-rules.bat
set SHARED=shared

rem type of rules generated in the validation rules html documentation process
rem used in: do-validation-rules.bat
set REF=ref

rem type of rules generated in the validation rules html documentation process
rem used in: do-validation-rules.bat
set MSG=msg

rem type of rules generated in the validation rules html documentation process
rem used in: do-validation-rules.bat
set COL=col

rem type of rules generated in the validation rules html documentation process
rem used in: do-validation-rules.bat
set PR=pr


:setPostGeneration

rem folder where schema-merge is placed
rem used in: do-schema-merge-xsd.bat and moveFiles.bat
set SCHEMAMERGEDDIR=merged-schema

rem folder where schema-merge-annotations is placed
rem used in: moveFiles.bat
set SCHEMAMERGEDDIRANNOTATIONS=merged-schema-annotations

rem folder where documentation files are placed
rem used in moveFiles.bat
set DOCUMENTSFOLDER=documents

rem folder where some images are placed inside the html folder
rem used in moveFiles.bat
set SVG=svg

:setValidation

rem script file to generate a temporal file that groups the schemes from source schemes
rem used in check-Schemes-Master-Schema.bat
set FINDSCHEMEFROMSOURCE=findSchemeFromSource

rem temporalFile that store the fpml-SchemeDefinitions schemes
rem used in check-Schemes-Master-Schema.bat
set SRCSCHEMES=srcSchemes

rem file that stores the schemes present in the master schema but not in the fpml-schemeDefinitions.xml file
rem used in check-Schemes-Master-Schema.bat
set MISSINGSCHEMES=missingSchemes

rem script used to extract the schemes from the master schema that are not present in the fpml-schemeDefinitions.xml file
rem used in check-Schemes-Master-Schema.bat
set CHECKSCHEMES=checkSchemes

rem dummy schema file
rem used in check-Schemes-Master-Schema.bat
set DUMMY=dummy

:setBatFileNames

rem enviroment vairables file
rem used in moveFiles.bat
set ENV=env

rem main batch file
rem used in moveFiles.bat
set DO-ALL=do-all

rem xml files generation file
rem used in moveFiles.bat
set COPYXML=copyXml

rem batch file used to clean unnecessary files
rem used in moveFiles.bat
set DELTIDES=deltildes

rem batch file used to generate the xsd schema files
rem used in moveFiles.bat
set ADD-SCHEMA-VERSION=add-schema-version

rem batch file used to generate the xsd schema files
rem used in moveFiles.bat
set ADD-SCHEMA-VERSIONS=add-schema-versions

rem batch file used to generate extension
rem used in moveFiles.bat
set GEN-EXTENSION-SCHEMA-FOR-VIEW=gen-extension-schema-for-view

rem batch file used to generate xml hierarchy
rem used in moveFiles.bat
set GEN-HIERARCHY=gen-hierarchy

rem batch file used to generate tranparency examples
rem used in moveFiles.bat
set GEN-TRANS=gen-trans

rem batch file used to generate tranparency examples
rem used in moveFiles.bat
set GEN-TRANS-EXAMPLES=gen-trans-examples

rem batch file used to tidy files
rem used in moveFiles.bat
set TIDY=tidy

rem batch file used to tidy files
rem used in moveFiles.bat
set TIDY-EXAMPLE=tidy-example

rem batch file used to tidy files
rem used in moveFiles.bat
set TIDY-EXAMPLES=tidy-examples

rem batch file used to tidy files
rem used in moveFiles.bat
set TIDY-SCHEMA=tidy-schema

rem batch file used to tidy files
rem used in moveFiles.bat
set TIDY-SCHEMAS=tidy-schemas

:setExtension

set XMLEXTENSION=.xml
set XSDEXTENSION=.xsd
set DOLAREXTENSION=.$$$
set JAVASCRIPTEXTENSION=.js
set CSSEXTENSION=.css
set HTMLEXTENSION=.html
set SCRIPTEXTENSION=.xsl
set EXCELEXTENSION=.xls
set BATEXTENSION=.bat
set JAREXTENSION=.jar
set ZIPEXTENSION=.zip
set SPPEXTENSION=.spp
set EXEEXTENSION=.exe

rem Directories containing external libraries path
:setlibs

rem subdirectory of the xmlspy directory
rem used in do-schemaDocumentation.bat
set JAVAAPI=JavaAPI

rem docflex directory
rem used in do-schemaDocumentation.bat
SET DOCFLEX=C:\Software\docflex-xml-1.9.0

rem xmlSpy directory
rem used in do-schemaDocumentation.bat
SET XMLSPY=C:\Program Files\Altova\XMLSpy2013
rem SET XMLSPY=C:\Program Files\Altova\XMLSpy2021

rem doc to pdf converter
rem used in moveFiles.bat
set LIBREOFFICE=C:\Program Files\LibreOffice\program\swriter.exe
rem tidy exe that formats example and schema files
rem used in tidy-example.bat
set TIDYEXE=tidy.exe

rem jar name of the xmlSpy library
rem used in do-schemaDocumentation.bat
set XMLSPYAPIJAR=XMLSpyAPI.jar

rem jar name of the AltovaAutomation library (related to the xmlSpy library)
rem used in do-schemaDocumentation.bat
set ALTOVAAUTOMATIONJAR=AltovaAutomation.jar

rem jar name of the xmlApis library (related to the xmlSpy library)
rem used in do-schemaDocumentation.bat
set XMLAPISJAR=xml-apis.jar

rem jar name of the xerces library (related to the xmlSpy library)
rem used in do-schemaDocumentation.bat
set XERCESIMPLJAR=xercesImpl.jar

rem jar name of the resolver library (related to the xmlSpy library)
rem used in do-schemaDocumentation.bat
set RESOLVERJAR=resolver.jar

rem jar name of the docflex library (related to the xmlSpy library)
rem used in do-schemaDocumentation.bat
set DOCFLEXXMLJAR=docflex-xml.jar

rem version of the xmlSpy
rem used in do-schemaDocumentation.bat
set XMLSPYVERSION=2019

rem docflex main class
rem used in do-schemaDocumentation.bat
set DOCFLEXXMLGENERATORMAINCLASS=com.docflex.xml.Generator

rem xmlSpy main class
rem used in do-schemaDocumentation.bat
set DOCFLEXXMLXMLSPYKITMAINCLASS=com.docflex.xml.xmlspy.SpyKit

rem flag used in the do-schemaDocumentation in the docflex xmlspy call
rem used in do-schemaDocumentation.bat
set XMLSPYWORKAROUNDS=2012

rem template subdirectory in the docflex folder
rem used in do-schemaDocumentation.bat
set TEMPLATESDIR=templates

rem xsddoc subdirectory in the docflex folder
rem used in do-schemaDocumentation.bat
set XSDDOCDIR=XSDDoc

rem template used in the schema documentation process
rem used in do-schemaDocumentation.bat
set FRAMEDDOCTPLFILE=FramedDoc.tpl

rem directory where schemaDocumentation is generated
rem used in do-schemaDocumentation.bat
set SCHEMADOCUMENTATION=schemaDocumentation

rem saxon jar location
rem used in do-validation-rules.bat
set EXTERNSAXONJAR=extern\saxon.jar

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

rem used in env.bat
set JAVAEXE="%JAVA_HOME%\bin\java"
rem used in env.bat
set JAVA_VER=1.4

:xerces

rem used in check-dir.bat, check-master-dir.bat and dtcfile.bat
set XERCESPATH=%LIBDIR%\xercesImpl-2.11.0.jar;%LIBDIR%\xercesSamples.jar;%LIBDIR%\xml-apis.jar

:saxon
rem Saxon
rem we use Saxon for some things because Xalan is having a hard time resolving external entity references
rem used in check-file-ms.bat, check-scheme.bat, do-all.bat, do-arch-spec.bat, do-commodity-scheme.bat, do-intro-html-multiple-files.bat, do-intro-html.bat, do-left-menu-multiple-files.bat, do-left-menu.bat, do-scheme-files.bat, do-scheme-html.bat, do-scheme-merge.bat, do-sortcode-xml.bat, do-xref.bat, env.bat, gen-extension-schema-for-view.bat, gen-hierarchy.bat, gen-rr-extension-schema-for-view.bat, generate-spy-index.bat, makepdf.bat, run-msg-check.bat, search.bat, sort-schemas.bat, strip-schema-version.bat, update-example-version.bat, validate-products.bat, validate-surveillance-fields.bat and validation\do-scheme-merge.bat
set SAXON=%JAVAEXE% -Xmx400m -jar %SAXONDIR%\saxon.jar
rem used in add-schema-version.bat, check-schema-dangling.bat, gen-trans.bat, gen-view-overrides.bat, generate-example.bat and render-view-overrides.bat
set SAXON8=%JAVAEXE% -jar %SAXONDIR%\saxon8.jar
rem used in do-sortcode-xml.bat
set SAXON8OLD=%JAVAEXE% -jar %SAXONDIR%\saxon8old.jar 
rem echo "JAVAEXE is %JAVAEXE%

:xalan
rem Xalan
rem we use Xalan for things requiring Andrew Jacobs' extension functions, which Saxon doesn't like
rem used in env.bat
set XALANDIR=extern/fop/lib
rem used in env.bat
set XALANPATH=%XALANDIR%/xalan-2.4.1.jar;%XALANDIR%/xml-apis.jar;%XALANDIR%/xercesImpl-2.11.0.jar
rem set XALANPATH=%XALANDIR%\xalan.jar;%XERCESDIR%\xerces.jar

rem used in add-schema-version.bat, check-file-ms.bat, check-schema.bat, check-scheme.bat, do-schema-merge-xsd.bat, do-sortcode-xml.bat, env.bat, gen-extension-schema-for-view.bat, gen-rr-extension-schema-for-view.bat, gen-trans.bat, generate-example.bat, strip-schema-version.bat and update-example-version.bat
if "%JAVA_VER%" == "1.3" set XALAN=%JAVAEXE% -cp %XALANPATH%;ibmext.jar org.apache.xalan.xslt.Process -DIAG
if "%JAVA_VER%" == "1.4" set XALAN=%JAVAEXE% -Xbootclasspath/p:%XALANPATH%;ibmext.jar -Xms128m -Xmx256m org.apache.xalan.xslt.Process 

rem echo Java Ver: %JAVA_VER%
rem echo Xalan: %XALAN%
rem echo Saxon: %SAXON%

rem FOP

rem Class path for FOP ... FOP, hacked version of Batik, Xalan/Xerces, logging stuff
rem used in env.bat
set FOPCLASSPATH=%FOPBASEDIR%\build\fop.jar;%LIBDIR%\batik-fixed.jar;%LIBDIR%\xalan-2.4.1.jar;%LIBDIR%\xercesImpl-2.11.0.jar;%LIBDIR%\xml-apis.jar;%LIBDIR%\avalon-framework-cvs-20020806.jar;%LIBDIR%\jimi-1.0.jar

rem Max memory to be used by FOP ... adjust if necessary
rem Too little -> lots of garbage collection & may run out; too much -> thrashing
rem used in env.bat
set FOPMAXMEM=-Xmx300m 
rem Initial memory to be used by FOP ... set to largest comfortable amount
rem Too little -> more garbage collection (runs a little slower), too much -> thrashing
rem used in env.bat
set FOPINITMEM=-Xms100m 
rem These values should work for many machines
rem used in pdf.bat
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

