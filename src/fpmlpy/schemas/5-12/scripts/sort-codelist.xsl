<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform">
	
<xsl:output method="xml" encoding="UTF-8" indent="yes" />


<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz1234567890_-'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-'" />


<xsl:template match = "@*|node()">
	<xsl:copy>
		<xsl:apply-templates select = "@*|node()" />
	</xsl:copy>
</xsl:template>

<xsl:template match = "SimpleCodeList">
	<xsl:copy>
		<xsl:variable name="rows">
			<xsl:for-each select = "Row">
				<xsl:copy>
					<xsl:attribute name="sortval" select = "translate(Value[1]/SimpleValue, $uppercase, $smallcase)" />
					<xsl:copy-of select="*"/>
				</xsl:copy>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="$rows/Row">
			<xsl:sort select = "@sortval" data-type="text" order="ascending" />
			<xsl:copy>
				<xsl:copy-of select="*"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:copy>
</xsl:template>
	
</xsl:stylesheet>
