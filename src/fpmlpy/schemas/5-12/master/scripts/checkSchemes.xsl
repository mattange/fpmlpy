<?xml version="1.0" encoding="UTF-8"?>

<!--Script to check that schemes referenced in the schema are defined. -->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl xsd">
	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="directory" select="'../src/schema/'"/>
	<xsl:variable name="srcSchemes" select="document('../srcSchemes.xml')"/>
	
	<xsl:template match="/">
		<schemeErrors>
			<xsl:for-each select="for $filename in collection(concat($directory, '?select=*.xsd')) return $filename">
				<xsl:variable name="currentFileName" select="document-uri(.)"/>
				<xml>
					<xsl:attribute name="originalFile"><xsl:value-of select="$currentFileName"/></xsl:attribute>
					
					<xsl:apply-templates/>
				</xml>
			</xsl:for-each>
		</schemeErrors>
	</xsl:template>
 
	<xsl:template match="xsd:attribute">
		<xsl:if test="@default">
			<xsl:if test="not(contains($srcSchemes,@default))">
				<uri><xsl:value-of select="@default"/></uri>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	


	<xsl:template match="xsd:documentation">
    </xsl:template>
	<xsl:template match="text()" />
	
</xsl:stylesheet>
