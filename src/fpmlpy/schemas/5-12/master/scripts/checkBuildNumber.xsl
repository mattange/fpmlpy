<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl xsd">
	<xsl:output method="text" indent="yes"/>


	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
 
	<xsl:template match="xsd:attribute">
		<xsl:if test="@name='actualBuild'">
			<xsl:value-of select="@fixed"/>
		</xsl:if>
	</xsl:template>
	


	<xsl:template match="xsd:documentation">
    </xsl:template>
	<xsl:template match="text()" />
	
</xsl:stylesheet>
