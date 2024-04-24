<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
	xmlns:common="http://exslt.org/common" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="common xsd xsi"
	>
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" standalone="yes"/>
	<xsl:param name="view" select="'default value'"/>
	<!--<xsl:param name="uri">http://www.fpml.org/FpML-5/confirmation</xsl:param>-->
	
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	

	<!-- flaten the XML structure (discard file, xsd:schema) -->

	<xsl:template match="data">

		<!-- this first for-each is a hack to set the context node and copy the namespace and other key attributes -->
		<xsl:for-each select="file[contains(@name,'main')][1]/xsd:schema">
			<xsl:copy>
				<xsl:copy-of select="@*"/>

			<!-- copy any xsd:import at the top of the schema -->
				<xsl:copy-of select="../..//xsd:import"/>

			<!-- copy the content of each subschema inside the new schema root element -->
				<xsl:for-each select="../../file/xsd:schema">
					<xsl:apply-templates/>
				</xsl:for-each>
			<!--
		-->
			</xsl:copy>
		</xsl:for-each>
	</xsl:template>

	<!-- discard any inclusion of other subschema xsds  -->
	<xsl:template match="xsd:include"/>

	<!-- discard any occurence of xsd:import (only allowed at the top of the schema element  -->
	<xsl:template match="xsd:import"/>

	<!-- BAL added 2011-05:  discard all annotations (to shrink merged schema) -->
	<xsl:template match="xsd:annotation"/>

	<!-- BAL added 2011-05:  discard all comments (to shrink merged schema) -->
	<xsl:template match="comment()"/>

</xsl:stylesheet>
