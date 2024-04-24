<?xml version="1.0" encoding="utf-8" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must merge the schema files into one file
 -->


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
<xsl:param name="maver" select="'maver'"/>
<xsl:param name="miver" select="'miver'"/>

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
<xsl:param name="config-file" select="'../src/fpml-xref-patterns.xml'"/>
<xsl:variable name="config" select="document($config-file)/xref"/>

<!--  version file -->
<xsl:param name="version-file" select="'../src/fpml-version.xml'"/>
<xsl:variable name="version" select="document($version-file)/wrapper"/>

<!-- The main template -->
<xsl:template match="/">
	<documentBase>
		<title>FpML <xsl:value-of select="$maver"/>.<xsl:value-of select="$miver"/>  - Indexes and Cross References</title>
		<xsl:copy-of select="$version/version"/>
		<xsl:apply-templates select="$config/*" mode="xref"/>
	</documentBase>
</xsl:template>

<xsl:template match="section" mode="xref">
	<section>
		<xsl:copy-of select="@*"/>
		<section name="{@name} - Global Elements">
			<xsl:call-template name="report-xref">
				<xsl:with-param name="patterns" select="*"/>
				<xsl:with-param name="source" select="$allGlobalElements"/>
			</xsl:call-template>
		</section>
		<section name="{@name} - Local Elements">
			<xsl:call-template name="report-xref">
				<xsl:with-param name="patterns" select="*"/>
				<xsl:with-param name="source" select="$allLocalElements"/>
			</xsl:call-template>
		</section>
		<section name="{@name} - Complex Types">
			<xsl:call-template name="report-xref">
				<xsl:with-param name="patterns" select="*"/>
				<xsl:with-param name="source" select="$allComplexTypes"/>
			</xsl:call-template>
		</section>
	</section>
</xsl:template>

<xsl:template name="report-xref">
	<xsl:param name="patterns"/>
	<xsl:param name="source"/>

	<xsl:variable name="resultsTF">
		<xsl:call-template name="merge-results">
			<xsl:with-param name="patterns" select="$patterns"/>
			<xsl:with-param name="source" select="$source"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="results" select="common:node-set($resultsTF)"/>
	
	<xsl:if test="count($results/*) &gt; 0">
<table>
	<tc column-width="7.5cm" />
	<tc column-width="7cm" />
	<tc column-width="4cm" />
<tr>
	<td>Component</td>
	<td>Contained In</td>
	<td>File</td>
</tr>
			<xsl:copy-of select="$results"/>
</table>
	</xsl:if>
	<xsl:if test="count($results/*) = 0">
		<paragraph>No components</paragraph>
	</xsl:if>
</xsl:template>

<xsl:template name="merge-results">
	<xsl:param name="patterns"/>
	<xsl:param name="source"/>
	<xsl:variable name="first" select="$patterns[1]"/>
	<xsl:variable name="rest" select="$patterns[position() &gt; 1]"/>
	<xsl:variable name="firstres">
		<xsl:apply-templates select="$first" mode="match-pattern">
			<xsl:with-param name="source" select="$source"/>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:choose>
		<xsl:when test="$rest">
			<xsl:variable name="restres">
				<xsl:call-template name="merge-results">
					<xsl:with-param name="patterns" select="$rest"/>
					<xsl:with-param name="source" select="$source"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="res" select="common:node-set($firstres)/* | common:node-set($restres)/*[not(val=$firstres/val)]"/>
			<xsl:for-each select="$res">
				<xsl:sort select="@name"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<!-- <xsl:copy-of select="$firstres"/> -->
			<xsl:for-each select="common:node-set($firstres)/*">
				<xsl:sort select="@name"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="attrib" mode="match-pattern">
	<xsl:param name="source"/>
	<xsl:variable name="pat" select="."/>
	<xsl:apply-templates 
		mode="record-node"
		select="$source[xsd:attribute/@name=$pat 
			or ./*/xsd:extension/xsd:attribute/@name=$pat
			or ./*/xsd:restriction/xsd:attribute/@name=$pat]" />
</xsl:template>

<xsl:template match="contains" mode="match-pattern">
	<xsl:param name="source"/>
	<xsl:variable name="pat" select="."/>
	<xsl:message>Matching pattern <xsl:value-of select="$pat"/></xsl:message>
	<!--
	<xsl:message>searching among <xsl:value-of select="count($source)"/> components</xsl:message>
	-->
	<xsl:for-each select="$source">
		<xsl:variable name="lcname"
			select="translate(@name,
				'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
				'abcdefghijklmnopqrstuvwxyz')"/>
		<!--
		<xsl:message><xsl:value-of select="concat(@name,' lc to ',$lcname)"/></xsl:message>
		-->
		<xsl:if test="contains($lcname,$pat)">
		<!--
			<xsl:message>Found <xsl:value-of select="$lcname"/></xsl:message>
		-->
			<xsl:apply-templates select="." mode="record-node"/>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="named" mode="match-pattern">
	<xsl:param name="source"/>
	<xsl:variable name="pat" select="."/>
	<!--
	<xsl:copy-of select="$source/*[local-name(.)=$pat]"/>
	-->
	<xsl:apply-templates select="$source[@name=$pat]" mode="record-node">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
</xsl:template>

<!--global components -->
<xsl:template match="node()[local-name(..)='schema']" mode="record-node">
	<xsl:variable name="file" select="./ancestor::file/@name"/>
	<xsl:variable name="link"><xsl:apply-templates mode="link" select="."/></xsl:variable>
<tr name="{@name}">
<td><xsl:value-of select="@name"/></td>
<td></td>
<td><xsl:value-of select="$file"/></td>
</tr>
</xsl:template>

<!-- local elements -->
<xsl:template match="node()" mode="record-node">
	<xsl:param name="name" select="@name"/>
	<xsl:variable name="file" select="./ancestor::file/@name"/>
	<xsl:variable name="parent" select="./ancestor::*[local-name(..)='schema']"/>
	<xsl:variable name="link"><xsl:apply-templates mode="link" select="$parent"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="local-name($parent)='group'">
			<xsl:apply-templates select="$allLocalGroups[@ref=$parent/@name]" mode="record-node" >
				<xsl:with-param name="name" select="$name"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<tr name="{$name}-{$parent/@name}">
				<td>
					<P><xsl:value-of select="$name"/></P>
				</td>
				<td>
					<xsl:value-of select="$parent/@name"/>
					<xsl:variable name="parenttype" select="local-name($parent)"/>
				</td>
				<td><xsl:value-of select="$file"/></td>
			</tr>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="xsd:element" mode="link-type">Element</xsl:template>
<xsl:template match="xsd:complexType" mode="link-type">Complex</xsl:template>
<xsl:template match="xsd:simpleType" mode="link-type">Simple</xsl:template>

<xsl:template match="node()" mode="link">
	<xsl:variable name="file" select="./ancestor::file/@name"/>
	<xsl:variable name="fn" select="concat(substring-before($file,'.xsd'),'.',$file-suffix)"/>
	<xsl:variable name="linkname" select="@name"/>
	<xsl:variable name="linktype"><xsl:apply-templates mode="link-type" select="."/></xsl:variable>
	<xsl:value-of select="concat($fn,'#',$linktype,'_',$linkname)"/>
</xsl:template>

</xsl:stylesheet>

