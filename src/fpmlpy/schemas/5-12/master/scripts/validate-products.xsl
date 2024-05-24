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
	xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="common xsd xsi view"
	>

	<!--
	<xsl:output method="xml" indent="yes"/>
	-->
	<xsl:output method="text" />

	<xsl:param name="validation-file" select="'../src/main/prod-validation.xml'"/>
	<xsl:variable name="validations" select="document($validation-file)/productValidationSet"/>

	
        <xsl:template match="/">
		<xsl:variable name="product" select=".//*[local-name(.) ='productType'][1]"/>
		<xsl:message> validate product [<xsl:value-of select="$product"/>]</xsl:message>
		<xsl:message> validations has <xsl:value-of select="count($validations/product)"/></xsl:message>
		<xsl:variable name="rules" select="$validations/product[code=$product]"/>
		<xsl:message> rules has <xsl:value-of select="count($rules)"/></xsl:message>
		<xsl:choose>
			<xsl:when test="count($rules/*) &gt; 0">
				<xsl:apply-templates select="*" mode="apply-validations">
					<xsl:with-param name="rules" select="$rules"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message> **** validation rules not found for  [<xsl:value-of select="$product"/>]</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<!--
		<xsl:for-each select = "$validations/product">
			<xsl:message> rules for  [<xsl:value-of select="code"/>]</xsl:message>
		</xsl:for-each>
		-->
	</xsl:template>

	<xsl:template match="node()" priority="-1" />

	<xsl:template mode="apply-validations" match="*">
		<xsl:param name="rules"/>
		<xsl:variable name="this" select="."/>
		<xsl:apply-templates select="$rules/required" mode="required">
			<xsl:with-param name="msg" select="$this"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$rules/prohibited" mode="prohibited">
			<xsl:with-param name="msg" select="$this"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="required" match="required">
		<xsl:param name="msg"/>
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
		<xsl:message>xpath is <xsl:value-of select="$xpath"/></xsl:message>
		<xsl:variable name="result">
			<xsl:apply-templates mode="saxon.evaluate" select="$msg">
				<xsl:with-param name="xpath" select="$xpath"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:message>Eval of <xsl:value-of select="$xpath"/> gives <xsl:value-of select="count($result/*)"/></xsl:message>
		<xsl:if test="count($result/*) = 0">
			<xsl:message> **** Required Xpath missing: <xsl:value-of select="$xpath"/></xsl:message>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="prohibited" match="prohibited">
		<xsl:param name="msg"/>
		<xsl:variable name="xpath">
			<xsl:choose>
				<xsl:when test="starts-with(., '//')">
					<xsl:value-of select="concat('//',.)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:apply-templates mode="saxon.evaluate" select="$msg">
				<xsl:with-param name="xpath" select="$xpath"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:message>Eval of <xsl:value-of select="$xpath"/> gives <xsl:value-of select="count($result/*)"/></xsl:message>
		<xsl:if test="count($result/*) &gt; 0">
			<xsl:message> **** Prohibited Xpath present: <xsl:value-of select="$xpath"/></xsl:message>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="saxon.evaluate" >
		<xsl:param name="xpath"/>
		<xsl:message>Eval <xsl:value-of select="$xpath"/> </xsl:message>
		<xsl:value-of select="saxon:evaluate($xpath)"/>
		<xsl:message> gives <xsl:value-of select="saxon:evaluate($xpath)"/></xsl:message>
	</xsl:template>



</xsl:stylesheet>
