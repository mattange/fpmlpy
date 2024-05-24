<?xml version="1.0" encoding="iso-8859-1" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must use XML Turbo to generate the schemaDoc images and run
	the 'fetch-svg.bat' file to copy them to the svg directory
 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:drw="xalan://com.ibm.fpml.xslt.Diagram"
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format"
	exclude-result-prefixes="xsl xsd drw fmt">

<xsl:import href="utils.xsl"/>
<xsl:param name="tocTabFile" select="'default value'"/>
<xsl:param name="view" select="'master'"/>
<!-- To create the frame template -->
<xsl:output method="html" indent="yes"/>
<xsl:template match="documentBase">
	<xsl:message>Create frame, view=<xsl:value-of select="$view"/>, tocTabFile=<xsl:value-of select="$tocTabFile"/></xsl:message>
	<html>
		<head>
			<title>
				<xsl:value-of select="titleArch"/>
				<xsl:value-of select="title"/>
				<xsl:if test="not(string-length(title) = 0)"> 
					<xsl:call-template name="view.label"/>
				</xsl:if>
			</title>
			<script language="JavaScript" src="{$tocTabFile}"></script>
			<script language="JavaScript" src="tocParas.js"></script>
			<script language="JavaScript" src="displayToc.js"></script>
		</head>
		<frameset cols="200,*" border="0" onload="reDisplay('Top',true)">
			<frame src="blank.htm" name="toc"/>
			<frame src="blank.htm" name="content"/>
		</frameset>
	</html>
	<xsl:message>Done creating frame</xsl:message>
</xsl:template>

</xsl:stylesheet>
