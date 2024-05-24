<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 

	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:gcl	= "http://xml.genericode.org/2004/ns/CodeList/0.2/" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation"

	>
	
<xsl:output method="text" encoding="UTF-8" indent="yes" />

<!-- extract floating-rate-index codelist to tab-delimited flatfile -->

<xsl:variable name = "tab"	select = "'&#x9;'" />
<xsl:variable name = "nl"	select = "'&#xA;'" />

<xsl:template match = "/">
	<xsl:apply-templates select = "gcl:CodeList" />
</xsl:template>
	
<xsl:template match = "gcl:CodeList">
	<xsl:apply-templates select = "ColumnSet" />
	<xsl:apply-templates select = "SimpleCodeList/Row" />
</xsl:template>

<xsl:template match = "ColumnSet">
	<xsl:apply-templates select = "Column" />
	<xsl:value-of select = "$nl" />
</xsl:template>

<xsl:template match = "Column" priority="-1"/>

<xsl:template match = "Column[position() = 1]">
	<xsl:apply-templates select = "ShortName" /><xsl:value-of select = "$tab" />2021?<xsl:value-of select = "$tab" />OIS?<xsl:value-of select = "$tab" />Method<xsl:value-of select = "$tab" />ISO Code
</xsl:template>



<xsl:template match = "Row">
	<xsl:apply-templates select = "Value[1]" />
	<xsl:apply-templates select = "Value[ComplexValue]"/>
	<xsl:value-of select = "$nl" />
</xsl:template>

<xsl:template match = "Value" >
	<xsl:apply-templates select = "SimpleValue" />
	<xsl:value-of select = "$tab" />
</xsl:template>

<xsl:template match = "Value[ComplexValue]" priority="10" >
	<xsl:if test=".//doc:reference[@version='2021']">Yes</xsl:if>
	<xsl:value-of select = "$tab" />
	<xsl:value-of select=".//doc:method |.//doc:calculationMethod"/>
	<xsl:value-of select = "$tab" />
	<xsl:value-of select=".//doc:code/@method "/>
	<xsl:value-of select = "$tab" />
	<xsl:value-of select=".//doc:code/text() "/>
</xsl:template>


</xsl:stylesheet>
