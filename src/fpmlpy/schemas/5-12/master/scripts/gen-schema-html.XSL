<?xml version="1.0" encoding="iso-8859-1" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must use XML Turbo to generate the schemaDoc images and run
	the 'fetch-svg.bat' file to copy them to the svg directory
 -->

<!-- TODO: attributes -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:drw="xalan://com.ibm.fpml.xslt.Diagram" 
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format" 
	xmlns:common="http://exslt.org/common" 
	xmlns:view="http://www.fpml.org/views" 
	exclude-result-prefixes="xsl xsd drw fmt">
	<!-- templates shared with xml/pdf version -->
	<xsl:import href="gen-schema-shared.xsl"/>

	<xsl:variable name="dy" select="substring-before ($date,'/')"/>
	<xsl:variable name="mn" select="substring-before (substring-after ($date,'/'),'/')"/>
	<xsl:variable name="yr" select="substring-after (substring-after ($date, '/'),'/')"/>
	<xsl:variable name="month">
		<xsl:choose>
			<xsl:when test="$mn = 1">January</xsl:when>
			<xsl:when test="$mn = 2">February</xsl:when>
			<xsl:when test="$mn = 3">March</xsl:when>
			<xsl:when test="$mn = 4">April</xsl:when>
			<xsl:when test="$mn = 5">May</xsl:when>
			<xsl:when test="$mn = 6">June</xsl:when>
			<xsl:when test="$mn = 7">July</xsl:when>
			<xsl:when test="$mn = 8">August</xsl:when>
			<xsl:when test="$mn = 9">September</xsl:when>
			<xsl:when test="$mn = 10">October</xsl:when>
			<xsl:when test="$mn = 11">November</xsl:when>
			<xsl:when test="$mn = 12">December</xsl:when>
			<xsl:otherwise>Error</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- The main template -->
	<xsl:template match="/data">
		<html xml:lang="en">
			<head>
				<xsl:call-template name="doPreamble"/>
			</head>
			<body>
				<xsl:call-template name="doTitlePage"/>
				<xsl:call-template name="doContents"/>
				<xsl:call-template name="doBody"/>
			</body>
		</html>
	</xsl:template>

	<!-- Generate the HTML header and embedded styles -->
	<xsl:template name="doPreamble">
		<title>FpML - <xsl:value-of select="$pretty.area"/> Component Definitions <xsl:call-template name="view.label"/></title>
		<link type="text/css" rel="stylesheet" href="fpml.css" media="screen,print"/>
	</xsl:template>
	<!-- Generate the title page -->
	<xsl:template name="doTitlePage">
		<p>
			<img src="images/fpml-logo.gif" width="208" height="107"/>
		</p>
		<xsl:variable name="verfile" select="document('../src/fpml-version.xml')/wrapper"/>
		<h1>
			<xsl:value-of select="$verfile/@title"/>
			<xsl:call-template name="view.label"/>
		</h1>
		<h2>
			<xsl:value-of select="$verfile/@date"/>
		</h2>
		<h2><xsl:value-of select="$pretty.area"/> Component Definitions</h2>
		<h3>
			<i>Version: <xsl:value-of select="$verfile/@version"/></i>
		</h3>
		<h3>This Version:</h3>
		<p>
			<blockquote>
				<a href="{$verfile/version/@uri}" target="_blank" title="Link opens in new window.">
					<xsl:value-of select="$verfile/version/@uri"/>
				</a>
			</blockquote>
		</p>
		<h3>Latest Version:</h3>
		<p>
			<blockquote>
				<a href="{$verfile/version/latestVersion/@url}" target="_blank" title="Link opens in new window.">
					<xsl:value-of select="$verfile/version/latestVersion/@uri"/>
				</a>
			</blockquote>
		</p>
		<h3>Previous Version:</h3>
		<p>
			<blockquote>
				<a href="{$verfile/version/previousVersion/@url}" target="_blank" title="Link opens in new window.">
					<xsl:value-of select="$verfile/version/previousVersion/@uri"/>
				</a>
			</blockquote>
		</p>
		<h3>Errata for this Version:</h3>
		<p>
			<blockquote>
				<a href="{$verfile/version/errataForThisVersion/@url}">
					<xsl:value-of select="$verfile/version/errataForThisVersion/@uri"/>
				</a>
			</blockquote>
		</p>
		<p> Document built: <xsl:value-of select="concat($builddate, ' ', $buildtime)"/>
		</p>
		<!-- Copyright -->
		<p><br/> Copyright (c) 1999 - 2014 by INTERNATIONAL SWAPS AND DERIVATIVES ASSOCIATION, INC.<br/> Financial Products Markup Language is subject to the FpML public license<br/> A copy of this license is available at <a href="http://www.fpml.org/documents/license.html" target="_blank" title="Link opens in new window.">http://www.fpml.org/documents/license.html</a>
		</p>
		<br/>
		<br/>
		<p>
			<xsl:value-of select="$verfile/version/disclaimer/paragraph"/>
		</p>
	</xsl:template>
	<!-- Generate the table of contents -->
	<xsl:template name="doContents">
		<div id="contents" style="page-break-before: always">
			<hr/>
			<h1>Contents</h1>
			<dl>
				<!-- global simple types -->
				<xsl:call-template name="toc">
					<xsl:with-param name="title" select="'Global Simple Types'"/>
					<xsl:with-param name="contents" select="$simpleTypes"/>
					<xsl:with-param name="id" select="'Simple'"/>
				</xsl:call-template>
				<!-- global complex types -->
				<xsl:call-template name="toc">
					<xsl:with-param name="title" select="'Global Complex Types'"/>
					<xsl:with-param name="contents" select="$complexTypes"/>
					<xsl:with-param name="id" select="'Complex'"/>
				</xsl:call-template>
				
				<!-- global elements -->
				<xsl:call-template name="toc">
					<xsl:with-param name="title" select="'Global Elements'"/>
					<xsl:with-param name="contents" select="$elements"/>
					<xsl:with-param name="id" select="'GlobalElements'"/>
				</xsl:call-template>
				<!-- groups -->
				<xsl:call-template name="toc">
					<xsl:with-param name="title" select="'Groups'"/>
					<xsl:with-param name="contents" select="$groups"/>
					<xsl:with-param name="id" select="'Groups'"/>
				</xsl:call-template>
				<dd>
					<b>
						<a href="#FullSchema">Schema Listing</a>
					</b>
				</dd>
			</dl>
		</div>
	</xsl:template>
	<!-- do table of contents listing for one set of components -->
	<xsl:template name="toc">
		<xsl:param name="title"/>
		<xsl:param name="contents"/>
		<xsl:param name="id"/>
		<dd>
			<b>
				<a href="#{$id}">
					<xsl:value-of select="$title"/>
				</a>
			</b>
			<dl>
				<xsl:apply-templates select="$contents" mode="tocEntry">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			</dl>
		</dd>
		<br/>
	</xsl:template>
	<!-- links, targets,  and prefixes -->
	<xsl:template match="xsd:*" mode="tocEntry">
		<dd>
			<xsl:apply-templates select="." mode="link"/>
		</dd>
	</xsl:template>
	<xsl:template match="xsd:*" mode="target">
		<xsl:variable name="prefix">
			<xsl:apply-templates select="." mode="prefix"/>
		</xsl:variable>
		<a name="{$prefix}_{@name}">
			<xsl:value-of select="@name"/>
		</a>
	</xsl:template>
	<xsl:template match="xsd:*" mode="link">
		<xsl:variable name="prefix">
			<xsl:apply-templates select="." mode="prefix"/>
		</xsl:variable>
		<a href="#{$prefix}_{@name}">
			<xsl:value-of select="@name"/>
		</a>
	</xsl:template>
	<xsl:template match="xsd:element" mode="prefix">Element</xsl:template>
	<xsl:template match="xsd:complexType" mode="prefix">Complex</xsl:template>
	<xsl:template match="xsd:simpleType" mode="prefix">Simple</xsl:template>
	<xsl:template match="xsd:group" mode="prefix">Group</xsl:template>
	<xsl:template match="xsd:*" priority="-1" mode="prefix">Error</xsl:template>
	<!-- Generate view applicability documentation -->
	<xsl:template name="doApplicability">
		<xsl:variable name="view-specific" select="$subschema/xsd:schema/xsd:annotation/xsd:appinfo/view:*"/>
		<div style="page-break-before: always">
			<hr/>
			<h1>
				<a>Applicability to views:</a>
			</h1>
			<xsl:apply-templates select="$view-specific" mode="applicability" />
			<xsl:if test="not($view-specific)">
				<p>This sub-schema is used in all views. </p>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template mode="applicability" match="view:exclusive">
		<p>This sub-schema is used only in the "<xsl:value-of select="@view"/>" view.</p>
	</xsl:template>

	<xsl:template mode="applicability" match="view:override[@skip='true']">
		<p>This sub-schema is not used in the "<xsl:value-of select="@view"/>" view.</p>
	</xsl:template>

	<!-- Generate global component documentation -->
	<xsl:template name="doComponentSection">
		<xsl:param name="components" />
		<xsl:param name="title" />
		<xsl:param name="description" />
		<xsl:param name="anchor" />
		<div id="{$anchor}" style="page-break-before: always">
			<hr/>
			<h1>
				<a name="{$anchor}">Global <xsl:value-of select="$title"/></a>
			</h1>
			<xsl:choose>
				<xsl:when test="count($components) != 0">
					<xsl:for-each select="$components">
						<xsl:sort select="@name"/>

						<xsl:apply-templates mode="documentComponent" select="."/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<p>The schema does not contain any global <xsl:value-of select="$description"/>.</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template mode="componentApplicability" match="view:override[@skip='true']">
		<p>This component is not applicable in the "<xsl:value-of select="@view"/>" view.</p>
	</xsl:template>

	<xsl:template mode="documentComponent" match="node()">
		<xsl:call-template name="titleAndDescription"/>
		<xsl:if test="not(local-name(.)='simpleType')">
			<h3>
				<i>Figure:</i>
			</h3>
			<xsl:apply-templates mode="findImage" select="."/>
		</xsl:if>
		<h3>
			<i>Contents:</i>
		</h3>
		<xsl:apply-templates mode="describeComponent" select="."/>
		<h3>
			<i>Used by:</i>
		</h3>
		<ul>
			<xsl:apply-templates mode="usedBy" select="."/>
		</ul>
		<xsl:apply-templates mode="otherDocumentation" select="."/>

		<xsl:call-template name="schemaFragment"/>
	</xsl:template>


	<xsl:template mode="otherDocumentation" match="xsd:element">
		<!-- substitution -->
		<xsl:variable name="starget" select="@name"/>
		<xsl:variable name="subst" select="$allElements[@substitutionGroup = $starget]"/>
		<xsl:if test="$subst">
			<h3>
				<i>Substituted by:</i>
			</h3>
			<ul>
				<xsl:apply-templates select="$subst" mode="generateUse">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template mode="derivedFrom" match="xsd:extension|xsd:restriction">
		<xsl:variable name="base" select="@base"/>
		<xsl:variable name="baseType" select="$allTypes[@name=$base]"/>
		<xsl:if test="$baseType">
			<h3>
				<i>
					<xsl:apply-templates select="." mode="derivationLabel"/>
				</i>
			</h3>
			<ul>
				<li>
					<xsl:apply-templates mode="link" select="$baseType"/>
				</li>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template name="derivedTypes">
		<xsl:variable name="dtarget" select="@name"/>
		<xsl:variable name="derivedTypes" select="$allTypes[*/*/@base = $dtarget]"/>
		<xsl:if test="$derivedTypes">
			<h3>
				<i>Derived Types:</i>
			</h3>
			<ul>
				<xsl:apply-templates mode="generateUse" select="$derivedTypes">
					<xsl:sort select="@name"/>
				</xsl:apply-templates>
			</ul>
		</xsl:if>
	</xsl:template>
	<!-- shared documentation utilities -->
	<!-- component section title and component description -->
	<xsl:template name="titleAndDescription">
		<xsl:if test="position() != 1">
			<hr style="page-break-before: always"/>
		</xsl:if>
		<h2>
			<xsl:apply-templates select="." mode="target"/>
		</h2>
		<h3>
			<i>Description:</i>
		</h3>
		<p>
			<xsl:value-of select="xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
			<xsl:apply-templates mode="componentApplicability" select="xsd:*"/>
		</p>
	</xsl:template>
	<xsl:template name="schemaFragment">
		<h3>
			<i>Schema Fragment:</i>
		</h3>
		<pre>
	<xsl:value-of select="fmt:format(.)"/>
	</pre>
	</xsl:template>
	<!-- Format the entire schema -->
	<xsl:template name="dumpSchema">
		<div id="XMLSchema" style="page-break-before: always">
			<hr/>
			<h1>
				<a name="FullSchema">Full XML Schema</a>
			</h1>
			<pre>
<xsl:value-of select="fmt:format ($subschema/xsd:schema)"/>
</pre>
		</div>
	</xsl:template>
	<xsl:template mode="generateUse" match="node()">
		<li>
			<xsl:apply-templates mode="linkToComponent" select="."/>
		</li>
	</xsl:template>
	<!-- Generates a link for a local component -->
	<xsl:template mode="linkToComponent" match="node()">
		<xsl:variable name="global" select="ancestor::*[local-name(..)='schema']"/>
		<xsl:apply-templates mode="linkToComponent" select="$global">
			<xsl:with-param name="name" select="concat($global/@name,'/',@name)"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- Generates a link for a global component -->
	<xsl:template mode="linkToComponent" match="node()[local-name(..)='schema']">
		<xsl:param name="name" select="@name"/>
		<xsl:param name="elem" select="."/>
		<xsl:variable name="prefix">
			<xsl:apply-templates select="$elem" mode="prefix"/>
		</xsl:variable>
		<xsl:variable name="target" select="concat($prefix, '_', $elem/@name)"/>
		<xsl:variable name="dest" select="ancestor::file/@name"/>
		<xsl:variable name="html">
			<xsl:if test="$schema != $dest">
				<xsl:value-of select="concat(substring-before($dest,'.xsd'),'.html')"/>
			</xsl:if>
		</xsl:variable>
		<a href="{$html}#{$target}">
			<xsl:value-of select="$name"/>
		</a>
	</xsl:template>
	<!-- Generate a link to a type -->
	<xsl:template name="linkToType" mode="linkToType" match="node()">
		<xsl:param name="name" select="@name"/>
		<xsl:variable name="type" select="$allTypes[@name=$name]"/>
		<xsl:choose>
			<xsl:when test="$type">
				<xsl:apply-templates select="$type" mode="linkToComponent"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Describe an element's content model -->
	<xsl:template mode="describeComponent" match="xsd:element">
		<xsl:variable name="type" select="@type"/>
		<xsl:choose>
			<xsl:when test="$type">
				<xsl:variable name="isComplex" select="boolean($allComplexTypes [@name=$type])"/>
				<xsl:variable name="dest">
					<xsl:choose>
						<xsl:when test="$isComplex">
							<xsl:value-of select="$allComplexTypes[@name=$type]/ancestor::file/@name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$allSimpleTypes [@name=$type]/ancestor::file/@name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="html">
					<xsl:if test="$schema != $dest">
						<xsl:value-of select="concat(substring-before($dest,'.xsd'),'.html')"/>
					</xsl:if>
				</xsl:variable>
				<p>Element <xsl:value-of select="@name"/> is defined by the <xsl:choose>
						<xsl:when test="$isComplex"> complex type <xsl:call-template name="linkToType">
								<xsl:with-param name="name" select="@type"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise> simple type <xsl:call-template name="linkToType">
								<xsl:with-param name="name" select="@type"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p>Element <xsl:value-of select="@name"/> is defined locally as:</p>
				<ul>
					<xsl:apply-templates select="xsd:*" mode="describeComponent"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- these templates are used to describe a component and its contents -->
	<!-- #### remove |xsd:sequence if match below is used #### -->
	<!-- #### Match to xsd:sequence on top level (currently unused) ####	
<xsl:template mode="describeComponent" match="xsd:sequence">
	<xsl:apply-templates select="*" mode="describeSequence"/>
	<xsl:apply-templates select="*" mode="docAttributes"/>
</xsl:template>	
 -->
	<xsl:template mode="describeComponent" match="xsd:enumeration">
		<table border="1">
			<tr>
				<td>Value</td>
				<td>Source</td>
				<td>Description</td>
			</tr>
			<xsl:call-template name="describeEnum"/>
		</table>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:element">
		<p>
			<xsl:call-template name="describeElement"/>
		</p>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<!-- Describe an extension -->
	<xsl:template name="describeExtension">
		<p><b>Inherited element(s):</b> (This definition inherits the content defined by the type <xsl:call-template name="linkToType">
				<xsl:with-param name="name" select="@base"/>
			</xsl:call-template>)</p>
		<ul>
			<li>
				<xsl:variable name="base" select="@base"/>
				<xsl:choose>
					<xsl:when test="$allComplexTypes[@name=$base]">
						<xsl:value-of select="$allComplexTypes[@name=$base]/xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$allSimpleTypes[@name=$base]/xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
		<xsl:apply-templates select="*" mode="describeComponent"/>
	</xsl:template>
	<!-- Describe a restriction -->
	<xsl:template name="describeRestriction">
		<para>Inherited element(s): (This definition restricts the content defined by the type <xsl:call-template name="linkToType">
				<xsl:with-param name="name" select="@base"/>
			</xsl:call-template>)</para>
			<xsl:apply-templates mode="describeComponent" select="xsd:sequence|xsd:choice"/>
		<xsl:if test="xsd:enumeration">
			<table border="1">
				<tc column-width="9cm"/>
				<tc column-width="4cm"/>
				<tc column-width="5cm"/>
				<tr>
					<td>Value</td>
					<td>Source</td>
					<td>Description</td>
				</tr>
				<xsl:call-template name="describeEnum"/>
			</table>
		</xsl:if>
	</xsl:template>
	<!-- Describe a sequence -->
	<xsl:template name="describeSequence">
		<xsl:apply-templates select="child::*" mode="describeComponent"/>
	</xsl:template>
	<!-- Describe a group -->
	<xsl:template name="describeGroup">
		<xsl:if test="@ref">
			<xsl:variable name="groupname" select="@ref"/>
			<xsl:variable name="group" select="$allGroups[@name=$groupname]"/>
			<xsl:if test="not($group)">
				<xsl:message>couldn't find group <xsl:value-of select="$groupname"/></xsl:message>
			</xsl:if>
		<xsl:apply-templates select="$group/*" mode="describeComponent"/>
		</xsl:if>
		<xsl:if test="@name">
			<xsl:apply-templates select="./*" mode="describeComponent"/>
		</xsl:if>
	</xsl:template>

	<!-- Describe a choice -->
	<xsl:template name="describeChoice">
		<b>There can be <xsl:call-template name="cardinality"/> of the following choice:</b>
		<xsl:for-each select="*"> <!-- describe nested structures -->
			<xsl:choose>
				<xsl:when test="position()=1">
					<b> Choice of either</b>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<b>Or</b>
					</p>
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:apply-templates mode="describeComponent" select="."/>
			</ul>
		</xsl:for-each>
		<br/>
	</xsl:template>
	<!-- Describe an enumeration list -->
	<xsl:template name="describeEnum">
		<xsl:for-each select="xsd:enumeration">
			<tr>
				<td>
					<xsl:value-of select="@value"/>
				</td>
				<xsl:variable name="doc" select="xsd:annotation/xsd:documentation[@xml:lang = $lang]"/>
				<td>
					<xsl:value-of select="$doc/@source"/>
				</td>
				<td>
					<p>
						<xsl:value-of select="$doc"/>
					</p>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="describeElementType">
		<xsl:choose>
			<xsl:when test="@type"> of the type <xsl:call-template name="linkToType">
					<xsl:with-param name="name" select="@type"/>
				</xsl:call-template>) </xsl:when>
			<xsl:otherwise> with locally defined content) ... <ul>
					<xsl:apply-templates select="*" mode="describeComponent"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="xsd:annotation/xsd:documentation[@xml:lang=$lang]">
			<ul>
				<li>
					<xsl:value-of select="xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
				</li>
			</ul>
		</xsl:if>
	</xsl:template>
	<!-- document attributes -->
	<xsl:template match="xsd:attribute" mode="docAttributes">
		<p>Attribute: <b>
				<xsl:value-of select="@name"/>
			</b> (<xsl:value-of select="@type"/>) <xsl:if test="@use"> - <xsl:value-of select="@use"/></xsl:if>
		</p>
	</xsl:template>
	<!-- image output -->
	<xsl:template name="outputImage">
		<!--
		<xsl:variable name="image" select="concat($imagePath,@id,'.svg')"/>
		-->
		<xsl:param name="loc" select="''"/>
		<xsl:variable name="image" select="concat($imagePath,$loc,'.png')"/>
		<p>
			<!--
			<object width="{@width}" height="{@height}" data="{$image}" type="image/svg+xml">No SVG plugin installed</object>
			-->
			<img src="{$image}"/>
		</p>
	</xsl:template>
</xsl:stylesheet>
