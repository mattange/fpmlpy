<?xml version="1.0" ?>

<!-- Author: Steven Lord -->
<!--Modified by Marc Gratacos (ISDA)-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">
	<xsl:import href="utils.xsl"/>
	<xsl:import href="sharedTemplates.xsl"/>
	<xsl:template match="license">
		<xsl:apply-templates/>
		<xsl:if test="@uri and @url">
			<p> A copy of this license is available at <a href="{@url}" target="_blank" title="Link opens in new window.">
					<xsl:value-of select="@uri"/>
				</a>
			</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="buildNumber"> Build Number: <xsl:value-of select="@number"/>
	</xsl:template>
	<xsl:template name="heading1">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:param name="sectionNumber"/>
		<div>
			<h2>
				<a id="s{$sectionNumber}">
					<xsl:value-of select="$sectionNumber"/>
					<xsl:value-of select="$space"/>
					<xsl:value-of select="$name"/>
				</a>
			</h2>
		</div>
	</xsl:template>
</xsl:transform>
