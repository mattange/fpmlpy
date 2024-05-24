<?xml version="1.0" ?>
<!-- Author: Brian Lynn, Gem Soup LLC, for ISDA -->
<!-- May 2003 -->
<!-- generates a batch file for checking images -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns= "http://www.fpml.org/2005/FpML-4-2"
	xmlns:fpml= "http://www.fpml.org/2005/FpML-4-2"
	>

<xsl:param name="filename"/>
<xsl:output method="text"/>

<xsl:template match="/">
File: <xsl:value-of select="$filename"/> Product: <xsl:apply-templates mode="report-product"/>
</xsl:template>


<xsl:template match="fpml:party|fpml:header|fpml:tradeHeader|fpml:additionalPayment|fpml:calculationAgent|fpml:documentation|fpml:governingLaw|fpml:calculationAgent|fpml:calculationAgentBusinessCenter|fpml:portfolio" mode="report-product">
</xsl:template>

<xsl:template match="fpml:FpML|fpml:trade" mode="report-product" priority="5">
	<xsl:apply-templates select="*" mode="report-product"/>
</xsl:template>

<xsl:template match="node()" mode="report-product" priority="-1">
<xsl:value-of select="local-name(.)"/>
</xsl:template>


</xsl:stylesheet>
