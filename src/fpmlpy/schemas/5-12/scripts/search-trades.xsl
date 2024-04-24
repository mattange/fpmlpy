<?xml version="1.0" encoding="utf-8" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must merge the schema files into one file
 -->

 <!-- search for types with element names or types containing "Trade" -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format"
	xmlns:common="http://exslt.org/common"
	exclude-result-prefixes="xsl xsd fmt common">

<xsl:output encoding="UTF-8" indent="yes" method="xml" cdata-section-elements="programlisting"/> <!-- added BAL for formatting -->
<xsl:param name="schema" select="'default value'"/>
<xsl:param name="area" select="'Unknown'"/>
<xsl:param name="date" select="'default value'"/>
<xsl:param name="lang" select="'en'"/>
<xsl:param name="file-suffix" select="'html'"/>	<!-- html or pdf -->


<!-- Create nodesets for the section to be processed -->
<xsl:variable name="subschema" select="/data/file[@name=$schema]"/>
<xsl:variable name="elements" select="$subschema/xsd:schema/xsd:element"/>
<xsl:variable name="complexTypes" select="$subschema/xsd:schema/xsd:complexType"/>
<xsl:variable name="simpleTypes" select="$subschema/xsd:schema/xsd:simpleType"/>

<!-- Create nodesets for all global elements and type definitions -->
<xsl:variable name="allGlobalElements" select="/data/file/xsd:schema/xsd:element"/>
<xsl:variable name="allLocalElements" select="/data/file/xsd:schema/*//xsd:element[@name]"/>
<xsl:variable name="allLocalGroups" select="/data/file/xsd:schema/*//xsd:group"/>
<xsl:variable name="allComplexTypes" select="/data/file/xsd:schema/xsd:complexType"/>
<xsl:variable name="allSimpleTypes" select="/data/file/xsd:schema/xsd:simpleType"/>
<xsl:variable name="allGroups" select="/data/file/xsd:schema/xsd:group"/>

<!-- xref config file -->
<!--
<xsl:param name="config-file" select="'../src/fpml-xref-patterns.xml'"/>
<xsl:variable name="config" select="document($config-file)/xref"/>
-->

<!--  version file -->
<xsl:param name="version-file" select="'../src/fpml-version.xml'"/>
<xsl:variable name="version" select="document($version-file)/wrapper"/>

<!-- The main template -->
<xsl:template match="/">
	<all>
		<xsl:variable name="tradeTypesTF">
			<xsl:apply-templates select="$allComplexTypes" mode="search"/>
		</xsl:variable>
		<xsl:variable name="tradeTypes" select="common:node-set($tradeTypesTF)"/>
		<typesNamedTrade>
			<xsl:for-each select="$tradeTypes/*[contains(@name,'Trade')]">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:for-each>
		</typesNamedTrade>
		<typesContainingTrade>
			<xsl:copy-of select="$tradeTypes[*]"/>
		</typesContainingTrade>
	</all>
</xsl:template>

<xsl:template match="node()" mode="search" priority="-10">
	<xsl:apply-templates mode="search"/>
</xsl:template>

<xsl:template match="xsd:simpleType" mode="search"/>

<xsl:template match="xsd:complexType|xsd:element" mode="search">
	<xsl:variable name="trades">
		<xsl:for-each select=".//xsd:*[starts-with(@name,'trade') or contains(@type, 'Trade') and not(contains(@type, 'Traded'))]">
			<xsl:element name="{local-name(.)}">
				<xsl:copy-of select="@name|@type"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:variable>
	<xsl:if test = "common:node-set($trades)/* or contains(@name, 'trade') or contains(@name,'Trade') and not(contains(@name, 'Traded'))">
		<xsl:element name="{local-name(.)}">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="$trades"/>
		</xsl:element>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

