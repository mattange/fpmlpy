<?xml version="1.0" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:common="http://exslt.org/common"
	xmlns:view="http://www.fpml.org/views"
	exclude-result-prefixes="common"
	version="2.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="uri" select="document-uri(/)"/>
<xsl:param name="baseDir" select="'xml/confirmation'"/>
<xsl:param name="enumDocUri" select="concat($baseDir,'/','fpml-enum-5-3.xsd')"/>
<xsl:param name="enumDoc" select="document($enumDocUri)"/>
<xsl:param name="enums" select="$enumDoc//xsd:simpleType"/>

<xsl:variable name="allComplexTypes" select="//xsd:complexType"/>
<xsl:variable name="allSimpleTypes" select="//xsd:simpleType"/>
<xsl:variable name="allGlobalElems" select="//xsd:schema/xsd:element"/>
<xsl:variable name="allGroups" select="//xsd:schema/xsd:group"/>
<xsl:variable name="allTypeRefs" select="//xsd:*[@type|@base]"/>
<xsl:variable name="allElemRefs" select="//xsd:element[@ref]"/>
<xsl:variable name="allGroupRefs" select="//xsd:group[@ref]"/>
<xsl:variable name="allElemDefs" select="//xsd:element[@type]"/>


<xsl:template match="/">
	<output>
		<xsl:apply-templates mode="validate-component-usage" select="$allComplexTypes|$allSimpleTypes|$allGroups"/>
	</output>
</xsl:template>

<xsl:template mode="validate-component-usage" match="xsd:complexType|xsd:simpleType">
	<xsl:variable name="name" select="@name"/>
	<xsl:if test="@name and not($allTypeRefs[@type=$name or @base=$name])">
		<xsl:message>Unreferenced type <xsl:value-of select="$name"/></xsl:message>
	</xsl:if>
</xsl:template>

<xsl:template mode="validate-component-usage" match="xsd:group">
	<xsl:variable name="name" select="@name"/>
	<xsl:if test="not($allGroupRefs[@ref=$name])">
		<xsl:message>Unreferenced group <xsl:value-of select="$name"/></xsl:message>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>
