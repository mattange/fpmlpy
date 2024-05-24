<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl xsd">
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:template match="/">
	<xml>
		<xsl:apply-templates/>
		</xml>
	</xsl:template>
	
	<xsl:template match="scheme">	
			<uri><xsl:value-of select="@canUri"/></uri>
	</xsl:template>
	
	
	
	
	<xsl:template match="xsd:documentation">
    </xsl:template>
	<xsl:template match="text()" />
	
</xsl:stylesheet>
