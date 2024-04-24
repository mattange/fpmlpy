<?xml version="1.0" ?>
<!-- Author: Brian Lynn, GEM LLC, for ISDA -->
<!-- Aug 2007 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="view" select="'master'"/>
	<xsl:param name="stripver" select="'0'"/>
	<xsl:param name="version" select="'master'"/>
	<!-- initial upper case of string -->
	<xsl:template name="Init.Upper">
		<xsl:param name="str" />
		<xsl:variable name="first" select="substring($str, 1,1)"/>
		<xsl:variable name="rest" select="substring($str, 2)"/>
		<xsl:value-of select="translate($first,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		<xsl:value-of select="$rest"/>
	</xsl:template>

	<xsl:template match="link[@url and @uri]">
		<xsl:value-of select="."/>(<a href="{@url}">
			<xsl:value-of select="@uri"/>
		</a>) 
	</xsl:template>
	<xsl:template match="link[@url]">
		<xsl:variable name="link">
			<xsl:apply-templates mode="get.link" select="."/>
		</xsl:variable>
		<a class="web" href="{$link}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="link[@href]">
		<a class="web" href="{@href}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="link" priority="-1">
		<b>Bad link</b>
	</xsl:template>

	<xsl:template match="link[contains(@url,'xml.zip')]" mode="get.link">
		<xsl:text>../../xml/</xsl:text>
		<xsl:value-of select="$view"/>
		<xsl:text>.zip</xsl:text>
	</xsl:template>
	<xsl:template match="link[contains(@url,'xml/')]" mode="get.link">
		<xsl:value-of select="substring-before(@url,'xml/')"/>
		<xsl:text>../xml/</xsl:text>
		<xsl:value-of select="$view"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring-after(@url,'xml/')"/>
	</xsl:template>
	<xsl:template match="link" mode="get.link">
		<xsl:choose>
			<xsl:when test="$stripver = '1' and $version">
				<xsl:variable name="targ" select="concat('-',$version)"/>
				<xsl:variable name="before" select="substring-before(@url,$targ)"/>
				<xsl:variable name="after" select="substring-after(@url,$targ)"/>
				<xsl:choose>
					<xsl:when test="contains($before, 'fpml-')">
						<xsl:value-of select="concat($before,$after)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@url"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@url"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="view.label">
		<xsl:message>***********************************</xsl:message>
		<xsl:message>Utils view is <xsl:value-of select="$view"/></xsl:message>
		<xsl:message>***********************************</xsl:message>
		<xsl:text> (</xsl:text>
		<xsl:call-template name="Init.Upper">
			<xsl:with-param name="str" select="$view"/>
		</xsl:call-template>
		<xsl:text> View)</xsl:text>
	</xsl:template>

</xsl:stylesheet>
