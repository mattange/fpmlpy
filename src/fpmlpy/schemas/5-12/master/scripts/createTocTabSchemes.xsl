<?xml version="1.0" encoding="iso-8859-1" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must use XML Turbo to generate the schemaDoc images and run
	the 'fetch-svg.bat' file to copy them to the svg directory
 -->

<!-- Created by Marc Gratacos (ISDA), February 2004, in order to generate the lef-side menu in the specifications -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:common="http://exslt.org/common" 
        xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:drw="xalan://com.ibm.fpml.xslt.Diagram"
        xmlns:fmt="xalan://com.ibm.fpml.xslt.Format" exclude-result-prefixes="common xsl xsd drw fmt">
        <xsl:import href="xl2scheme.xsl"/>
        <xsl:variable name="startLevel" select="'1'"/>
        <xsl:variable name="space" select="' '"/>
        <!-- The targetFile parameter gets its value from the do-left-menu.bat script. -->
            <xsl:variable name="schemeTitle"> FpML Schemes</xsl:variable>
       <xsl:param name="targetFile" select="'default value'"/>
	<xsl:param name="view" select="'master'"/>
	<xsl:variable name="notview" select="concat('!', $view)"/>
        
        <!-- #### Define FpML and External Schemes #### -->
        <xsl:variable name="schemeDefinitions">FpML SCHEME DEFINITIONS</xsl:variable>  
        <xsl:variable name="extschemeDefinitions">EXTERNAL SCHEME DEFINITIONS</xsl:variable>
        <xsl:output method="text" indent="no"/>
        <!-- This template creates tocTab.js. This javascript file has a specific format to show the left side menu-->
	<xsl:template match="schemeDefinitions">
		<xsl:variable name="excel">
			<xsl:call-template name="construct-excel-schemes"/>
		</xsl:variable>
		<xsl:message>Excel schemes generated:  <xsl:value-of select="count(common:node-set($excel)/scheme[@source='excel'])"/></xsl:message>
		<xsl:variable name="content">
			<xsl:element xmlns="" name="schemeDefinitions">
				<xsl:copy-of select="version"/>
				<xsl:copy-of select="section"/>
				<xsl:copy-of select="scheme[not(@scope) or contains(@scope, $scope)]"/>
				<xsl:copy-of select="common:node-set($excel)/*"/>
			</xsl:element>
		</xsl:variable>
		<xsl:message>!!! Generate doc !!!</xsl:message>
		<xsl:apply-templates select="common:node-set($content)/*" mode="create-toc"/>
	</xsl:template>
        <xsl:template mode="create-toc"
                        match="schemeDefinitions"><![CDATA[var tocTab = new Array();var ir=0;tocTab[ir++] = new Array ("Top", "]]><xsl:value-of
                        select="$schemeTitle"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[");]]>
                <xsl:variable name="schemeSectionNumber" select="count(section)+1"/>
                <xsl:variable name="extschemeSectionNumber" select="count(section)+2"/>
                <xsl:for-each select="section">
                        <xsl:apply-templates select="." mode="frame">
                                <xsl:with-param name="level" select="$startLevel"/>
                                <xsl:with-param name="sectionName" select="position()"/>
                        </xsl:apply-templates>
                        <br/>
                </xsl:for-each>
                <!-- #### Create Table of Contents Array for FpML Schemes#### -->
                
                <![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$schemeSectionNumber"/><![CDATA[", "]]><xsl:value-of
                        select="$schemeDefinitions"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of
                        select="$schemeSectionNumber"/><![CDATA[");]]>
                
                <xsl:for-each select="scheme[count(schemeValues) &gt; 0]">
                       <xsl:sort select="@name"/> 
                        <xsl:apply-templates select="." mode="frame">
                                <xsl:with-param name="sectionNumber" select="$schemeSectionNumber"/>
                                <xsl:with-param name="subSectionNumber" select="position()"/>
                        </xsl:apply-templates>
                        <br/>
                </xsl:for-each>
                
                <!-- #### Create Table of Contents Array for External Schemes (add nCols) #### -->
                
                <![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$extschemeSectionNumber"/><![CDATA[", "]]><xsl:value-of
                        select="$extschemeDefinitions"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of
                        select="$extschemeSectionNumber"/><![CDATA[");]]>
                
                <xsl:for-each select="scheme[count(schemeValues) &lt; 1]">
                        <xsl:apply-templates select="." mode="frame">
                                <xsl:with-param name="sectionNumber" select="$extschemeSectionNumber"/>
                                <xsl:with-param name="subSectionNumber" select="position()"/>
                        </xsl:apply-templates>
                        <br/>
                </xsl:for-each>
                
                <![CDATA[var nCols = 5;]]>
        
                <!-- #### End of JavaArray and Begin nLevel Displays and Sections #### -->
                
        </xsl:template>
        <!-- Table of contents for the frame-->
        <xsl:template match="section" mode="frame">
                <xsl:param name="level"/>
                <xsl:param name="sectionName"/>
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
                <xsl:choose>
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
                <xsl:for-each select="section">
                        <xsl:apply-templates select="." mode="frame">
                                <xsl:with-param name="level" select="number($level)+1"/>
                                <xsl:with-param name="sectionName" select="concat($sectionName,'.',position())"/>
                        </xsl:apply-templates>
                </xsl:for-each>
		</xsl:if>
        </xsl:template>
        <xsl:template name="tocFrameHeading1">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading2">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading3">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template name="tocFrameHeading4">
                <xsl:param name="name"/>
                <xsl:param name="sectionName"/><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$sectionName"/><![CDATA[", "]]><xsl:value-of
                        select="$name"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$sectionName"/><![CDATA[");]]></xsl:template>
        <xsl:template match="scheme" mode="frame">
                <xsl:param name="sectionNumber"/>
                <xsl:param name="subSectionNumber"/>
                <xsl:variable name="schemeName">
                        <xsl:value-of select="@name"/>
                </xsl:variable>
                <xsl:variable name="schSectionNumber">
                        <xsl:value-of select="concat($sectionNumber,'.',$subSectionNumber)"/>
                </xsl:variable><![CDATA[tocTab[ir++] = new Array ("]]><xsl:value-of
                        select="$schSectionNumber"/><![CDATA[", "]]><xsl:value-of
                        select="$schemeName"/><![CDATA[", "]]><xsl:value-of
                        select="$targetFile"/><![CDATA[#s]]><xsl:value-of select="$schSectionNumber"/><![CDATA[");]]></xsl:template>
</xsl:stylesheet>
