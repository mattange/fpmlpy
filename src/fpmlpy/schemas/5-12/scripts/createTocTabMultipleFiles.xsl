<?xml version="1.0" encoding="iso-8859-1" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must use XML Turbo to generate the schemaDoc images and run
	the 'fetch-svg.bat' file to copy them to the svg directory
 -->

<!-- Created by Marc Gratacos (ISDA), February 2004, in order to generate the lef-side menu in the specifications -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:drw="xalan://com.ibm.fpml.xslt.Diagram"
        xmlns:fmt="xalan://com.ibm.fpml.xslt.Format" exclude-result-prefixes="xsl xsd drw fmt">
<xsl:import href="utils.xsl"/>
        <xsl:variable name="startLevel" select="'1'"/>
        <xsl:variable name="space" select="' '"/>
        <!-- The targetFile parameter gets its value from the do-left-menu.bat script. -->
        <xsl:param name="targetFile" select="'default value'"/>
	 <xsl:param name="version" select="'x-y'"/>
	<xsl:param name="view" select="'master'"/>
	<xsl:variable name="notview" select="concat('!', $view)"/>
        <xsl:output method="text" indent="yes"/>
        <!-- This template creates tocTab.js. This javascript file has a specific format to show the left side menu-->
        <xsl:template
                        match="documentBase"><![CDATA[var tocTab = new Array();var ir=0;tocTab[ir++] = new Array ("Top", "]]><xsl:value-of
				select="title"/><xsl:call-template name="view.label"/><xsl:text>", "fpml-</xsl:text><xsl:value-of select="$version"/><xsl:text>-intro-1.html");</xsl:text>
			<xsl:message>multi files, view is <xsl:value-of select="$view"/></xsl:message>
			<xsl:message>num of !master= <xsl:value-of select="count(section[@view='!master'])"/></xsl:message>
			<xsl:for-each select="section[not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))]">
				<xsl:message>Working on section <xsl:value-of select="@name"/>, specified view(s) = <xsl:value-of select="@view"/></xsl:message>
				<xsl:apply-templates select="." mode="frame">
					<xsl:with-param name="level" select="$startLevel"/>
					<xsl:with-param name="sectionName" select="position()"/>
				</xsl:apply-templates>
			</xsl:for-each>
                <![CDATA[var nCols = 4;]]></xsl:template>
        <!-- Table of contents for the frame-->
        <xsl:template match="section" mode="frame">
                <xsl:param name="level"/>
                <xsl:param name="sectionName"/>
		<!--
		<xsl:message><xsl:value-of select="substring('    ', 1, $level)"/>... section <xsl:value-of select="@name"/>, specified view(s) = <xsl:value-of select="@view"/></xsl:message>
		-->
                <xsl:choose>
			<xsl:when test="($view != 'master') and (@view) and (contains(@view, $notview) or (not(contains(@view, $view)) and not(contains(@view, '!'))))">
				<xsl:message>Skip section <xsl:value-of select="@name"/>, specified view(s) = <xsl:value-of select="@view"/></xsl:message>
				<!-- skip if out of scope for this view -->
			</xsl:when>
                        <xsl:when test="$level=1">
                                <xsl:call-template name="tocFrameHeading1">
                                        <xsl:with-param name="name" select="@name"/>
                                        <xsl:with-param name="sectionName" select="$sectionName"/>
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$level=2">
                                <xsl:call-template name="tocFrameHeading2">
                                        <xsl:with-param name="name" select="@name"/>
                                        <xsl:with-param name="sectionName" select="$sectionName"/>
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$level=3">
                                <xsl:call-template name="tocFrameHeading3">
                                        <xsl:with-param name="name" select="@name"/>
                                        <xsl:with-param name="sectionName" select="$sectionName"/>
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:call-template name="tocFrameHeading4">
                                        <xsl:with-param name="name" select="@name"/>
                                        <xsl:with-param name="sectionName" select="$sectionName"/>
                                </xsl:call-template>
                        </xsl:otherwise>
                </xsl:choose>
		<xsl:for-each select="section[not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))]">
                        <xsl:apply-templates select="." mode="frame">
                                <xsl:with-param name="level" select="number($level)+1"/>
                                <xsl:with-param name="sectionName" select="concat($sectionName,'.',position())"/>
                        </xsl:apply-templates>
                </xsl:for-each>
        </xsl:template>
        <xsl:template name="tocFrameHeading1">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
			select="concat('fpml-',$version,'-intro-',$sectionName,'.html')"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading2">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
			select="concat('fpml-',$version,'-intro-',substring-before($sectionName,'.'),'.html')"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading3">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
			select="concat('fpml-',$version,'-intro-',substring-before($sectionName,'.'),'.html')"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading4">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
</xsl:stylesheet>
