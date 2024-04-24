<?xml version="1.0" encoding="utf-8" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must merge the schema files into one file
 -->


<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format"
	xmlns:view="http://www.fpml.org/views"
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


<!--  version file -->
<xsl:param name="version-file" select="'../src/fpml-version.xml'"/>
<xsl:variable name="version" select="document($version-file)/wrapper"/>

<!-- The main template -->
<xsl:template match="/">
	<xsl:apply-templates mode="check.messages" select="$allComplexTypes"/>
</xsl:template>

<xsl:template mode="check.messages" match="xsd:complexType"/>

<xsl:template mode="check.messages" match="xsd:complexType[xsd:complexContent/xsd:extension]">
	<xsl:variable name="is.msg">
		<xsl:apply-templates mode="is.msg" select="."/>
	</xsl:variable>
	<xsl:if test="$is.msg = 'true'">
		<xsl:apply-templates mode="check.msg.specified" select="."/>
	</xsl:if>
</xsl:template>

<xsl:template mode="is.msg" match="xsd:complexType[@name='Message']" priority="10">true</xsl:template>
<xsl:template mode="is.msg" match="xsd:complexType" priority="-1">false</xsl:template>

<xsl:template mode="is.msg" match="xsd:complexType[xsd:complexContent/xsd:extension]">
	<xsl:variable name="name" select="xsd:complexContent/xsd:extension/@base"/>
	<xsl:variable name="ex" select="$allComplexTypes[@name=$name]"/>
	<xsl:choose>
		<xsl:when test="$ex">
			<xsl:apply-templates mode ="is.msg" select="$ex"/>
		</xsl:when>
		<xsl:otherwise>false</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template mode="check.msg.specified" match="xsd:complexType">
	<xsl:variable name="rule" select="(xsd:annotation/xsd:appinfo/view:messageRule)"/>
	<xsl:choose>
		<xsl:when test="not($rule)">
			<xsl:message>Message rules not specified for <xsl:value-of select="@name"/></xsl:message>
		</xsl:when>

		<xsl:otherwise>
			<xsl:if test="not($rule/@correctable) or not($rule/@cancellable)">
				<xsl:message>Message rules not properly specified for <xsl:value-of select="@name"/></xsl:message>
			</xsl:if>
			<xsl:if test="$rule/@correctable = 'true'">
				<xsl:apply-templates mode="check.correction" select="."/>
			</xsl:if>
			<xsl:if test="$rule/@cancellable = 'true'">
				<xsl:apply-templates mode="check.cancellation" select="."/>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template mode="check.correction" match="xsd:complexType" priority="-1"/>

<xsl:template mode="check.correction" match="xsd:complexType[xsd:annotation/xsd:appinfo/view:messageRule/@correctable='true']">
	<!-- <xsl:message><xsl:value-of select="@name"/> is correctable</xsl:message> -->
	<xsl:variable name="tail" select="substring-after(@name, 'Request')"/>
	<xsl:variable name="wanted" select="concat('Modify',$tail)"/>
	<!-- <xsl:message>Need <xsl:value-of select="$wanted"/></xsl:message> -->
	<xsl:variable name="wanted.msg" select="($allComplexTypes[@name=$wanted])"/>
	<xsl:choose>
		<xsl:when test="$wanted.msg">
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Didn't find <xsl:value-of select="$wanted"/></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template mode="check.cancellation" match="xsd:complexType" priority="-1"/>

<xsl:template mode="check.cancellation" match="xsd:complexType[xsd:annotation/xsd:appinfo/view:messageRule/@cancellable='true']">
	<!-- <xsl:message><xsl:value-of select="@name"/> is correctable</xsl:message> -->
	<xsl:variable name="tail" select="substring-after(@name, 'Request')"/>
	<xsl:variable name="wanted" select="concat('Cancel',$tail)"/>
	<!-- <xsl:message>Need <xsl:value-of select="$wanted"/></xsl:message> -->
	<xsl:variable name="wanted.msg" select="($allComplexTypes[@name=$wanted])"/>
	<xsl:choose>
		<xsl:when test="$wanted.msg">
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Didn't find <xsl:value-of select="$wanted"/></xsl:message>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>

