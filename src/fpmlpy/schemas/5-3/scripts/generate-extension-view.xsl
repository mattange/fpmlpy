<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:view="http://www.fpml.org/views" 
	xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
	exclude-result-prefixes="common xsd xsi view"
	>

	<xsl:import href="add-version.xsl"/>
	<xsl:param name="version" select="'5-0'"/>
	<xsl:param name="view" select="'confirmation'"/>
	<xsl:variable name="ABC.namespaces.TF">
		<namespace ver="5-0" view="pretrade">http://www.abc.com/extension-1-0/pretrade</namespace>
		<namespace ver="5-0" view="confirmation">http://www.abc.com/extension-1-0/confirmation</namespace>
		<namespace ver="5-0" view="reporting">http://www.abc.com/extension-1-0/reporting</namespace>
		<namespace ver="5-1" view="pretrade">http://www.abc.com/extension-1-1/pretrade</namespace>
		<namespace ver="5-1" view="confirmation">http://www.abc.com/extension-1-1/confirmation</namespace>
		<namespace ver="5-1" view="reporting">http://www.abc.com/extension-1-1/reporting</namespace>
		<namespace ver="5-2" view="confirmation">http://www.abc.com/extension-1-2/confirmation</namespace>
		<namespace ver="5-2" view="reporting">http://www.abc.com/extension-1-2/reporting</namespace>
		<namespace ver="5-2" view="transparency">http://www.abc.com/extension-1-2/transparency</namespace>
		<namespace ver="5-2" view="recordkeeping">http://www.abc.com/extension-1-2/recordkeeping</namespace>
		<namespace ver="5-3" view="confirmation">http://www.abc.com/extension-1-3/confirmation</namespace>
		<namespace ver="5-3" view="reporting">http://www.abc.com/extension-1-3/reporting</namespace>
		<namespace ver="5-3" view="transparency">http://www.abc.com/extension-1-3/transparency</namespace>
		<namespace ver="5-3" view="recordkeeping">http://www.abc.com/extension-1-3/recordkeeping</namespace>
	</xsl:variable>
	<xsl:variable name="ABC.namespaces" select="common:node-set($ABC.namespaces.TF)"/>
	<xsl:variable name="ABC.ns" select="$ABC.namespaces/namespace[@ver=$version and @view=$view]/text()"/>
	<xsl:param name="target.ns" select="$ABC.ns"/>
	<!-- root template - generate for the target namespace -->
        <xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$target.ns">
				<xsl:apply-templates select="node()" mode="add-version"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Unknown version/view combination <xsl:value-of select="$version"/>/<xsl:value-of select="$view"/></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>
	<!-- adjust the FpML import declaration to reference the correct namespace and add the -x-y version information to the location-->
	<xsl:template match="xsd:import[contains(@namespace, 'FpML')]" mode="conv.schema" priority="10">
		<xsl:variable name="sl" select="@schemaLocation"/>
		<xsl:variable name="len" select="string-length($sl)"/>
		<xsl:variable name="front" select="substring($sl, 1, $len - 4)"/>
		<xsl:variable name="new.sl" select="concat($front, '-', $version, '.xsd')"/>
		<xsl:variable name="overrides" select="xsd:annotation/xsd:appinfo/view:override[@view=$view]"/>
		<xsl:variable name="exclusives" select="xsd:annotation/xsd:appinfo/view:exclusive"/>
		<xsl:variable name="excluded" select="$exclusives and not($exclusives[@view=$view])"/>

		<xsl:if test="not($excluded) and not($overrides[@skip='true'])">
			<xsd:import>
				<xsl:attribute name="namespace"><xsl:value-of select="$FpML.ns"/></xsl:attribute>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$new.sl"/></xsl:attribute>
			</xsd:import>
		</xsl:if>
        </xsl:template>

	<!-- this dummy attribute is used to force XSLT to output an fpml namespace prefix mapping,
	because XSLT has no explicit way to output an xmlns prefix mapping -->
	<xsl:template name="additional.schema.attributes">
		<xsl:attribute name="fpml:dummy" namespace="{$FpML.ns}">force-prefix</xsl:attribute>
	</xsl:template>

	<xsl:template mode="fpmlns" match="*">
	</xsl:template>
</xsl:stylesheet>
