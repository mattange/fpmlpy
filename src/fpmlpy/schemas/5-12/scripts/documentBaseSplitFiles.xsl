<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">
	<xsl:import href="sharedTemplatesMultipleFiles.xsl"/>
	<xsl:param name="date" select="'default value'"/>
	<xsl:param name="time" select="'default value'"/>
	<xsl:param name="targetDir" select="'html/master'"/>
	<xsl:param name="version" select="'5-0'"/>
	<xsl:param name="doc.prefix" select="concat($targetDir,'/fpml-',$version,'-intro-')"/>
	<xsl:param name="sectionNumber" select="'default value'"/>
	<xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
	<xsl:template match="documentBase">
		<xsl:for-each select="section[not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))]">
			<xsl:apply-templates select="." mode="write-file">
				<xsl:with-param name="sectNo" select="position()"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="section" mode="write-file">
		<xsl:param name="sectNo"/>
		<xsl:document href="{$doc.prefix}{$sectNo}.html">
			<xsl:message>Generate section <xsl:value-of select="$sectNo"/></xsl:message>
			<xsl:apply-templates mode="output" select=".">
				<xsl:with-param name="sectionNumber" select="$sectNo"/>
			</xsl:apply-templates>
		</xsl:document>
	</xsl:template>
	<xsl:template match="section" mode="output">
		<xsl:param name="sectionNumber"/>
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
			<head>
				<title>
					<xsl:text>FpML </xsl:text>
					<xsl:value-of select="$version"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$view"/>
					<xsl:text> View - </xsl:text>
					<xsl:value-of select="@name"/>
				</title>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<link rel="stylesheet" type="text/css" href="fpml.css"/>
                <!--Two line of code to support XMLSpy documentaion-->
				<link rel="stylesheet" type="text/css" href="display.css"/>
				<script type="text/javascript"  language="javascript"  src="htmlDocumentation.js">..</script>
			</head>
			<body>
				<xsl:if test="$sectionNumber = 1">
					<xsl:apply-templates select="../version">
						<xsl:with-param name="builddate" select="$date"/>
						<xsl:with-param name="buildtime" select="$time"/>
					</xsl:apply-templates>
				</xsl:if>
				<!-- <xsl:for-each select="section"> -->
					<xsl:apply-templates select="." mode="main">
						<xsl:with-param name="level" select="$startLevel"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
						<xsl:with-param name="sectionName" select="$sectionNumber"/>
					</xsl:apply-templates>
				<!-- </xsl:for-each> -->
				<table align="center" width="400">
					<tr>
						<xsl:choose>
							<xsl:when test="$sectionNumber = 1">
								<th width="34%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Top of Section</a>]]></xsl:text>
								</th>
								<th width="33%">
									<xsl:text disable-output-escaping="yes"><![CDATA[
								<a href="javaScript:parent.reDisplay(']]></xsl:text>
									<xsl:value-of select="$sectionNumber + 1"/>
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Next</a>]]></xsl:text>
								</th>
							</xsl:when>
							<!--
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
							-->
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
									<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Top of Section</a>]]></xsl:text>
								</th>
								
								<!--<xsl:if test="position() != 21">-->
								<xsl:if test="$sectionNumber != 21">							
									<th width="33%">
										<xsl:text disable-output-escaping="yes"><![CDATA[
									<a href="javaScript:parent.reDisplay(']]></xsl:text>
										<xsl:value-of select="$sectionNumber + 1"/>
										<xsl:text disable-output-escaping="yes"><![CDATA[',0,0)">Next</a>]]></xsl:text>
									</th>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:transform>
