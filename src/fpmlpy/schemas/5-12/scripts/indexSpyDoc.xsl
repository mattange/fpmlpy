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

<!-- To create the frame template -->
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
	<xsl:message>Starting</xsl:message>
	<index>
		<xsl:apply-templates mode="index.image" select=".//img"/>
	</index>
</xsl:template>
<xsl:template match="img" mode="index.image">
	<!--
	<xsl:variable name="component" select="local-name(../../..)"/>
	<xsl:variable name="type" select="local-name(../../../preceding-sibling::*[1])"/>
	-->
	<xsl:variable name="component" select="normalize-space(../../../preceding-sibling::span[1]/text())"/>
	<xsl:variable name="type" select="normalize-space(../../../preceding-sibling::span[2]/text())"/>
	<xsl:variable name="t">
		<xsl:choose>
			<xsl:when test="$type='element'">e:</xsl:when>
			<xsl:when test="$type='group'">mg:</xsl:when>
			<xsl:otherwise>t:</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<entry type="{$type}" name="{$component}" path="{$t}{$component}" id="{@src}" width="{@width}" heigh="{@height}" />
</xsl:template>

</xsl:stylesheet>
