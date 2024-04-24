<?xml version="1.0" encoding="utf-8" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must use XML Turbo to generate the schemaDoc images and run
	the 'fetch.bat' file to copy them to the svg directory
 -->

<!-- TODO: attributes -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format" 
	xmlns:view="http://www.fpml.org/views" 
	exclude-result-prefixes="xsl xsd fmt">

	<!-- templates shared with xml/pdf version -->
	<xsl:import href="gen-schema-shared.xsl"/>

	<xsl:output encoding="UTF-8" cdata-section-elements="programlisting"/>
	
	<!-- The main template -->
	<xsl:template match="/data">
		<xsl:variable name="verfile" select="document('../src/fpml-version.xml')/wrapper"/>
		<chapter>
			<title><xsl:value-of select="concat('FpML - ',$pretty.area)"/> Component Definitions</title>
			<xsl:copy-of select="$verfile/*"/>
			<xsl:call-template name="doBody"/>
		</chapter>
	</xsl:template>

	<!-- Generate applicability documentation -->
	<xsl:template name="doApplicability">
		<xsl:variable name="view-specific" select="$subschema/xsd:schema/xsd:annotation/xsd:appinfo/view:*"/>
		<section>
			<title>Applicability to views:</title>
			<xsl:apply-templates select="$view-specific" mode="applicability" />
			<xsl:if test="not($view-specific)">
				<para>This sub-schema is used in all views. </para>
			</xsl:if>
		</section>
	</xsl:template>

	<xsl:template mode="applicability" match="view:exclusive">
		<para>This sub-schema is used only in the "<xsl:value-of select="@view"/>" view.</para>
	</xsl:template>

	<xsl:template mode="applicability" match="view:override[@skip='true']">
		<para>This sub-schema is not used in the "<xsl:value-of select="@view"/>" view.</para>
	</xsl:template>

	<!-- Generate global component documentation -->
	<xsl:template name="doComponentSection">
		<xsl:param name="components" />
		<xsl:param name="title" />
		<xsl:param name="description" />
		<xsl:param name="anchor" />
		<section>
			<title><xsl:value-of select="$title"/></title>
			<xsl:choose>
				<xsl:when test="count($components) != 0">
					<xsl:for-each select="$components">
						<xsl:sort select="@name"/>
						<xsl:if test="position() != 1">
							<beginpage/>
						</xsl:if>

						<xsl:apply-templates mode="documentComponent" select="."/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<para>The schema does not contain any global <xsl:value-of select="$description"/>.</para>
				</xsl:otherwise>
			</xsl:choose>
		</section>
	</xsl:template>
	<xsl:template mode="documentComponent" match="node()">
		<section id="Element.{@name}">
			<title>
				<xsl:value-of select="@name"/>
			</title>
			<section>
				<title>Description:</title>
				<para>
					<xsl:value-of select="xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
				</para>
				<xsl:apply-templates mode="componentApplicability" select="."/>
			</section>

			<xsl:if test="not(local-name(.)='simpleType')">
				<section>
					<title>Figure:</title>
					<xsl:apply-templates mode="findImage" select="."/>
				</section>
			</xsl:if>
			<section>
				<title>Contents:</title>
				<xsl:apply-templates mode="describeComponent" select="."/>
			</section>
			<section>
				<title>Used by:</title>
				<xsl:variable name="target" select="@name"/>
				<itemizedlist>
					<xsl:apply-templates mode="usedBy" select="."/>
					<!--
					<xsl:apply-templates mode="generateUse" select="$allComplexTypes[.//xsd:element/@ref = $target]">
						<xsl:sort select="@name"/>
					</xsl:apply-templates>
					-->
				</itemizedlist>
			</section>
			<xsl:apply-templates mode="otherDocumentation" select="."/>

			<xsl:call-template name="schemaFragment"/>
		</section>
	</xsl:template>

	<xsl:template mode="componentApplicability" match="view:override[@skip='true']">
		<para>This component is not applicable in the "<xsl:value-of select="@view"/>" view.</para>
	</xsl:template>

	<xsl:template mode="derivedFrom" match="xsd:extension|xsd:restriction">
		<xsl:variable name="base" select="@base"/>
		<xsl:variable name="baseType" select="$allTypes[@name=$base]"/>
		<xsl:if test="$baseType">
			<section>
				<title>
					<xsl:apply-templates select="." mode="derivationLabel"/>
				</title>
				<itemizedlist>
					<listitem>
						<xsl:apply-templates mode="link" select="$baseType"/>
					</listitem>
				</itemizedlist>
			</section>
		</xsl:if>
	</xsl:template>
	<xsl:template name="derivedTypes">
		<xsl:variable name="dtarget" select="@name"/>
		<xsl:variable name="derivedTypes" select="$allTypes[*/*/@base = $dtarget]"/>
		<xsl:if test="$derivedTypes">
			<section>
				<title>Derived Types:</title>
				<itemizedlist>
					<xsl:apply-templates mode="generateUse" select="$derivedTypes">
						<xsl:sort select="@name"/>
					</xsl:apply-templates>
				</itemizedlist>
			</section>
		</xsl:if>
	</xsl:template>

	<xsl:template name="schemaFragment">
		<section>
			<title>Schema Fragment:</title>
			<programlisting>
				<xsl:value-of select="fmt:format(.)"/>
			</programlisting>
		</section>
	</xsl:template>
	<!-- Format the entire schema -->
	<xsl:template name="dumpSchema">
		<!--
	<div id="XMLSchema" style="page-break-before: always">
	<hr/>
	<h1>Full XML Schema</h1>
	<pre>
	-->
		<section>
			<title>Schema listing</title>
			<programlisting>
			<xsl:value-of select="fmt:format ($subschema/xsd:schema)"/>
		</programlisting>
		</section>
		<!--
	</pre>
	</div>
	-->
	</xsl:template>
	<!-- Generate a link to an element -->
	<xsl:template name="linkToElement">
		<xsl:param name="name"/>
		<xsl:variable name="dest" select="$allElements [@name = $name]/ancestor::file/@name"/>
		<xsl:choose>
			<xsl:when test="$dest">
				<link linkend="Element.{@name}">
					<xsl:value-of select="$name"/>
				</link>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Generate a link to a type -->
	<xsl:template name="linkToType">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$allComplexTypes [@name = $name]">
				<xsl:call-template name="linkToComplexType">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$allSimpleTypes [@name = $name]">
				<xsl:call-template name="linkToSimpleType">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Generate a link to a simple type -->
	<xsl:template name="linkToSimpleType">
		<xsl:param name="name"/>
		<xsl:variable name="dest" select="$allSimpleTypes [@name = $name]/ancestor::file/@name"/>
		<xsl:choose>
			<xsl:when test="$dest">
				<link linkend="Simple.{$name}">
					<xsl:value-of select="$name"/>
				</link>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Generate a link to a complex type -->
	<xsl:template name="linkToComplexType">
		<xsl:param name="name"/>
		<xsl:variable name="dest" select="$allComplexTypes [@name = $name]/ancestor::file/@name"/>
		<xsl:choose>
			<xsl:when test="$dest">
				<link linkend="Complex.{$name}">
					<xsl:value-of select="$name"/>
				</link>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Describe an extension -->
	<xsl:template name="describeExtension">
		<para>Inherited element(s): (This definition inherits the content defined by the type <xsl:call-template name="linkToType">
				<xsl:with-param name="name" select="@base"/>
			</xsl:call-template>)</para>
		<itemizedlist>
			<xsl:variable name="base" select="@base"/>
			<listitem>
				<xsl:value-of select="$allComplexTypes[@name=$base]/xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
			</listitem>
		</itemizedlist>
		<xsl:for-each select="child::*">
			<xsl:choose>
				<xsl:when test="name() = 'xsd:sequence'">
					<xsl:call-template name="describeSequence"/>
				</xsl:when>
				<xsl:when test="name() = 'xsd:choice'">
					<xsl:call-template name="describeChoice"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!-- Describe a restriction -->
	<xsl:template name="describeRestriction">
		<para>Inherited element(s): (This definition restricts the content defined by the type <xsl:call-template name="linkToType">
				<xsl:with-param name="name" select="@base"/>
			</xsl:call-template>)</para>
			<xsl:choose>
				<xsl:when test="xsd:enumeration">
					<xsl:call-template name="enumeration"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="describeComponent" select="child::*"/>
				</xsl:otherwise>
			</xsl:choose>

	</xsl:template>
	<xsl:template name="enumeration" >
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
	</xsl:template>
	<!-- Describe a sequence -->
	<xsl:template name="describeSequence">
		<xsl:apply-templates mode="describeComponent" select="child::*"/>
	</xsl:template>
	<!-- Describe a group -->
	<xsl:template name="describeGroup">
		<xsl:variable name="groupname" select="@ref"/>
		<xsl:variable name="group" select="$allGroups[@name=$groupname]"/>

		<xsl:apply-templates mode="describeComponent" select="$group/*"/>
	</xsl:template>
	<!-- Describe a choice -->
	<xsl:template name="describeChoice">
		<b>There can be <xsl:call-template name="cardinality"/> of the following choice:</b>
		<xsl:for-each select="xsd:*">
			<xsl:choose>
				<xsl:when test="position()=1">
					<para>Either</para>
				</xsl:when>
				<xsl:otherwise>
					<para>Or</para>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates mode="describeComponent" select="."/>
		</xsl:for-each>
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
	<!-- Describe a element -->
	<xsl:template mode="describeComponent" match="xsd:element">
		<para>
			<xsl:call-template name="describeElement"/>
		</para>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<xsl:template name="describeElementType">
		<xsl:choose>
			<xsl:when test="@type"> of the type <xsl:call-template name="linkToType">
					<xsl:with-param name="name" select="@type"/>
				</xsl:call-template>) </xsl:when>
			<xsl:otherwise> with locally defined content) </xsl:otherwise>
		</xsl:choose>
		<xsl:if test="xsd:annotation/xsd:documentation[@xml:lang=$lang]">
			<itemizedlist>
				<listitem>
					<xsl:value-of select="xsd:annotation/xsd:documentation[@xml:lang=$lang]"/>
				</listitem>
			</itemizedlist>
		</xsl:if>
	</xsl:template>
	<!-- image output -->
	<xsl:template name="outputImage">
		<!--
		<xsl:variable name="image" select="concat($imagePath,@id,'.svg')"/>
		<graphic format="SVG" width="{@width}" depth="{@height}" fileref="{$image}"/>
		<p>
			<object width="{@width}" height="{@height}" data="{$image}" type="image/svg+xml">No SVG plugin installed</object>
		</p>
		-->
		<xsl:param name="loc" select="''"/>
		<xsl:variable name="image" select="concat($imagePath,$loc,'.png')"/>
		<graphic format="PNG" fileref="{$image}"/>
		<p>
			<object data="{$image}" type="image/png">PNG not supported</object>
		</p>
	</xsl:template>
	<xsl:template mode="generateUse" match="xsd:complexType">
		<xsl:apply-templates mode="generateLink" select=".">
			<xsl:with-param name="prefix" select="'Complex'"/>
			<xsl:with-param name="label" select="'Complex type'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template mode="generateUse" match="xsd:simpleType">
		<xsl:apply-templates mode="generateLink" select=".">
			<xsl:with-param name="prefix" select="'Simple'"/>
			<xsl:with-param name="label" select="'Simple type'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template mode="generateUse" match="xsd:element">
		<xsl:apply-templates mode="generateLink" select=".">
			<xsl:with-param name="prefix" select="'Element'"/>
			<xsl:with-param name="label" select="'Element'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template mode="generateLink" match="node()">
		<xsl:param name="prefix" select="'Complex'"/>
		<xsl:param name="label" select="'Complex type'"/>
		<xsl:variable name="file" select="ancestor::file/@name"/>
		<listitem><xsl:value-of select="$label"/>: <link linkend="{$file}#{$prefix}.{@name}">
				<xsl:value-of select="@name"/>
			</link></listitem>
	</xsl:template>
	<xsl:template match="xsd:attribute" mode="docAttributes">
		<para>Attribute: <b>
				<xsl:value-of select="@name"/>
			</b> (<xsl:value-of select="@type"/>) <xsl:if test="@use"> - <xsl:value-of select="@use"/></xsl:if>
		</para>
	</xsl:template>
</xsl:stylesheet>
