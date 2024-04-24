<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="2.0" 
	xmlns="http://www.fpml.org/FpML-5/reporting" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:fpml="http://www.fpml.org/FpML-5/master" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:view="http://www.fpml.org/views" 
	xmlns:record="http://www.fpml.org/FpML-5/recordkeeping" 
	xmlns:trans="http://www.fpml.org/FpML-5/transparency" 
	xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="common xsd xsi view"
	>

	<!--
	<xsl:output method="xml" indent="yes"/>
	-->
	<xsl:output method="text" />

	<xsl:param name="record-file" select="'../src/main/recordkeeping-validation.xml'"/>
	<xsl:variable name="recordvals" select="document($record-file)/productValidationSet"/>
	<xsl:param name="trans-file" select="'../src/main/transparency-validation.xml'"/>
	<xsl:variable name="transvals" select="document($trans-file)/productValidationSet"/>

	
        <xsl:template match="/">
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="*" priority="-1">
		<xsl:message>Processing, element is <xsl:value-of select="local-name(.)"/></xsl:message>
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<xsl:template match="node()" priority="-2"/>

	<xsl:template match="record:nonpublicExecutionReport">
		<xsl:message>Validating non-public exec report</xsl:message>
		<xsl:apply-templates select=".//record:trade" mode="validate">
			<xsl:with-param name="rules" select="$recordvals"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="trans:publicExecutionReport">
		<xsl:message>Validating public exec report</xsl:message>
		<xsl:apply-templates select=".//trans:trade" mode="validate">
			<xsl:with-param name="rules" select="$transvals"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="validate" match="*">
		<xsl:param name="rules"/>
		<xsl:message>In validation, has <xsl:value-of select="count($rules/*)"/> rules</xsl:message>
		<xsl:variable name="this" select="."/>
		<xsl:apply-templates select="$rules/*" mode="required">
			<xsl:with-param name="msg" select="$this"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="required" match="field">
		<xsl:param name="msg"/>
		<!--
		<xsl:message>In validation, check <xsl:value-of select="."/> </xsl:message>
		-->
		<xsl:variable name="xpath">
			<xsl:choose>
				<xsl:when test="starts-with(., '//')">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('//',.)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		<xsl:message>xpath is <xsl:value-of select="$xpath"/></xsl:message>
		-->
		<xsl:variable name="result">
			<xsl:apply-templates mode="saxon.evaluate" select="$msg">
				<xsl:with-param name="xpath" select="$xpath"/>
			</xsl:apply-templates>
		</xsl:variable>
		<!--
		<xsl:message>Eval of <xsl:value-of select="$xpath"/> gives <xsl:value-of select="count($result/*)"/></xsl:message>
		-->
		<xsl:if test="string-length($result) = 0">
			<xsl:message> **** Required field [<xsl:value-of select="@label"/>] missing, xpath= <xsl:value-of select="$xpath"/></xsl:message>
		</xsl:if>
		<xsl:if test="string-length($result) &gt; 0">
			<xsl:message> !! Required field [<xsl:value-of select="@label"/>] present, value= <xsl:value-of select="$result[1]"/></xsl:message>
		</xsl:if>
		<xsl:message>
</xsl:message>
	</xsl:template>

	<xsl:template match="node()" mode="saxon.evaluate" >
		<xsl:param name="xpath"/>
		<!--
		<xsl:message>Eval <xsl:value-of select="$xpath"/> </xsl:message>
		-->
		<xsl:value-of select="saxon:evaluate($xpath)"/>
		<!--
		<xsl:message> result is <xsl:value-of select="saxon:evaluate($xpath)"/></xsl:message>
		-->
	</xsl:template>



</xsl:stylesheet>
