<?xml version="1.0" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:common="http://exslt.org/common"
	xmlns:view="http://www.fpml.org/views"
	exclude-result-prefixes="common"
	version="2.0">

<xsl:output method="html" />

<xsl:template match="/">
	<html>
		<xsl:call-template name="header"/>
		<body>
			<xsl:call-template name="title"/>
			<H2>Contents</H2>
			<xsl:apply-templates mode="toc" select="output/assetClassOverrides"/>
			<br/>
			<p>Total of <xsl:value-of select="count(output/assetClassOverrides//skipped/*)"/> elements skipped in Transparency view</p>
			<p>Total of <xsl:value-of select="count(output/assetClassOverrides//overridden/*)"/> elements overridden in Transparency view</p>
			<xsl:call-template name="explanations"/>

			<HR/>
			<xsl:apply-templates select="output/assetClassOverrides"/>
		</body>
	</html>
</xsl:template>

<xsl:template name="explanations">
	<H2>Explanation of rationales (for skipped elements)</H2>
	<li><b>DateAdjustments</b> - Date adjustments and other similar date calculations re out of scope of transparency view because they are typically fairly standardized and have minimal effect on the price of the product.</li>
	<li><b>Standardized</b> - Generally standard (default) values for this field apply for a standard product - products with other values are "nonstandard" and these out of scope of transparency view.</li>
	<li><b>NonStandardFeature</b> - This element represents a specialized feature of a non-standard product and should not occur in a non-customized product.</li>
	<li><b>Unsupported</b> - This product is unsupported in Transparency view.</li>
	<li> <b>Technical</b> - Skipped for technical reasons (e.g. as part of a choice block).  (Normally these elements are available by using a different element of the choice; they are omitted because if they are present the cause parsing non-determinism errors.)</li>
	<li><b>Documentation</b> - This is a documentation detail, not strongly price affecting, and so is omitted from Transparency view.</li>
	<li><b>PartySpecific</b> - This is party-specific or proprietary information, and so is omitted from Transparency view.</li>

</xsl:template>

<xsl:template name="header">
	<head>
		<title>Transparency Overrides</title>
	</head>
</xsl:template>

<xsl:template name="title">
	<H1>Transparency View Overrides by Asset Class</H1>
</xsl:template>

<xsl:template match="assetClassOverrides" mode="toc">
	<li><a href="#{@class}"><xsl:value-of select="@class"/></a></li>
</xsl:template>
<xsl:template match="assetClassOverrides">
	<H2 id="{@class}">Asset Class Overrides for <b><xsl:value-of select="@class"/></b></H2>
	<H3>Skipped <xsl:value-of select="count(.//skipped/*)"/> Elements in <xsl:value-of select="@class"/></H3>
	<H3>Overridden <xsl:value-of select="count(.//overridden/*)"/> Elements in <xsl:value-of select="@class"/></H3>
	<xsl:apply-templates select="type"/>
	<p>Number skipped = <xsl:value-of select="count(.//skipped/*)"/></p>
	<p>Number required = <xsl:value-of select="count(.//overridden/*)"/></p>
	<hr/>

</xsl:template>

<xsl:template match="type[(count(skipped/*) + count(required/*) + count(optional/*)) = 0]"/>

<xsl:template match="type">
	<br/>
	<br/>
	<H4><u>Type= <xsl:value-of select="@name"/></u></H4>
		<H5>Required</H5>
		<xsl:apply-templates select="required/overridden"/>
		<xsl:if test="not(required/overridden)"><p>(none)</p></xsl:if>
		<H5>Optional</H5>
		<xsl:apply-templates select="optional/element"/>
		<xsl:if test="not(optional/element)"><p>(none)</p></xsl:if>
		<H5>Prohibited</H5>
		<xsl:apply-templates select="skipped/skipped"/>
		<xsl:if test="not(skipped/skipped)"><p>(none)</p></xsl:if>
</xsl:template>

<xsl:template match="element">
	<li><xsl:value-of select="."/></li>
</xsl:template>


<xsl:template match="overridden[string-length(.) &gt; 0]" priority="-1">
	<li><xsl:value-of select="."/></li>
</xsl:template>

<xsl:template match="skipped[string-length(.) &gt; 0]" priority="-1">
	<li><xsl:value-of select="."/><xsl:if test="@rationale"> - Rationale: </xsl:if><xsl:value-of select="@rationale"/></li>
</xsl:template>

</xsl:stylesheet>
