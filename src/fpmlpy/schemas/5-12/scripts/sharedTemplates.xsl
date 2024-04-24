<?xml version="1.0" ?>

<!-- Author: Steven Lord -->
<!--Modified by Maithili Koli-->
<!-- Added schema namespace xmlns:xsd="http://www.w3.org/2001/XMLSchema" attribute to support XMLSpy documentation-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   xmlns:xsd="http://www.w3.org/2001/XMLSchema"   xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">
	<xsl:import href="utils.xsl"/>
	<!-- Some global variables -->
    <!--4 lines of code to support XMLSpy documentation-->
	<xsl:key name="element" match="xsd:element" use="@name"/>
	<xsl:variable name="tableName">
		<xsl:value-of select="generate-id()"/>
	</xsl:variable>
	<xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
	<xsl:param name="view" select="'master'"/>
	<xsl:variable name="notview" select="concat('!', $view)"/>
	<xsl:param name="version" select="'0'"/>
	<xsl:variable name="startLevel" select="'1'"/>
	<xsl:variable name="space" select="' '"/>
    <!--7 lines of code to support XMLSpy documentation-->
	<xsl:variable name="currentXmlFile">
		<xsl:text>../tmp/MERGED_</xsl:text>
		<xsl:value-of select="$view"/>
		<xsl:text>.xml</xsl:text>
	</xsl:variable>
	<!--<xsl:variable name="colorLookupDoc" select="document('MERGED_reporting.xml')"/>-->
	<xsl:variable name="colorLookupDoc" select="document($currentXmlFile)"/>
	<xsl:template match="bullets">
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
		<ul class="bulleted">
			<xsl:apply-templates/>
		</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="bullet">
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
		<li>
			<xsl:apply-templates/>
		</li>
		</xsl:if>
	</xsl:template>
    <!--XMLSpy Documentation-->
	<xsl:template name="fileName">
		<xsl:param name="interSection"></xsl:param>
		<xsl:variable name="fileLookupName">
			<xsl:text>lookup_</xsl:text>
			<xsl:value-of select="$view"/>
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		<xsl:variable name="fileLookup" select="document($fileLookupName)"/>
	
		<xsl:for-each select="$fileLookup/fileNames/file">
			<xsl:variable name="tagName">
					<xsl:value-of select="tag"/>
				</xsl:variable>
				<xsl:variable name="level">
					<xsl:value-of select="name"/>
				</xsl:variable>		
				<xsl:if test="$tagName=$interSection">
					<xsl:copy-of select="$level"/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:strip-space elements="*"/>
    <xsl:template match="link">
		<xsl:if test="@url and @uri">
			<xsl:value-of select="."/>(<a href="{@url}">
				<xsl:value-of select="@uri"/>
			</a>) </xsl:if>
		<!-- 20070912 LL: modified to open URL in new browser window when source <link> contains attribute "external" e.g., <link external="true"... -->
		<xsl:if test="@url and not(@uri) and not(@external)">
			<a class="web" target="#" href="{@url}">
				<xsl:value-of select="."/>
			</a>
		</xsl:if>
		<xsl:if test="@url and not(@uri) and @external">
			<a class="web" href="{@url}" target="_blank" title="Link opens in new window.">
				<xsl:value-of select="."/>
			</a>
		</xsl:if>
		<xsl:if test="@href ">
			<a class="web" target="#" href="{@href}">
				<xsl:value-of select="."/>
			</a>
		</xsl:if>
		<xsl:if test="@sectionId">
			<a href="#{@sectionId}">
				<xsl:value-of select="."/>
			</a>
		</xsl:if>
		<xsl:if test="@id">
			<a>
				<xsl:attribute name="name">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
			</a>
		</xsl:if>
		<xsl:if test="@file">
			<a>
				<xsl:attribute name="href">
					<xsl:text>fpml-</xsl:text>
					<xsl:value-of select="$version"/>
					<xsl:text>-intro-</xsl:text>
				<!-- call template for getting the name of the file -->
					<xsl:call-template name="fileName">
						<xsl:with-param name="interSection">
							<xsl:value-of select="@file"/>
						</xsl:with-param>
					</xsl:call-template>
				<!-- call template for getting the name of the file -->
					<xsl:text>.html#</xsl:text>
					<xsl:value-of select="@sectionId"/>
				</xsl:attribute>
			</a>
        </xsl:if>
    </xsl:template>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="anchor">
		<a>
			<xsl:attribute name="name">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
		</a>
    </xsl:template>
	<xsl:template match="section">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="diagramInfo">
		<xsl:if test="@name">	
			<xsl:variable name="sName">
				<xsl:value-of select="@name"/>
			</xsl:variable>
			
			<table style="width:100%;cellpadding:0">
				<xsl:attribute name="id">	
					<xsl:value-of select="translate($sName,' ','_')"/>
				</xsl:attribute>
				<tr>
					<td style="width:50%" align="right">	
						<xsl:apply-templates select="diagram"/>
					</td>
					<td style="width:50%">	
						<ul style="text-align:left;">
							<xsl:apply-templates select="paragraph"/>
							<xsl:apply-templates select="bullets"/>
							<xsl:apply-templates select="link"/>
						</ul>
					</td>							
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="annotationText">
		<xsl:param name="EM"></xsl:param>
		<xsl:param name="elementType"></xsl:param>
		<xsl:param name="xsd_name"></xsl:param>
		<xsl:param name="parentName"></xsl:param>	
		<xsl:for-each select="$colorLookupDoc">
			<xsl:variable name="xsd">
				<xsl:value-of select="concat(substring($xsd_name,1,string-length($xsd_name) - 4),'.',substring($xsd_name, string-length($xsd_name) - 2))"/>
			</xsl:variable>
			<!--<xsl:copy-of select="$elementType"/>-->
	
			<!--global elements-->
			<xsl:if test="$elementType='complexType'">
				<xsl:variable name="documentationData">
					<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$EM]/xsd:annotation/xsd:documentation"/>
				</xsl:variable>
				<xsl:if test="$documentationData=''">
					<xsl:text>No Annotation Available</xsl:text>
				</xsl:if>
				<xsl:if test="$documentationData!=''">
					<xsl:copy-of select="$documentationData"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$elementType='element'">
				<xsl:variable name="documentationData">
					<xsl:if	test="$parentName!=''">
						<!--if parent is a complexType -->
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:choice/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:choice/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>

						<!--if parent is a group -->
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:choice/xsd:sequence/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$parentName]/xsd:sequence/xsd:sequence/xsd:choice/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
					</xsl:if>
					<xsl:if	test="$parentName=''">
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element[@name=$EM]/xsd:annotation/xsd:documentation"/>
					</xsl:if>
				</xsl:variable>
				<xsl:if test="$documentationData=''">
					<xsl:text>No Annotation Available</xsl:text>
				</xsl:if>
				<xsl:if test="$documentationData!=''">
					<xsl:copy-of select="$documentationData"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$elementType='group'">
				<xsl:variable name="documentationData">
					<xsl:if	test="$parentName!=''">
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:complexContent/xsd:extension/xsd:sequence/xsd:group"/><!--[@ref='$EM']"/>-->
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:complexType[@name=$parentName]/xsd:sequence/xsd:group"/><!--</xsl:value-of>/xsd:group[@ref='$EM']"/>-->
					</xsl:if>
					<xsl:if	test="$parentName=''">
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:group[@name=$EM]/xsd:annotation/xsd:documentation"/>
					</xsl:if>
				</xsl:variable>	
				<xsl:if test="$documentationData=''">
					<xsl:text>No Annotation Available</xsl:text>
				</xsl:if>
				<xsl:if test="$documentationData!=''">
					<xsl:copy-of select="$documentationData"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$elementType='simpleType'">
			<xsl:variable name="documentationData">
					<xsl:if	test="$parentName!=''">
						<xsl:value-of select="$colorLookupDoc/data/file[@name=$xsd]/xsd:schema/xsd:simpleType[@name=$EM]/xsd:annotation/xsd:documentation"/>
					</xsl:if>
			</xsl:variable>
			</xsl:if>
			
		</xsl:for-each>
		<xsl:text>
		</xsl:text>
	</xsl:template>
	<xsl:template match="version">
		<xsl:param name="builddate"/>
		<xsl:param name="buildtime"/>
		<xsl:apply-templates select="title">
			<xsl:with-param name="date" select="@date"/>
			<xsl:with-param name="status" select="@status"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="subtitle"/>
		<h2 class="abstractHeader">Version: <xsl:value-of select="@number"/>
		</h2>
		<xsl:if test="not(@status)">
			<h2 class="abstractHeader">
				<i>
					<xsl:value-of select="@date"/>
				</i>
			</h2>
		</xsl:if>
		<h4>This version: <i>
				<xsl:value-of select="@uri"/>
			</i>
		</h4>
		<xsl:apply-templates select="latestVersion"/>
		<xsl:apply-templates select="previousVersion"/>
		<xsl:apply-templates select="editor"/>
		<xsl:apply-templates select="errataForThisVersion"/>
		
		<p><xsl:apply-templates select="buildNumber"/>; Document built: <xsl:value-of select="concat($builddate, ' ', $buildtime)"/>
		</p>
		<p/>
		<xsl:apply-templates select="license"/>
		<p>
			<br/>
			<br/>
		</p>
		<xsl:apply-templates select="disclaimer/paragraph"/>
		<p>
			<br/>
			<br/>
		</p>
	</xsl:template>
	<xsl:template match="versionArch">
		<xsl:param name="builddate"/>
		<xsl:param name="buildtime"/>
		<xsl:apply-templates select="titleArch">
			<xsl:with-param name="date" select="@date"/>
			<xsl:with-param name="status" select="@status"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="subtitle"/>
		<xsl:apply-templates select="thisVersion"/>
		<xsl:apply-templates select="previousVersion"/>
		<xsl:apply-templates select="lastestRecommendation"/>
		<p>Document built: <xsl:value-of select="concat($builddate, ' ', $buildtime)"/>
		</p>
		<p/>
		<xsl:apply-templates select="license"/>
		<p>
			<br/>
			<br/>
		</p>
		<xsl:apply-templates select="disclaimer/paragraph"/>
		<p>
			<br/>
			<br/>
		</p>
	</xsl:template>
	<xsl:template match="license">
		<xsl:if test="@url">
			<xsl:apply-templates select="paragraph"/>
			<p> A copy of this license is available at <a href="{@url}" target="_blank" title="Link opens in new window.">
				<xsl:value-of select="@uri"/>
			</a>
			</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="thisVersion">
		<h4>This version: <xsl:if test="@url">
			<a href="{@url}" target="_blank" title="Link opens in new window.">
					<i>
						<xsl:value-of select="@uri"/>
					</i>
				</a>
			</xsl:if>
			<xsl:if test="not(@url)">
				<i>
					<xsl:value-of select="@uri"/>
				</i>
			</xsl:if>
		</h4>
	</xsl:template>
	<xsl:template match="previousVersion">
		<h4>Previous version: <xsl:if test="@url">
			<a href="{@url}" target="_blank" title="Link opens in new window.">
					<i>
						<xsl:value-of select="@uri"/>
					</i>
				</a>
			</xsl:if>
			<xsl:if test="not(@url)">
				<i>
					<xsl:value-of select="@uri"/>
				</i>
			</xsl:if>
		</h4>
	</xsl:template>
	<xsl:template match="lastestRecommendation">
		<h4>Lastest Recommendation: <xsl:if test="@url">
			<a href="{@url}" target="_blank" title="Link opens in new window.">
					<i>
						<xsl:value-of select="@uri"/>
					</i>
				</a>
			</xsl:if>
			<xsl:if test="not(@url)">
				<i>
					<xsl:value-of select="@uri"/>
				</i>
			</xsl:if>
		</h4>
	</xsl:template>
	<xsl:template match="latestVersion">
		<h4>Latest version: <xsl:if test="@url">
			<a href="{@url}" target="_blank" title="Link opens in new window.">
					<i>
						<xsl:value-of select="@uri"/>
					</i>
				</a>
			</xsl:if>
			<xsl:if test="not(@url)">
				<i>
					<xsl:value-of select="@uri"/>
				</i>
			</xsl:if>
		</h4>
	</xsl:template>
	<xsl:template match="errataForThisVersion">
		<xsl:variable name="uri">
			<xsl:apply-templates mode="map-errata-to-view" select="@uri"/>
		</xsl:variable>
		<xsl:variable name="url">
			<xsl:apply-templates mode="map-errata-to-view" select="@url"/>
		</xsl:variable>
		<xsl:apply-templates mode="gen-errata-link" select=".">
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="uri" select="$uri"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="errataForThisVersion" mode="gen-errata-link">
		<xsl:param name="uri" select="@uri"/>
		<xsl:param name="url" select="@url"/>
		<h4>Errata for this version: <xsl:if test="$url">
				<a href="{$url}">
					<i>
						<xsl:value-of select="$uri"/>
					</i>
				</a>
			</xsl:if>
			<xsl:if test="not($url)">
				<i>
					<xsl:value-of select="$uri"/>
				</i>
			</xsl:if>
		</h4>
	</xsl:template>
	<xsl:template match="@*" mode="map-errata-to-view">
		<xsl:variable name="val" select="string(.)"/>
		<xsl:variable name="front" select="substring-before($val, 'fpml-')"/>
		<xsl:variable name="rest" select="substring-after($val, 'fpml-')"/>
		<xsl:variable name="middle" select="substring-before($rest, 'fpml-')"/>
		<xsl:variable name="back" select="substring-after($rest, 'fpml-')"/>
		
		<xsl:value-of select="$front"/>
		<xsl:text>fpml-</xsl:text>
		<xsl:value-of select="$middle"/>
		<xsl:value-of select="$view"/>
		<xsl:text>/fpml-</xsl:text>
		<xsl:value-of select="$back"/>
	</xsl:template>
	<xsl:template match="buildNumber">
		Build Number: <xsl:value-of select="@number"/>
	</xsl:template>
	<xsl:template match="title">
		<xsl:param name="date"/>
		<xsl:param name="status"/>
		<h1>
			<xsl:value-of select="."/>
			<xsl:if test="$date and $status">
				<xsl:choose>
					<xsl:when test="$status='wip'"> Work In Progress </xsl:when>
					<xsl:when test="$status='wd'"> Working Draft </xsl:when>
					<xsl:when test="$status='lcwd'"> Last Call Working Draft </xsl:when>
					<xsl:when test="$status='tr'"> Trial Recommendation </xsl:when>
					<xsl:when test="$status='rec'"> Recommendation </xsl:when>
				</xsl:choose>
				<xsl:value-of select="$date"/>
			</xsl:if>
			<xsl:call-template name="view.label"/>
		</h1>
	</xsl:template>
	<xsl:template match="titleArch">
		<xsl:param name="date"/>
		<xsl:param name="status"/>
		<h1>
			<xsl:value-of select="."/>
			<xsl:if test="$date and $status">
				<xsl:choose>
					<xsl:when test="$status='wip'"> Work In Progress </xsl:when>
					<xsl:when test="$status='wd'"> Working Draft </xsl:when>
					<xsl:when test="$status='lcwd'"> Last Call Working Draft </xsl:when>
					<xsl:when test="$status='tr'"> Trial Recommendation </xsl:when>
					<xsl:when test="$status='rec'"> Recommendation </xsl:when>
				</xsl:choose>
				<xsl:value-of select="$date"/>
			</xsl:if>
		</h1>
	</xsl:template>
	<xsl:template name="view.label">
		<xsl:text> (</xsl:text>
		<xsl:call-template name="Init.Upper">
			<xsl:with-param name="str" select="$view"/>
		</xsl:call-template>
		<xsl:text> View)</xsl:text>
	</xsl:template>

	<xsl:template match="subtitle">
		<h2>
			<xsl:value-of select="."/>
		</h2>
	</xsl:template>
	<xsl:template match="paragraph">
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
			<p>
				<xsl:apply-templates select="node()"/>
			</p>
		</xsl:if>
	</xsl:template>
	<xsl:template match="u">
		<u>
			<xsl:apply-templates select="node()"/>
		</u>
	</xsl:template>
	<xsl:template match="table">
		<table>
			<xsl:attribute name="class">table</xsl:attribute>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="tc"/>
	<xsl:template match="tr">
		<tr>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>
	<xsl:template match="td">
		<td>
			<!--<xsl:copy-of select="@*"/>-->
			<xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute></xsl:if>
			<xsl:if test="@width"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
			<xsl:if test="@align"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
			<xsl:if test="@valign"><xsl:attribute name="valign"><xsl:value-of select="@valign"/></xsl:attribute></xsl:if>
            <xsl:apply-templates/>
		</td>
	</xsl:template>
	<xsl:template match="b|B">
		<b>
			<xsl:value-of select="."/>
		</b>
	</xsl:template>
	<xsl:template match="programlisting">
		<pre>
                        <xsl:copy-of select="node()"/>
                </pre>
	</xsl:template>
	<xsl:template match="i|I">
		<i>
			<xsl:value-of select="."/>
		</i>
	</xsl:template>
	<xsl:template match="text">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="editor">
		<h4>
			<b>Document Editor: </b>
			<xsl:value-of select="."/>
			<xsl:if test="@email">
				<I>(<a href="mailto:{@email}">
						<xsl:value-of select="@email"/>
					</a>)</I>
			</xsl:if>
		</h4>
	</xsl:template>

	<xsl:template match="*" mode="main" priority="-1">
	</xsl:template>

	<xsl:template match="section" mode="main">
		<xsl:param name="level"/>
		<xsl:param name="sectionName"/>
		<xsl:param name="sectionNumber"/>
		<xsl:param name="pos" select="1"/>
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
		<div>
			<xsl:choose>
				<xsl:when test="$level=1">
					<xsl:message>Working on <xsl:value-of select="@name"/>, sect = <xsl:value-of select="$sectionName"/></xsl:message>
					<xsl:call-template name="heading1">
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="sectionName" select="$sectionName"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$level=2">
					<xsl:call-template name="heading2">
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="sectionName" select="$sectionName"/>
						<xsl:with-param name="pos" select="$pos"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$level=3">
                    <!--XMLSpy Documentation-->
					<xsl:if test="@id!=''">
						<a>
							<xsl:attribute name="name">
								<xsl:value-of select="@id"/>
							</xsl:attribute>
						</a>
					</xsl:if>
                    <xsl:call-template name="heading3">
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="sectionName" select="$sectionName"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="heading4">
						<xsl:with-param name="name" select="@name"/>
						<xsl:with-param name="sectionName" select="$sectionName"/>
						<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<!-- <xsl:apply-templates/> -->
			<xsl:for-each select="section[not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))]|*[not(local-name(.)='section')]">
				<xsl:apply-templates select="."/> 
				<xsl:variable name="subpos" select="position() - count(preceding-sibling::*[(local-name(.) != 'section') and (not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view))))])"/>
				<!--
				<xsl:message>Working on section <xsl:value-of select="@name"/>, specified view(s) = <xsl:value-of select="@view"/>, pos=<xsl:value-of select="position()"/>, subpos = <xsl:value-of select="$subpos"/></xsl:message>
				-->

				<xsl:apply-templates select="." mode="main">
					<xsl:with-param name="level" select="number($level)+1"/>
					<xsl:with-param name="pos" select="$subpos"/>
					<xsl:with-param name="sectionNumber" select="$sectionNumber"/>
					<xsl:with-param name="sectionName" select="concat($sectionName,'.',$subpos)"/>
				</xsl:apply-templates>
                <xsl:apply-templates select="sectionPosition">
                    <xsl:with-param name="sectionNumber" select="$sectionNumber"/>
                </xsl:apply-templates>
			</xsl:for-each>
		</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="heading1">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<div>
			<h2>
				<a id="s{$sectionName}">
					<xsl:value-of select="$sectionName"/>
					<xsl:value-of select="$space"/>
					<xsl:value-of select="$name"/>
				</a>
			</h2>
		</div>
	</xsl:template>
	<xsl:template name="heading2">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:param name="pos"/>
		<xsl:choose>
			<xsl:when test="$pos &gt; 1">
				<div>
					<h3>
						<a id="s{$sectionName}">
							<xsl:value-of select="$sectionName"/>
							<xsl:value-of select="$space"/>
							<xsl:value-of select="$name"/>
						</a>
					</h3>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<h3>
					<a id="s{$sectionName}">
						<xsl:value-of select="$sectionName"/>
						<xsl:value-of select="$space"/>
						<xsl:value-of select="$name"/>
					</a>
				</h3>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="heading3">
		<xsl:param name="name"/>
        <xsl:param name="sectionName"/>
        <xsl:param name="sectionNumber"/>
        <h4>
			<a id="s{$sectionName}">
				<xsl:value-of select="$sectionName"/>
				<xsl:value-of select="$space"/>
				<xsl:value-of select="$name"/>
			</a>
		</h4>

		<xsl:variable name="secName">
			<xsl:value-of select="translate($name,' ','_')"/>
		</xsl:variable>
	</xsl:template>
    <!--End XMLSpy Documentation-->
	<xsl:template name="heading4">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<h5>
			<a id="s{$sectionName}">
				<xsl:value-of select="$sectionName"/>
				<xsl:value-of select="$space"/>
				<xsl:value-of select="$name"/>
			</a>
		</h5>
	</xsl:template>
	<xsl:template match="object">
		<xsl:copy-of select="."/>
	</xsl:template>
    <!--obtainSchemaName template is to support XMLSpy documentation-->
<!--obtainSchemaName and schemaName templates are to support XMLSpy documentation-->
    <xsl:template name="obtainSchemaName">
	   <xsl:param name="currentVar"></xsl:param>
    	<xsl:param name="currentVarType"></xsl:param>
	   <xsl:param name="parentName"></xsl:param>
    	<xsl:param name="xsd"></xsl:param>
	   <!--<xsl:variable name="localElement"></xsl:variable>-->
		  <xsl:for-each select="$colorLookupDoc/data/file"><!--[@name='brokerEquityOption']">-->
			<xsl:variable name="tempName">
				<xsl:value-of select="@name"/>
			</xsl:variable>
<!--		  	<xsl:text>*</xsl:text>
		  	<xsl:copy-of select="$currentVarType"/>
		  	<xsl:text>%</xsl:text>
		  	<xsl:copy-of select="currentVar"></xsl:copy-of>
		  	<xsl:text>#</xsl:text>
		  	<xsl:copy-of select="currentVarType"></xsl:copy-of>
		  	<xsl:text>@</xsl:text>
		  	<xsl:copy-of select="parentName"></xsl:copy-of>
		  	<xsl:text>^</xsl:text>
		  	<xsl:copy-of select="xsd"></xsl:copy-of>
		  	<xsl:text>*</xsl:text>-->
            <xsl:if test="$currentVarType='complexType'"> <!--it is a complex Element-->
                <xsl:for-each select="$colorLookupDoc/data/file[@name=$tempName]/xsd:schema/xsd:complexType">
                    <xsl:variable name="loopElementName">
						<xsl:value-of select="@name"/>
					</xsl:variable>
					<xsl:if test="$loopElementName=$currentVar">  						
						<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
					</xsl:if>
				</xsl:for-each>					
			</xsl:if>
			<xsl:if test="$currentVarType='element'">   <!--element can be local for global-->
				<xsl:choose>
					<!-- local element when parentName is passed-->
	       		 	<xsl:when test="$xsd!=''">
    					<xsl:if test="$xsd=$tempName">
			          		<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>							
						</xsl:if>
				    </xsl:when>
					<xsl:when test="$parentName!=''">
						<xsl:if test="$xsd!=''">
							<xsl:value-of select="$xsd"/>
						</xsl:if>
						<xsl:if test="$xsd=''">
							<xsl:for-each select="$colorLookupDoc/data/file[@name=$tempName]/xsd:schema/xsd:complexType"> <!--If element is inside complex Type-->
								<xsl:variable name="loopElementName">
					           		<xsl:value-of select="@name"/>
								</xsl:variable>							
								<xsl:if test="$loopElementName=$parentName">  
									<xsl:for-each select="xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
								    		<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:sequence/xsd:choice/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:sequence/xsd:choice/xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:complexContent/xsd:extension/xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:complexContent/xsd:extension/xsd:sequence/xsd:choice/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
									       	<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:complexContent/xsd:extension/xsd:sequence/xsd:choice/xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
							<xsl:for-each select="$colorLookupDoc/data/file[@name=$tempName]/xsd:schema/xsd:group"> <!--If element is inside a group element-->
								<xsl:variable name="loopElementName">
									<xsl:value-of select="@name"/>
								</xsl:variable>							
								<xsl:if test="$loopElementName=$parentName">  
                            		<xsl:for-each select="xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
									<xsl:for-each select="xsd:complexContent/xsd:extension/xsd:sequence/xsd:element"><!--path-->
										<xsl:variable name="innerElementName">
											<xsl:value-of select="@name"/>
										</xsl:variable>
										<xsl:if test="$innerElementName=$currentVar">   
											<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="key('element', $currentVar)[1]"> 					
							<xsl:variable name="currentSchema">
								<xsl:value-of select="ancestor::file/@name"/>
							</xsl:variable>
							<xsl:if test="$tempName=$currentSchema">  <!--shows only the first occurance-->
								<xsl:value-of select="concat(substring($currentSchema,1,string-length($currentSchema) - 4),'_',substring($currentSchema, string-length($currentSchema) - 2))"/>
							</xsl:if>
						</xsl:for-each>
    				</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="$currentVarType='group'">   <!--item is a group -->
                <xsl:choose>
					<xsl:when test="$xsd!=''">
						<xsl:if test="$xsd=$tempName">
							<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>							
						</xsl:if>
					</xsl:when>				
					<xsl:when test="$parentName!=''">
	       				<xsl:if test="$xsd!=''">
							<xsl:value-of select="$xsd"/>
						</xsl:if>
						<xsl:if test="$xsd=''">
							<xsl:for-each select="$colorLookupDoc/data/file[@name=$tempName]/xsd:schema/xsd:complexType">
								<xsl:variable name="loopElementName">
									<xsl:value-of select="@name"/>
								</xsl:variable>							
								<xsl:if test="$loopElementName=$parentName">  
										<xsl:for-each select="xsd:sequence/xsd:group"> <!--path-->
				    						<xsl:variable name="innerElementName">
					       						<xsl:value-of select="@ref"/>
							     			</xsl:variable>
								        	<xsl:if test="$innerElementName=$currentVar">   
										      	<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
    										</xsl:if>
	       								</xsl:for-each>
										<xsl:for-each select="xsd:complexContent/xsd:extension/xsd:sequence/xsd:group"><!--path-->
											<xsl:variable name="innerElementName">
												<xsl:value-of select="@ref"/>
											</xsl:variable>
											<xsl:if test="$innerElementName=$currentVar">   
												<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>
											</xsl:if>
										</xsl:for-each>
									</xsl:if>
								</xsl:for-each>								
							</xsl:if>					
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$colorLookupDoc/data/file[@name=$tempName]/xsd:schema/xsd:group">
								<xsl:variable name="loopElementName">
									<xsl:value-of select="@name"/>
								</xsl:variable>
								<xsl:if test="$loopElementName=$currentVar">					
									<xsl:value-of select="concat(substring($tempName,1,string-length($tempName) - 4),'_',substring($tempName, string-length($tempName) - 2))"/>						
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>	
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
    </xsl:template>
    <xsl:template name="schemaName">
	   <xsl:param name="currentVariable"></xsl:param>
	   <xsl:param name="currentVariableType"></xsl:param>
	   <xsl:param name="xsd"></xsl:param>
	   <xsl:param name="parentName"></xsl:param>
	   <xsl:call-template name="obtainSchemaName">
	   <xsl:with-param name="currentVar">
			<xsl:copy-of select="$currentVariable"/>
	   </xsl:with-param>
		<xsl:with-param name="currentVarType">
			<xsl:copy-of select="$currentVariableType"/>
		</xsl:with-param>
		<xsl:with-param name="xsd">
			<xsl:copy-of select="$xsd"/>
		</xsl:with-param>
		<xsl:with-param name="parentName">
			<xsl:copy-of select="$parentName"/>
		</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:strip-space elements="*"/>
	<xsl:template match="diagram" xmlns:file="java.io.File">
		<xsl:variable name="cv">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<!--XMLSpy Documentation generation-->
        <xsl:choose>
			<xsl:when test="contains(@imageSource,'.svg')">
				<object type="image/svg+xml" data="{@imageSource}">
					<xsl:copy-of select="@width|@height"/>
				</object>
			</xsl:when>
			<!--ANNOTATION-->
			<xsl:when test="@display='annotation'">
				<xsl:variable name="elementName">
					<xsl:value-of select="@name"/>
				</xsl:variable>
				<a >
					<xsl:attribute name="href">
						<xsl:text>schemaDocumentation/schemas/</xsl:text> 
						<xsl:call-template name="schemaName">
							<xsl:with-param name="currentVariable">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
							<xsl:with-param name="currentVariableType">
								<xsl:value-of select="@type"/>
							</xsl:with-param>
							<xsl:with-param name="xsd">
								<xsl:value-of select="@xsd"/>
							</xsl:with-param>
							<xsl:with-param name="parentName">
								<xsl:value-of select="@parentName"/>
							</xsl:with-param>						
						</xsl:call-template>
						<xsl:if test="@type='element'">								
							<xsl:choose>
								<xsl:when test="@parentName != ''">
									<xsl:choose>
										<xsl:when test="contains(@parentName,'.model')">
											<xsl:text>/groups/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/complexTypes/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>								
									<xsl:value-of select="@parentName"/>
									<xsl:text>/</xsl:text> 
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>/elements/</xsl:text> 
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="@type='complexType'">
							<xsl:text>/complexTypes/</xsl:text> 								
						</xsl:if>
						<xsl:if test="@type='group'">
							<xsl:text>/groups/</xsl:text> 								
						</xsl:if>
						<xsl:value-of select="@name" ></xsl:value-of>
						<xsl:text>.html</xsl:text> 
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:copy-of select="@width|@height"/>
					<xsl:copy-of select="$elementName"/>
				</a>
				<xsl:text>-</xsl:text> 
				<xsl:call-template name="annotationText">
					<xsl:with-param name="EM">
						<xsl:copy-of select="$elementName"/>
					</xsl:with-param>
					<xsl:with-param name="elementType">
						<xsl:value-of select="@type"/>
					</xsl:with-param>
					<xsl:with-param name="xsd_name">
						<xsl:call-template name="schemaName">
							<xsl:with-param name="currentVariable">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
							<xsl:with-param name="currentVariableType">
								<xsl:value-of select="@type"/>
							</xsl:with-param>
							<xsl:with-param name="xsd">
								<xsl:value-of select="@xsd"/>
							</xsl:with-param>
							<xsl:with-param name="parentName">
								<xsl:value-of select="@parentName"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="parentName">
						<xsl:value-of select="@parentName"/>
					</xsl:with-param>
				</xsl:call-template>
				<br/>
			</xsl:when>
			<!--INLINE-->
			<xsl:when test="@display='inline'">
						<img>
							<xsl:attribute name="src">
								<xsl:text>schemaDocumentation/schemas/</xsl:text> 
								<xsl:call-template name="schemaName">
									<xsl:with-param name="currentVariable">
										<xsl:value-of select="@name"/>
									</xsl:with-param>
									<xsl:with-param name="currentVariableType">
										<xsl:value-of select="@type"/>
									</xsl:with-param>
									<xsl:with-param name="xsd">
										<xsl:value-of select="@xsd"/>
									</xsl:with-param>
									<xsl:with-param name="parentName">
										<xsl:value-of select="@parentName"/>
									</xsl:with-param>						
								</xsl:call-template>
					
								<xsl:if test="@type='element'">								
									<xsl:choose>
										<xsl:when test="@parentName != ''">
											<xsl:choose>
												<xsl:when test="contains(@parentName,'.model')">
													<xsl:text>/groups/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/complexTypes/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>	
											<xsl:value-of select="@parentName"/>
											<xsl:text>/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/elements/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="@type='complexType'">
										<xsl:text>/complexTypes/</xsl:text> 								
								</xsl:if>
								<xsl:if test="@type='group'">
									<xsl:text>/groups/</xsl:text> 								
								</xsl:if>
								<xsl:value-of select="@name"/>
								<xsl:text>.png</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:text>schemaDocumentation/schemas/</xsl:text> 
								<xsl:call-template name="schemaName">
									<xsl:with-param name="currentVariable">
										<xsl:value-of select="@name"/>
									</xsl:with-param>
									<xsl:with-param name="currentVariableType">
										<xsl:value-of select="@type"/>
									</xsl:with-param>
									<xsl:with-param name="xsd">
										<xsl:value-of select="@xsd"/>
									</xsl:with-param>
									<xsl:with-param name="parentName">
										<xsl:value-of select="@parentName"/>
									</xsl:with-param>						
								</xsl:call-template>
								<xsl:if test="@type='element'">								
									<xsl:choose>
										<xsl:when test="@parentName != ''">
											<xsl:choose>
												<xsl:when test="contains(@parentName,'.model')">
													<xsl:text>/groups/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/complexTypes/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>	
											<xsl:value-of select="@parentName"/>
											<xsl:text>/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/elements/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="@type='complexType'">
									<xsl:text>/complexTypes/</xsl:text> 								
								</xsl:if>
								<xsl:if test="@type='group'">
									<xsl:text>/groups/</xsl:text> 								
								</xsl:if>
<!--								<xsl:text>/doc-files/</xsl:text> 
								<xsl:value-of select="@type"/>
								<xsl:text>_</xsl:text> -->
								<xsl:value-of select="@name"/>
								<xsl:text>.png</xsl:text>
							</xsl:attribute>
							<xsl:copy-of select="@width|@height"/>
						</img>	
			</xsl:when>
			<!--POPUP-->
			<xsl:when test="@display='popup'">
				<a >
					<xsl:attribute name="href">
						<xsl:text>schemaDocumentation/schemas/</xsl:text> 
						<xsl:call-template name="schemaName">
							<xsl:with-param name="currentVariable">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
							<xsl:with-param name="currentVariableType">
								<xsl:value-of select="@type"/>
							</xsl:with-param>
							<xsl:with-param name="xsd">
								<xsl:value-of select="@xsd"/>
							</xsl:with-param>
							<xsl:with-param name="parentName">
								<xsl:value-of select="@parentName"/>
							</xsl:with-param>						
						</xsl:call-template>
						<xsl:if test="@type='element'">								
							<xsl:choose>
								<xsl:when test="@parentName != ''">
									<xsl:choose>
										<xsl:when test="contains(@parentName,'.model')">
											<xsl:text>/groups/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/complexTypes/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>	
									<xsl:value-of select="@parentName"/>
									<xsl:text>/</xsl:text> 
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>/elements/</xsl:text> 
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="@type='complexType'">
							<xsl:text>/complexTypes/</xsl:text> 								
						</xsl:if>
						<xsl:if test="@type='group'">
							<xsl:text>/groups/</xsl:text> 								
						</xsl:if>
						<!--<xsl:text>/doc-files/</xsl:text> 
						<xsl:value-of select="@type"/>
						<xsl:text>_</xsl:text> -->
						<xsl:value-of select="@name"/>
						<xsl:text>.png</xsl:text> 
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:copy-of select="@width|@height"/>
					click here for <xsl:value-of select="@name"/>
				</a>			
			</xsl:when>
			<!--LINKMOUSEOVER-->
			<xsl:when test="@display='linkmouseover'">
						<a>
							<xsl:attribute name="class">
								<xsl:text>thumbnail</xsl:text>	
							</xsl:attribute>
							<xsl:attribute name="href">
								<xsl:text>schemaDocumentation/schemas/</xsl:text> 
								<xsl:call-template name="schemaName">
									<xsl:with-param name="currentVariable">
										<xsl:value-of select="@name"/>
									</xsl:with-param>
									<xsl:with-param name="currentVariableType">
										<xsl:value-of select="@type"/>
									</xsl:with-param>
									<xsl:with-param name="xsd">
										<xsl:value-of select="@xsd"/>
									</xsl:with-param>
									<xsl:with-param name="parentName">
										<xsl:value-of select="@parentName"/>
									</xsl:with-param>						
								</xsl:call-template>
								<xsl:if test="@type='element'">								
									<xsl:choose>
										<xsl:when test="@parentName != ''">
											<xsl:choose>
												<xsl:when test="contains(@parentName,'.model')">
													<xsl:text>/groups/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/complexTypes/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>	
											<xsl:value-of select="@parentName"/>
											<xsl:text>/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/elements/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="@type='complexType'">
									<xsl:text>/complexTypes/</xsl:text> 								
								</xsl:if>
								<xsl:if test="@type='group'">
									<xsl:text>/groups/</xsl:text> 								
								</xsl:if>
								<!--<xsl:text>/</xsl:text> 
								<xsl:value-of select="@type"/>
								<xsl:text>s/</xsl:text> -->
								<xsl:value-of select="@name" ></xsl:value-of>
								<xsl:text>.html</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="alt">
								<xsl:text>schemaDocumentation/schemas/</xsl:text> 
								<xsl:call-template name="schemaName">
									<xsl:with-param name="currentVariable">
										<xsl:value-of select="@name"/>
									</xsl:with-param>
									<xsl:with-param name="currentVariableType">
										<xsl:value-of select="@type"/>
									</xsl:with-param>
									<xsl:with-param name="xsd">
										<xsl:value-of select="@xsd"/>
									</xsl:with-param>
									<xsl:with-param name="parentName">
										<xsl:value-of select="@parentName"/>
									</xsl:with-param>						
								</xsl:call-template>
								<xsl:if test="@type='element'">								
									<xsl:choose>
										<xsl:when test="@parentName != ''">
											<xsl:choose>
												<xsl:when test="contains(@parentName,'.model')">
													<xsl:text>/groups/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/complexTypes/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>	
											<xsl:value-of select="@parentName"/>
											<xsl:text>/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/elements/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="@type='complexType'">
									<xsl:text>/complexTypes/</xsl:text> 								
								</xsl:if>
								<xsl:if test="@type='group'">
									<xsl:text>/groups/</xsl:text> 								
								</xsl:if>
								<!--<xsl:text>/</xsl:text> 
								<xsl:value-of select="@type"/>
								<xsl:text>s/</xsl:text> -->
								<xsl:value-of select="@name" ></xsl:value-of>
								<xsl:text>.html</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="target">
								<xsl:text>_blank</xsl:text>
							</xsl:attribute>
							<xsl:copy-of select="@width|@height"/>
							<xsl:value-of select="@name"/>
							<span>
								<img>
									<xsl:attribute name="src">
										<xsl:text>schemaDocumentation/schemas/</xsl:text> 
										<xsl:call-template name="schemaName">
											<xsl:with-param name="currentVariable">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
											<xsl:with-param name="currentVariableType">
												<xsl:value-of select="@type"/>
											</xsl:with-param>
											<xsl:with-param name="xsd">
												<xsl:value-of select="@xsd"/>
											</xsl:with-param>
											<xsl:with-param name="parentName">
												<xsl:value-of select="@parentName"/>
											</xsl:with-param>						
										</xsl:call-template>
										<xsl:if test="@type='element'">								
											<xsl:choose>
												<xsl:when test="@parentName != ''">
													<xsl:choose>
														<xsl:when test="contains(@parentName,'.model')">
															<xsl:text>/groups/</xsl:text> 
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>/complexTypes/</xsl:text> 
														</xsl:otherwise>
													</xsl:choose>	
													<xsl:value-of select="@parentName"/>
													<xsl:text>/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/elements/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="@type='complexType'">
											<xsl:text>/complexTypes/</xsl:text> 								
										</xsl:if>
										<xsl:if test="@type='group'">
											<xsl:text>/groups/</xsl:text> 								
										</xsl:if>
										<xsl:value-of select="@name"/>
										<xsl:text>.png</xsl:text>
									</xsl:attribute>
									<xsl:attribute name="onerror">
										<xsl:text>this.src='images/notavailable.jpg'</xsl:text>
									</xsl:attribute>
									<xsl:copy-of select="@width|@height"/>
								</img>  						
							</span>
						</a>
				
			</xsl:when>
			<!--DOCUMENTATION-->
			<xsl:when test="@display='documentation'">
				<a >
					<xsl:attribute name="href">
						<xsl:text>schemaDocumentation/schemas/</xsl:text> 
						<xsl:call-template name="schemaName">
							<xsl:with-param name="currentVariable">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
							<xsl:with-param name="currentVariableType">
								<xsl:value-of select="@type"/>
							</xsl:with-param>
							<xsl:with-param name="xsd">
								<xsl:value-of select="@xsd"/>
							</xsl:with-param>
							<xsl:with-param name="parentName">
								<xsl:value-of select="@parentName"/>
							</xsl:with-param>						
						</xsl:call-template>
						<xsl:if test="@type='element'">								
							<xsl:choose>
								<xsl:when test="@parentName != ''">
									<xsl:choose>
										<xsl:when test="contains(@parentName,'.model')">
											<xsl:text>/groups/</xsl:text> 
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>/complexTypes/</xsl:text> 
										</xsl:otherwise>
									</xsl:choose>	
									<xsl:value-of select="@parentName"/>
									<xsl:text>/</xsl:text> 
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>/elements/</xsl:text> 
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="@type='complexType'">
							<xsl:text>/complexTypes/</xsl:text> 								
						</xsl:if>
						<xsl:if test="@type='group'">
							<xsl:text>/groups/</xsl:text> 								
						</xsl:if>
						<xsl:value-of select="@name" ></xsl:value-of>
						<xsl:text>.html</xsl:text> 
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="onMouseOver">
						<xsl:text>window.status='Click here to go to XML Schema'; return true</xsl:text>
					</xsl:attribute>
					<xsl:copy-of select="@width|@height"/>
					<xsl:value-of select="@name"/>
				</a>
			</xsl:when>
			<!--POPUPMOUSEOVER-->
			<xsl:when test="@display='popupmouseover'">			
				<!-- show linkmouseover and info icon for different views-->
				<p>
					<a href="javascript:void(0)" onclick = "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'">
						<img src="red-info.png" width="20" height="20"></img>						
					</a>
					<div class="gallerycontainer" rel="lightbox[slide]">
						<!--REPORTING VIEW -->
						<a class="thumbnail" href="#thumb">
							Reporting
							<span>
								<img>
									<xsl:attribute name="src">
									<xsl:text>schemaDocumentation/schemas/</xsl:text> 
									<xsl:call-template name="schemaName">
										<xsl:with-param name="currentVariable">
											<xsl:value-of select="@name"/>
										</xsl:with-param>
										<xsl:with-param name="currentVariableType">
											<xsl:value-of select="@type"/>
										</xsl:with-param>
										<xsl:with-param name="xsd">
											<xsl:value-of select="@xsd"/>
										</xsl:with-param>
										<xsl:with-param name="parentName">
											<xsl:value-of select="@parentName"/>
										</xsl:with-param>						
									</xsl:call-template>
									
									<xsl:if test="@type='element'">								
										<xsl:choose>
											<xsl:when test="@parentName != ''">
												<xsl:choose>
													<xsl:when test="contains(@parentName,'.model')">
														<xsl:text>/groups/</xsl:text> 
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>/complexTypes/</xsl:text> 
													</xsl:otherwise>
												</xsl:choose>	
												<xsl:value-of select="@parentName"/>
												<xsl:text>/</xsl:text> 
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>/elements/</xsl:text> 
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="@type='complexType'">
										<xsl:text>/complexTypes/</xsl:text> 								
									</xsl:if>
									<xsl:if test="@type='group'">
										<xsl:text>/groups/</xsl:text> 								
									</xsl:if>
									<xsl:value-of select="@name"/>
									<xsl:text>.png</xsl:text>
								</xsl:attribute>
								</img>
								<br/>Reporting View
							</span>
						</a>
						<br/><br/>
						<!--CONFIRMATION VIEW -->
						<a class="thumbnail" href="#thumb">
							Confirmation
							<span>
								<img>
									<xsl:attribute name="src">
										<xsl:text>schemaDocumentation/schemas/</xsl:text> 
										<xsl:call-template name="schemaName">
											<xsl:with-param name="currentVariable">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
											<xsl:with-param name="currentVariableType">
												<xsl:value-of select="@type"/>
											</xsl:with-param>
											<xsl:with-param name="xsd">
												<xsl:value-of select="@xsd"/>
											</xsl:with-param>
											<xsl:with-param name="parentName">
												<xsl:value-of select="@parentName"/>
											</xsl:with-param>						
										</xsl:call-template>
										
										<xsl:if test="@type='element'">								
											<xsl:choose>
												<xsl:when test="@parentName != ''">
													<xsl:choose>
														<xsl:when test="contains(@parentName,'.model')">
															<xsl:text>/groups/</xsl:text> 
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>/complexTypes/</xsl:text> 
														</xsl:otherwise>
													</xsl:choose>	
													<xsl:value-of select="@parentName"/>
													<xsl:text>/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/elements/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="@type='complexType'">
											<xsl:text>/complexTypes/</xsl:text> 								
										</xsl:if>
										<xsl:if test="@type='group'">
											<xsl:text>/groups/</xsl:text> 								
										</xsl:if>
										<xsl:value-of select="@name"/>
										<xsl:text>.png</xsl:text>
									</xsl:attribute>
								</img>
								<br/>Confirmation View
							</span>
						</a>
						<br/><br/>
						<!--RECORDKEEPING VIEW -->
						<a class="thumbnail" href="#thumb">
							Recordkeeping
							<span>
								<img>
									<xsl:attribute name="src">
										<xsl:text>schemaDocumentation/schemas/</xsl:text> 
										<xsl:call-template name="schemaName">
											<xsl:with-param name="currentVariable">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
											<xsl:with-param name="currentVariableType">
												<xsl:value-of select="@type"/>
											</xsl:with-param>
											<xsl:with-param name="xsd">
												<xsl:value-of select="@xsd"/>
											</xsl:with-param>
											<xsl:with-param name="parentName">
												<xsl:value-of select="@parentName"/>
											</xsl:with-param>						
										</xsl:call-template>
										
										<xsl:if test="@type='element'">								
											<xsl:choose>
												<xsl:when test="@parentName != ''">
													<xsl:choose>
														<xsl:when test="contains(@parentName,'.model')">
															<xsl:text>/groups/</xsl:text> 
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>/complexTypes/</xsl:text> 
														</xsl:otherwise>
													</xsl:choose>	
													<xsl:value-of select="@parentName"/>
													<xsl:text>/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/elements/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="@type='complexType'">
											<xsl:text>/complexTypes/</xsl:text> 								
										</xsl:if>
										<xsl:if test="@type='group'">
											<xsl:text>/groups/</xsl:text> 								
										</xsl:if>
										<xsl:value-of select="@name"/>
										<xsl:text>.png</xsl:text>
									</xsl:attribute>
								</img>
								<br/>Recordkeeping View
							</span>
						</a>
						<br/><br/>
						<!--TRANSPARENCY VIEW -->
						<a class="thumbnail" href="#thumb">
							Transparency
							<span>
								<img>
									<xsl:attribute name="src">
										<xsl:text>schemaDocumentation/schemas/</xsl:text> 
										<xsl:call-template name="schemaName">
											<xsl:with-param name="currentVariable">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
											<xsl:with-param name="currentVariableType">
												<xsl:value-of select="@type"/>
											</xsl:with-param>
											<xsl:with-param name="xsd">
												<xsl:value-of select="@xsd"/>
											</xsl:with-param>
											<xsl:with-param name="parentName">
												<xsl:value-of select="@parentName"/>
											</xsl:with-param>						
										</xsl:call-template>
										
										<xsl:if test="@type='element'">								
											<xsl:choose>
												<xsl:when test="@parentName != ''">
													<xsl:choose>
														<xsl:when test="contains(@parentName,'.model')">
															<xsl:text>/groups/</xsl:text> 
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>/complexTypes/</xsl:text> 
														</xsl:otherwise>
													</xsl:choose>	
													<xsl:value-of select="@parentName"/>
													<xsl:text>/</xsl:text> 
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>/elements/</xsl:text> 
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>
										<xsl:if test="@type='complexType'">
											<xsl:text>/complexTypes/</xsl:text> 								
										</xsl:if>
										<xsl:if test="@type='group'">
											<xsl:text>/groups/</xsl:text> 								
										</xsl:if>
										<xsl:value-of select="@name"/>
										<xsl:text>.png</xsl:text>
									</xsl:attribute>
								</img>
								<br/>Transparency View
							</span>
						</a>
						<br/><br/>
					</div>
					
				</p>
			
			</xsl:when>
			<!--ENLARGE on MOUSE OVER -->
        	<xsl:when test="@display='enlargeonmouseclick'">
        		<p>
        			<a>
        				<xsl:attribute name="href">
        					<xsl:text>schemaDocumentation/schemas/</xsl:text> 
        					<xsl:call-template name="schemaName">
        						<xsl:with-param name="currentVariable">
        							<xsl:value-of select="@name"/>
        						</xsl:with-param>
        						<xsl:with-param name="currentVariableType">
        							<xsl:value-of select="@type"/>
        						</xsl:with-param>
        						<xsl:with-param name="xsd">
        							<xsl:value-of select="@xsd"/>
        						</xsl:with-param>
        						<xsl:with-param name="parentName">
        							<xsl:value-of select="@parentName"/>
        						</xsl:with-param>						
        					</xsl:call-template>
        					
        					<xsl:if test="@type='element'">								
        						<xsl:choose>
        							<xsl:when test="@parentName != ''">
        								<xsl:choose>
        									<xsl:when test="contains(@parentName,'.model')">
        										<xsl:text>/groups/</xsl:text> 
        									</xsl:when>
        									<xsl:otherwise>
        										<xsl:text>/complexTypes/</xsl:text> 
        									</xsl:otherwise>
        								</xsl:choose>	
        								<xsl:value-of select="@parentName"/>
        								<xsl:text>/</xsl:text> 
        							</xsl:when>
        							<xsl:otherwise>
        								<xsl:text>/elements/</xsl:text> 
        							</xsl:otherwise>
        						</xsl:choose>
        					</xsl:if>
        					<xsl:if test="@type='complexType'">
        						<xsl:text>/complexTypes/</xsl:text> 								
        					</xsl:if>
        					<xsl:if test="@type='simpleType'">
        						<xsl:text>/simpleType/</xsl:text> 	
        					</xsl:if>
        					<xsl:if test="@type='group'">
        						<xsl:text>/groups/</xsl:text> 								
        					</xsl:if>
        					<xsl:value-of select="@name"/>
        					<xsl:text>.png</xsl:text>
        				</xsl:attribute>		
        		<img>
        			<xsl:attribute name="src">
        				<xsl:text>schemaDocumentation/schemas/</xsl:text> 
        				<xsl:call-template name="schemaName">
        					<xsl:with-param name="currentVariable">
        						<xsl:value-of select="@name"/>
        					</xsl:with-param>
        					<xsl:with-param name="currentVariableType">
        						<xsl:value-of select="@type"/>
        					</xsl:with-param>
        					<xsl:with-param name="xsd">
        						<xsl:value-of select="@xsd"/>
        					</xsl:with-param>
        					<xsl:with-param name="parentName">
        						<xsl:value-of select="@parentName"/>
        					</xsl:with-param>						
        				</xsl:call-template>
        				
        				<xsl:if test="@type='element'">								
        					<xsl:choose>
        						<xsl:when test="@parentName != ''">
        							<xsl:choose>
        								<xsl:when test="contains(@parentName,'.model')">
        									<xsl:text>/groups/</xsl:text> 
        								</xsl:when>
        								<xsl:otherwise>
        									<xsl:text>/complexTypes/</xsl:text> 
        								</xsl:otherwise>
        							</xsl:choose>	
        							<xsl:value-of select="@parentName"/>
        							<xsl:text>/</xsl:text> 
        						</xsl:when>
        						<xsl:otherwise>
        							<xsl:text>/elements/</xsl:text> 
        						</xsl:otherwise>
        					</xsl:choose>
        				</xsl:if>
        				<xsl:if test="@type='complexType'">
        					<xsl:text>/complexTypes/</xsl:text> 								
        				</xsl:if>
        				<xsl:if test="@type='group'">
        					<xsl:text>/groups/</xsl:text> 								
        				</xsl:if>
        				<xsl:value-of select="@name"/>
        				<xsl:text>.png</xsl:text>
        			</xsl:attribute>
        			<xsl:attribute name="alt">
        				<xsl:text>schemaDocumentation/schemas/</xsl:text> 
        				<xsl:call-template name="schemaName">
        					<xsl:with-param name="currentVariable">
        						<xsl:value-of select="@name"/>
        					</xsl:with-param>
        					<xsl:with-param name="currentVariableType">
        						<xsl:value-of select="@type"/>
        					</xsl:with-param>
        					<xsl:with-param name="xsd">
        						<xsl:value-of select="@xsd"/>
        					</xsl:with-param>
        					<xsl:with-param name="parentName">
        						<xsl:value-of select="@parentName"/>
        					</xsl:with-param>						
        				</xsl:call-template>
        				<xsl:if test="@type='element'">								
        					<xsl:choose>
        						<xsl:when test="@parentName != ''">
        							<xsl:choose>
        								<xsl:when test="contains(@parentName,'.model')">
        									<xsl:text>/groups/</xsl:text> 
        								</xsl:when>
        								<xsl:otherwise>
        									<xsl:text>/complexTypes/</xsl:text> 
        								</xsl:otherwise>
        							</xsl:choose>	
        							<xsl:value-of select="@parentName"/>
        							<xsl:text>/</xsl:text> 
        						</xsl:when>
        						<xsl:otherwise>
        							<xsl:text>/elements/</xsl:text> 
        						</xsl:otherwise>
        					</xsl:choose>
        				</xsl:if>
        				<xsl:if test="@type='complexType'">
        					<xsl:text>/complexTypes/</xsl:text> 								
        				</xsl:if>
        				<xsl:if test="@type='group'">
        					<xsl:text>/groups/</xsl:text> 								
        				</xsl:if>

        				<xsl:value-of select="@name"/>
        				<xsl:text>.png</xsl:text>
        			</xsl:attribute>
        			<xsl:copy-of select="@width|@height"/>
        	  		</img>	
        			</a>
        		</p>
        	</xsl:when>
        	
        	<xsl:otherwise>
				<a href="{@imageSource}">
					<img src="{@imageSource}" alt="{@imageSource}" class="image">
						<xsl:copy-of select="@width|@height"/>
					</img>
				
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <!--End XMLSpy Documentation generation-->
	<!-- Table of Contents Templates -->
	<xsl:template match="section" mode="toc">
		<xsl:param name="level"/>
		<xsl:param name="sectionName"/>
		<xsl:if test="not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))">
		<xsl:choose>
			<xsl:when test="$level=1">
				<xsl:call-template name="tocHeading1">
					<xsl:with-param name="name" select="@name"/>
					<xsl:with-param name="sectionName" select="$sectionName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$level=2">
				<xsl:call-template name="tocHeading2">
					<xsl:with-param name="name" select="@name"/>
					<xsl:with-param name="sectionName" select="$sectionName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$level=3">
				<xsl:call-template name="tocHeading3">
					<xsl:with-param name="name" select="@name"/>
					<xsl:with-param name="sectionName" select="$sectionName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="tocHeading4">
					<xsl:with-param name="name" select="@name"/>
					<xsl:with-param name="sectionName" select="$sectionName"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="section[not(@view) or ($view='master') or (not(contains(@view, $notview)) and (contains(@view, '!') or contains(@view, $view)))]">
			<xsl:apply-templates select="." mode="toc">
				<xsl:with-param name="level" select="number($level)+1"/>
				<xsl:with-param name="sectionName" select="concat($sectionName,'.',position())"/>
			</xsl:apply-templates>
		</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="tocHeading1">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
		<b>
			<xsl:value-of select="$sectionName"/>
			<xsl:value-of select="$space"/>
			<a href="#s{$sectionName}">
				<xsl:value-of select="$name"/>
			</a>
		</b>
		<br/>
	</xsl:template>
	<xsl:template name="tocHeading2">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
		<b>
			<xsl:value-of select="$sectionName"/>
			<xsl:value-of select="$space"/>
			<a href="#s{$sectionName}">
				<xsl:value-of select="$name"/>
			</a>
		</b>
		<br/>
	</xsl:template>
	<xsl:template name="tocHeading3">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
		<b>
			<xsl:value-of select="$sectionName"/>
			<xsl:value-of select="$space"/>
			<a href="#s{$sectionName}">
				<xsl:value-of select="$name"/>
			</a>
		</b>
		<br/>
	</xsl:template>
	<xsl:template name="tocHeading4">
		<xsl:param name="name"/>
		<xsl:param name="sectionName"/>
		<xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
		<b>
			<xsl:value-of select="$sectionName"/>
			<xsl:value-of select="$space"/>
			<a href="#s{$sectionName}">
				<xsl:value-of select="$name"/>
			</a>
		</b>
		<br/>
	</xsl:template>
</xsl:transform>
