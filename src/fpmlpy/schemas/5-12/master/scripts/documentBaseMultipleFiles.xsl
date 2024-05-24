<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">
	<xsl:import href="sharedTemplatesMultipleFiles.xsl"/>
	<xsl:param name="date" select="'default value'"/>
	<xsl:param name="time" select="'default value'"/>
	<xsl:param name="sectionNumber" select="'default value'"/>
	<xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
	<xsl:template match="documentBase">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
			<head>
				<title>
					<xsl:value-of select="title"/>
					<xsl:call-template name="view.label"/>
				</title>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" type="text/css" href="fpml.css"/>
			</head>
			<body>
				<xsl:apply-templates select="version">
					<xsl:with-param name="builddate" select="$date"/>
					<xsl:with-param name="buildtime" select="$time"/>
				</xsl:apply-templates>
				<xsl:for-each select="section">
					<xsl:apply-templates select="." mode="main">
						<xsl:with-param name="level" select="$startLevel"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
						<xsl:with-param name="sectionName" select="position()"/>
					</xsl:apply-templates>
				</xsl:for-each>
				<table align="center" width="400">
					<tr>
						<xsl:choose>
							<xsl:when test="$sectionNumber = 1">
								<th width="34%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Top</a>]]></xsl:text>
								</th>
								<th width="33%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber + 1"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Next</a>]]></xsl:text>
								</th>
							</xsl:when>
							<xsl:when test="$sectionNumber = 14">
								<th width="34%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber - 1"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Previous</a>]]></xsl:text>
								</th>
								<th width="33%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Top</a>]]></xsl:text>
								</th>
							</xsl:when>
							<xsl:otherwise>
								<th width="33%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber - 1"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Previous</a>]]></xsl:text>
								</th>
								<th width="34%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Top</a>]]></xsl:text>
								</th>
								<th width="33%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber + 1"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Next</a>]]></xsl:text>
								</th>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:transform>
