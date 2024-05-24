<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:view="http://www.fpml.org/views" 
	xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
	xmlns:fpml-annotation="http://www.fpml.org/annotation" 
	exclude-result-prefixes="common xsd xsi view fpml-annotation"
	>

	<xsl:param name="version" select="'5-12'"/>
	<xsl:param name="view" select="'confirmation'"/>
	<xsl:param name="bump.level" select="0"/>
	<xsl:param name="date" select="current-dateTime()"/>
	<xsl:param name="year" select="format-dateTime($date, '[Y0001]')"/>
	<xsl:param name="oyear" select="oyear"/>

	<xsl:variable name="prefix">
		<xsl:if test="$bump.level &gt; 0">../</xsl:if>
	</xsl:variable>
	<!-- BAL 2009-07-06 added for defaulting reporting view to optional-->
	<xsl:variable name="all.optional" select="$view = 'reporting' or $view = 'transparency' or $view='recordkeeping' or $view='pretrade' "/>
	<!-- BAL 2009-07-06 end addition -->
	<xsl:variable name="FpML.namespaces.TF">
		<namespace ver="4-2" view="confirmation">http://www.fpml.org/2005/FpML-4-2</namespace>
		<namespace ver="4-3" view="confirmation">http://www.fpml.org/2007/FpML-4-3</namespace>
		<namespace ver="5-0" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-0" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-0" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-1" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-1" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-1" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-2" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-2" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-2" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-2" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-3" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-3" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-3" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-3" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-4" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-4" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-4" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-4" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-4" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-5" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-5" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-5" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-5" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-5" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-6" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-6" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-6" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-6" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-6" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-7" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-7" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-7" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-7" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-7" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-7" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
		<namespace ver="5-8" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-8" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-8" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-8" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-8" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-8" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
		<namespace ver="5-9" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-9" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-9" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-9" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-9" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-9" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
		<namespace ver="5-10" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-10" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-10" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-10" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-10" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-10" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
		<namespace ver="5-11" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-11" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-11" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-11" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-11" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-11" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
		<namespace ver="5-12" view="confirmation">http://www.fpml.org/FpML-5/confirmation</namespace>
		<namespace ver="5-12" view="reporting">http://www.fpml.org/FpML-5/reporting</namespace>
		<namespace ver="5-12" view="transparency">http://www.fpml.org/FpML-5/transparency</namespace>
		<namespace ver="5-12" view="recordkeeping">http://www.fpml.org/FpML-5/recordkeeping</namespace>
		<namespace ver="5-12" view="pretrade">http://www.fpml.org/FpML-5/pretrade</namespace>
		<namespace ver="5-12" view="legal">http://www.fpml.org/FpML-5/legal</namespace>
	</xsl:variable>
	<xsl:variable name="FpML.namespaces" select="common:node-set($FpML.namespaces.TF)"/>
	<xsl:variable name="FpML.ns" select="$FpML.namespaces/namespace[@ver=$version and @view=$view]/text()"/>
	<xsl:param name="target.ns" select="$FpML.ns"/>
        <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"></xsl:output>
	<!-- root template - generate for the target namespace -->
        <xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$target.ns">
				<xsl:apply-templates select="node()" mode="add-version"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Unknown version/view combination <xsl:value-of select="$version"/>/<xsl:value-of select="$view"/></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>
	<!-- copy comments, PIs, etc. -->
	<xsl:template match="node()" mode="add-version" priority="-1">
		<xsl:copy-of select="."/>
        </xsl:template>
	<!-- update copyright notice -->
	<xsl:template match="comment()[contains(.,'Copyright (c) ')]" mode="add-version" >
		<xsl:variable name="front" select="substring-before(.,'Copyright (c) ')"/>
		<xsl:variable name="temp" select="substring-after(.,'Copyright (c) ')"/>
		<xsl:variable name="back" select="substring-after($temp, ' ')"/>
		<xsl:choose>
			<xsl:when test="$year=$oyear">
				   <xsl:comment>
					<xsl:value-of select="$front"/>
					<xsl:text>Copyright (c) </xsl:text>
					<xsl:value-of select="$year"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$back"/>
				</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:value-of select="$front"/>
					<xsl:text>Copyright (c) </xsl:text>
					<xsl:value-of select="$oyear"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$year"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$back"/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>
	<!-- conversion for schema files -->
	<xsl:template match="xsd:schema" mode="add-version" >
		<!--<xsl:message>View is <xsl:value-of select="$view"/></xsl:message>-->
		<!-- overrides for this view -->
		<xsl:variable name="overrides" select="xsd:annotation/xsd:appinfo/view:override[@view=$view]"/>
		<!-- is this skipped in this view? -->
		<xsl:variable name="skip" select="xsd:annotation/xsd:appinfo/view:skip[@view=$view]"/>
		<!-- list of view for which this file is exclusive -->
		<xsl:variable name="exclusives" select="xsd:annotation/xsd:appinfo/view:exclusive"/>
		<!-- boolean - is this file excluded from this view?  (has exclusives not including this view) -->
		<xsl:variable name="excluded" select="$exclusives and not($exclusives[@view=$view])"/>

		<xsl:choose>
			<!-- when this is excluded from/skipped in this view, generate a message and terminate -->
			<xsl:when test="$excluded or $skip">
				<xsl:comment>!!!!!!! This subschema is not needed in this view !!!!!</xsl:comment>
				<xsl:message terminate="yes">not needed - skipping.</xsl:message>
			</xsl:when>
			<!-- otherwise, convert it -->
			<xsl:otherwise>
				<xsl:apply-templates mode="convert-root" select="."/>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>
	<!-- convert the schema root element -->
	<xsl:template match="xsd:schema" mode="convert-root" >
		<xsl:variable name="ns-node">
			<xsl:element name="ns-element" namespace="{$target.ns}"/>
		</xsl:variable>
		<xsd:schema>
			<!-- copy default namespace -->
			<xsl:copy-of select="common:node-set($ns-node)/*/namespace::*[local-name()='']"/>
			<!-- copy namespace definitions -->
			<xsl:apply-templates select="." mode="fpmlns"/>
			<xsl:copy-of select="./namespace::*[local-name()='dsig']"/>
			<xsl:copy-of select="./namespace::*[local-name()='ecore']"/>
			<xsl:copy-of select="./namespace::*[local-name()='tr']"/>
			<!--
			<xsl:copy-of select="./namespace::*[local-name()='view']"/>
			-->
			<xsl:copy-of select="./namespace::*[local-name()='fpml-annotation']"/>

			<xsl:call-template name="additional.schema.attributes"/>
			<!-- generate target version -->
			<xsl:attribute name="targetNamespace"><xsl:value-of select="$target.ns"/></xsl:attribute>
			<!-- copy schema attributes -->
			<xsl:if test="@ecore:documentRoot"> <!-- do for FpML schemas, not extension example -->
				<xsl:attribute name="ecore:documentRoot">FpML</xsl:attribute>
				<xsl:attribute name="ecore:nsPrefix">
					<xsl:call-template name="get.view.prefix"/>
				</xsl:attribute>
				<xsl:attribute name="ecore:package">
					<xsl:text>org.fpml.</xsl:text>
					<xsl:value-of select="$view"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="@version"/>
			<xsl:copy-of select="@attributeFormDefault|@elementFormDefault"/>
			<!-- recursively generate the rest of the schema -->
			<xsl:apply-templates select="node()" mode="conv.schema"/>
		</xsd:schema>
		<!--<xsl:message>done applying view <xsl:value-of select="$view"/></xsl:message>-->
	</xsl:template>
	<xsl:template name="get.view.prefix">
		<xsl:choose>
			<xsl:when test="$view='confirmation'">conf</xsl:when>
			<xsl:when test="$view='pretrade'">pre</xsl:when>
			<xsl:when test="$view='reporting'">rpt</xsl:when>
			<xsl:when test="$view='transparency'">trnsp</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- extension point-->
	<xsl:template name="additional.schema.attributes">
	</xsl:template>

	<xsl:template mode="fpmlns" match="*">
		<xsl:variable name="fpml-ns-node">
			<xsl:element name="fpml:fpml-ns-element" namespace="{$target.ns}"/>
		</xsl:variable>
		<xsl:if test="./namespace::*[local-name()='fpml']">
			<xsl:copy-of select="common:node-set($fpml-ns-node)/*/namespace::*[local-name()='fpml']"/>
		</xsl:if>
	</xsl:template>

	<!-- handle standard attributes (includes supported fpml versions) -->
	<xsl:template match="xsd:attributeGroup[@name='StandardAttributes.atts']" mode="conv.schema">
		<xsl:comment>Standard Attributes</xsl:comment>
		<xsl:apply-templates mode="upd.version" select="."/>
        </xsl:template>
	<!-- adjust the list of supported FpML versions -->
	<xsl:template match="xsd:attributeGroup|xsd:simpleType|xsd:restriction|xsd:attribute[@name='version']" mode="upd.version">
		<xsl:copy>
			<xsl:apply-templates mode="copy.attr" select="@*"/>
			<xsl:apply-templates mode="upd.version" select="node()"/>
		</xsl:copy>
        </xsl:template>
	<!-- keep only the versions that are less than or equal to the version being generated -->
	<xsl:template match="xsd:enumeration" mode="upd.version">
		<xsl:variable name="verno" select="translate($version, '-', '.')"/>
		<xsl:variable name="valno" select="translate(@value, '-', '.')"/>
		<xsl:choose>
			<xsl:when test="$valno &lt;= $verno">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment> Skipped version <xsl:value-of select="$valno"/>, not LE [<xsl:value-of select="$verno"/>]</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>
	<!-- default translation -->
        <xsl:template match="node()" mode="upd.version" priority="-1">
		<xsl:apply-templates mode="conv.schema" select="."/>
        </xsl:template>
	<!-- adjust the include file location to add the -x-y version information -->
        <xsl:template match="xsd:include" mode="conv.schema">
		<xsl:variable name="sl" select="@schemaLocation"/>
		<xsl:variable name="len" select="string-length($sl)"/>
		<xsl:variable name="front1" select="substring($sl, 1, $len - 4)"/>
		<xsl:variable name="front">							<!-- replace including 'fpml-main' with 'fpml-main-orig' -->
			<xsl:choose>
				<xsl:when test="$front1='fpml-main'">fpml-main-orig</xsl:when>
				<xsl:otherwise><xsl:value-of select="$front1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="new.sl" select="concat($front, '-', $version, '.xsd')"/>
		<xsl:variable name="overrides" select="xsd:annotation/xsd:appinfo/view:override[@view=$view]"/>
		<xsl:variable name="skip" select="xsd:annotation/xsd:appinfo/view:skip[@view=$view]"/>
		<xsl:variable name="exclusives" select="xsd:annotation/xsd:appinfo/view:exclusive"/>
		<xsl:variable name="excluded" select="$exclusives and not($exclusives[@view=$view])"/>

		<xsl:if test="not($excluded) and not($skip)">
			<xsd:include>
				<xsl:attribute name="schemaLocation"><xsl:value-of select="$new.sl"/></xsl:attribute>
			</xsd:include>
		</xsl:if>
        </xsl:template>

	<!-- remove view-generation details from generated schema -->
	<xsl:template match="xsd:appinfo" mode="conv.schema" priority="-1"/>
	<xsl:template match="xsd:appinfo[view:usage]" mode="conv.schema" >
		<!-- <xsl:message>Found usage tag in <xsl:value-of select="../../@name"/></xsl:message> -->
		<xsl:if test="view:usage/@view = $view">
			<!-- <xsl:message>Copying usage tag</xsl:message> -->
			<xsd:appinfo>
				<view:usage>
					<xsl:copy-of select="view:usage/@type"/>
				</view:usage>
			</xsd:appinfo>
		</xsl:if>
	</xsl:template>

	<!-- remove annotations without documentation -->
	<xsl:template match="xsd:annotation[not(xsd:documentation) and not(xsd:appinfo/view:usage)]" mode="conv.schema" />
	<xsl:template match="view:*" mode="conv.schema" priority="-1" />

	<!-- apply overrides for each view -->
	<xsl:template match="*" mode="conv.schema" priority="-2">
		<xsl:apply-templates mode="do.conv.schema" select="."/>
        </xsl:template>

	<xsl:template match="xsd:documentation[@view:view]" mode="conv.schema" >
		<xsl:variable name="v" select="@view:view"/>
		<xsl:variable name="nview" select="concat('!',$view)"/>
		<xsl:choose>
			<xsl:when test="contains($v, $nview)"/>  <!-- skip when !view is specified and matches -->
			<xsl:when test="contains($v, '!')">   <!-- include when !view is specified and doesn't match -->
				<xsd:documentation>
					<xsl:copy-of select="@xml:lang"/>
					<xsl:copy-of select="text()"/>
				</xsd:documentation>
			</xsl:when>
			<xsl:when test="contains($v, $view)"> <!-- include when view is specified and doesn't match -->
				<xsd:documentation>
					<xsl:copy-of select="@xml:lang"/>
					<xsl:copy-of select="text()"/>
				</xsd:documentation>
			</xsl:when>
		</xsl:choose>
        </xsl:template>

	<xsl:template match="xsd:sequence[local-name(../..) != 'schema']" mode="conv.schema" >
		<xsl:variable name="contTF">
			<xsl:apply-templates mode="do.conv.schema" select="."/>
		</xsl:variable>
		<xsl:variable name="cont" select="common:node-set($contTF)"/>
		<xsl:choose>
			<xsl:when test="(count($cont/xsd:sequence/*) - count($cont/xsd:sequence/xsd:annotation)) &gt; 0">
				<xsl:copy-of select="$cont"/>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:message>Skipped an empty sequence.</xsl:message>-->
				<!--	<xsl:comment>View Generation: Skipped an empty sequence.</xsl:comment> -->
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>

	<xsl:template match="xsd:choice[not(@maxOccurs) and local-name(../..) != 'schema']" mode="conv.schema" >
		<xsl:variable name="contTF">
			<xsl:apply-templates mode="do.conv.schema" select="."/>
		</xsl:variable>
		<xsl:variable name="cont" select="common:node-set($contTF)"/>
		<xsl:choose>
			<xsl:when test="(count($cont/xsd:choice/*) - count($cont/xsd:choice/xsd:annotation)) &gt; 1">
				<xsl:copy-of select="$cont"/>
			</xsl:when>
			<xsl:when test="(count($cont/xsd:choice/*) - count($cont/xsd:choice/xsd:annotation)) = 1">
				<!--<xsl:message>Removed a degenerate choice.</xsl:message>-->
				<!-- <xsl:comment>View Generation: Removed a degenerate choice.</xsl:comment> -->
				<xsl:choose>
					<xsl:when test="xsd:annotation/xsd:appinfo/view:override[@view=$view]/@minOccurs = 1">
						<xsl:copy-of select="$cont/xsd:choice/*[local-name(.)!='annotation']"/>
					</xsl:when>
					<xsl:when test="@minOccurs=0">
						<xsl:for-each select="$cont/xsd:choice/*[local-name(.)!='annotation']">
							<xsl:copy>
								<xsl:copy-of select="@*[local-name(.) != 'minOccurs']"/>
								<xsl:attribute name="minOccurs">0</xsl:attribute>
								<xsl:copy-of select="*|text()|comment()"/>
							</xsl:copy>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$cont/xsd:choice/*[local-name(.)!='annotation']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:message>Skipped an empty choice.</xsl:message>-->
				<!-- <xsl:comment>View Generation: Skipped an empty choice.</xsl:comment> -->
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>

	<xsl:template match="*" mode="do.conv.schema" priority="-2">
		<xsl:variable name="overrides" select="xsd:annotation/xsd:appinfo/view:override[@view=$view]"/>
		<xsl:variable name="exclusives" select="xsd:annotation/xsd:appinfo/view:exclusive"/>
		<xsl:variable name="excluded" select="$exclusives and not($exclusives[@view=$view])"/>
		<xsl:variable name="skip" select="xsd:annotation/xsd:appinfo/view:skip[@view=$view]"/>
		<xsl:variable name="retain" select="xsd:annotation/xsd:appinfo/view:retain[@view=$view]"/>
		<xsl:variable name="rationale" select="xsd:annotation/xsd:appinfo/view:*/@rationale"/>
			<!-- BAL added 2011-03 for flat reporting support -->

			<!--
		<xsl:message>     working on component in <xsl:value-of select="ancestor::*/@name"/></xsl:message>
		-->
		<!--
		<xsl:if test="$overrides">
			<xsl:comment>Has overrides</xsl:comment>
		</xsl:if>
		-->
		<xsl:choose>
			<xsl:when test="$retain">	<!-- if "retain" option is selected ... -->
				<!--<xsl:message>Found retain for <xsl:value-of select="local-name(.)"/>:<xsl:value-of select="@name"/></xsl:message>-->
				<xsl:apply-templates select="." mode="migrate"/>
			</xsl:when>
			<xsl:when test="not($excluded) and not($skip) and not ($retain)"> <!-- if not skipped or retained -->
				<!-- generate an element in the right namespace with the appropriate attributes -->
				<xsl:variable name = "tmp">

					<xsl:element name="xsd:{local-name(.)}" namespace="{namespace-uri(.)}">
						<!-- convert the attributes based on the overrides -->
						<xsl:apply-templates mode="conv.attrs" select="@*">
							<xsl:with-param name="overrides" select="$overrides"/>
						</xsl:apply-templates>
						<!-- copy override attributes, other than the view name -->
						<xsl:apply-templates mode="copy.override.attrs" select="$overrides/@*[local-name(.)!='view']"/>
						<!-- BAL 2009-07-06 added for defaulting reporting view to optional-->
						<xsl:apply-templates mode="do.all.optional" select=".">
							<xsl:with-param name="overrides" select="$overrides"/>
						</xsl:apply-templates>
						<!-- BAL 2009-07-06 end addition -->
						<!-- recurse to do children  -->
						<xsl:if test="*[not(xsd:annotation) or (xsd:annotation/xsd:documentation) or (xsd:annotation/xsd:appinfo/view:usage)] or comment() or text()">
							<xsl:apply-templates mode="conv.schema" select="*|comment()|text()"/>
						</xsl:if>
					</xsl:element>

				</xsl:variable>
				<xsl:variable name="temp" select="common:node-set($tmp)/*[1]"/>
				<!-- hack to try to create empty elements in a single, closed tag -->
				<xsl:choose>
					<xsl:when test="count($temp/*) &gt; 0">
						<!--
						<xsl:copy-of select="$temp"/>
						-->

						<xsl:for-each select="$temp">
							<xsl:copy>
								<xsl:copy-of select="@*[local-name(.) != 'maxOccurs' and not(local-name(.) = 'minOccurs' and (.='1')) and not(starts-with(name(),'fpml-annotation:'))]"/>
								<xsl:copy-of select="@maxOccurs"/>
								<xsl:copy-of select="@fpml-annotation:*"/>
								<xsl:copy-of select="*|comment()|text()"/>
							</xsl:copy>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="local-name(.) = 'group' and count($temp/@*) = 1 and $temp/@ref">
						<xsd:group ref="{$temp/@ref}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'group' and count($temp/@*) = 2 and $temp/@ref and $temp/@maxOccurs">
						<xsd:group ref="{$temp/@ref}" maxOccurs="{$temp/@maxOccurs}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 1 and $temp/@ref ">
						<xsd:element ref="{$temp/@ref}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 2 and $temp/@ref and $temp/@minOccurs">
						<xsd:element ref="{$temp/@ref}" minOccurs="{$temp/@minOccurs}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 2 and $temp/@ref and $temp/@maxOccurs">
						<xsd:element ref="{$temp/@ref}" maxOccurs="{$temp/@maxOccurs}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 3 and $temp/@ref and $temp/@minOccurs and $temp/@maxOccurs">
						<xsd:element ref="{$temp/@ref}" minOccurs="{$temp/@minOccurs}" maxOccurs="{$temp/@maxOccurs}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 2 and $temp/@name and $temp/@type">
						<xsd:element name="{$temp/@name}" type="{$temp/@type}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 3 and $temp/@name and $temp/@type and $temp/@maxOccurs">
						<xsd:element name="{$temp/@name}" type="{$temp/@type}" maxOccurs="{$temp/@maxOccurs}"/>
					</xsl:when>
					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 3 and $temp/@name and $temp/@type and $temp/@minOccurs">
						<xsd:element name="{$temp/@name}" type="{$temp/@type}" minOccurs="{$temp/@minOccurs}"/>
					</xsl:when>

					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 4 and $temp/@name and $temp/@type and $temp/@minOccurs and $temp/@maxOccurs">
						<xsd:element name="{$temp/@name}" type="{$temp/@type}" minOccurs="{$temp/@minOccurs}" maxOccurs="{$temp/@maxOccurs}"/>
					</xsl:when>

					<xsl:when test="local-name(.) = 'element' and count($temp/@*) = 3 and $temp/@name and $temp/@type and $temp/@substitutionGroup">
						<xsd:element name="{$temp/@name}" type="{$temp/@type}" substitutionGroup="{$temp/@substitutionGroup}"/>
					</xsl:when>

					<xsl:otherwise>
						<!--
						<xsl:copy-of select="$temp"/>
						-->
						<xsl:for-each select="$temp">
							<xsl:copy>
								<xsl:copy-of select="@*[local-name(.) != 'maxOccurs' and not(local-name(.) = 'minOccurs' and (.='1')) and not(starts-with(name(),'fpml-annotation:'))]"/>
								<xsl:copy-of select="@maxOccurs"/>
								<xsl:copy-of select="@fpml-annotation:*"/>
								<xsl:copy-of select="*|comment()|text()"/>
							</xsl:copy>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="($skip) and $rationale">
			<!-- <xsl:comment>View Generation: SKIPPED <xsl:value-of select="@name"/> - <xsl:value-of select="concat(normalize-space($rationale), ' ')"/></xsl:comment> -->
		</xsl:if>
        </xsl:template>

	<!-- migrate namespace without doing anything else -->
	<xsl:template match="*" mode="migrate" priority="-1">
		<xsl:element name="xsd:{local-name(.)}" namespace="{namespace-uri(.)}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="migrate" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="node()" mode="migrate" priority="-2">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="xsd:appinfo" mode="migrate" priority="0"/>



	<xsl:template match="xsd:appinfo[view:usage]" mode="migrate" >
		<!-- <xsl:message>Found usage tag in <xsl:value-of select="../../@name"/></xsl:message> -->
		<xsl:if test="view:usage/@view = $view">
			<!-- <xsl:message>Copying usage tag</xsl:message> -->
			<xsd:appinfo>
				<view:usage>
					<xsl:copy-of select="view:usage/@type"/>
				</view:usage>
			</xsd:appinfo>
		</xsl:if>
	</xsl:template>


	<!-- BAL 2009-07-06 added for defaulting reporting view to optional-->
	<!-- if necessary default minOccurs to 0 (in reporting views) -->
	<xsl:template match="*[@minOccurs]" mode="do.all.optional" priority="2"/>	<!-- skip where already processed -->
	<xsl:template match="*[../xsd:schema]" mode="do.all.optional" priority="10"/>	<!-- skip where global component -->
	<xsl:template match="xsd:schema/*" mode="do.all.optional" priority="11"/>	<!-- skip where global component -->
	<xsl:template match="*" mode="do.all.optional" priority="-1"/>	<!-- skip where not appropriate (e.g. type defs) -->
	<!--
	<xsl:template match="xsd:choice[not(*[@minOccurs='0'])]" mode="do.all.optional" priority="15"/> 
	-->
	<!-- skip choices where all entries are optional -->
	<xsl:template match="xsd:sequence[not(*[@minOccurs='0'])]" mode="do.all.optional" priority="16"/> <!-- skip sequences where all entries are optional -->
	<!-- <xsl:template match="xsd:element|xsd:group|xsd:sequence|xsd:choice" mode="do.all.optional"> -->
	<xsl:template match="xsd:element" mode="do.all.optional">
		<xsl:param name="overrides"/>
		<xsl:variable name="override" select="$overrides[@minOccurs]"/>
		<xsl:if test="$all.optional and not($override) and not(local-name(..)='choice')">   <!-- if default to optional and not overridden and not one of a choice, make optional -->
			<!--
			<xsl:message>defaulting to optional in <xsl:value-of select="local-name(.)"/></xsl:message>
			-->
			<xsl:attribute name="minOccurs">0</xsl:attribute>
		</xsl:if>
        </xsl:template>
	<xsl:template match="xsd:choice" mode="do.all.optional">
		<xsl:param name="overrides"/>
		<xsl:variable name="override" select="$overrides[@minOccurs]"/>
		<!--<xsl:message>working on optional in choice in <xsl:value-of select="ancestor::*/@name"/></xsl:message>-->
		<xsl:if test="$all.optional and not($override) and not(local-name(..)='group') and not(local-name(..)='complexType')">   <!-- if default to optional and not overridden and not one of a choice, make optional -->
			<!--
			<xsl:message>defaulting to optional in <xsl:value-of select="local-name(.)"/></xsl:message>
			-->
			<xsl:attribute name="minOccurs">0</xsl:attribute>
		</xsl:if>
        </xsl:template>
	<!-- BAL 2009-07-06 end addition -->

	<!-- convert the attributes based on the overrides -->
	<xsl:template match="@*" mode="conv.attrs">
		<xsl:param name="overrides"/>
		<xsl:variable name="atname" select="local-name(.)"/>
		<xsl:variable name="override" select="$overrides/@*[local-name(.)=$atname]"/>
		<xsl:choose>
			<xsl:when test="$override">
				<xsl:variable name="isDefaulted" select="$atname='minOccurs' or $atname = 'maxOccurs'"/>
				<xsl:variable name="isDefault" select="$override and $isDefaulted"/>
				<!-- when attribute is overridden, adjust -->
				<xsl:if test="not($isDefault = 'true')">
					<xsl:attribute name="{$atname}">
						<xsl:value-of select="$override"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:when test="local-name(..)='group'">
				<xsl:apply-templates mode="copy.attr" select="."/>
			</xsl:when>
			<!-- BAL 2009-07-06 added for defaulting reporting view to optional-->
			<xsl:when test="$atname = 'minOccurs' and $all.optional and not($override)">
				<xsl:attribute name="minOccurs">0</xsl:attribute>
			</xsl:when>
			<!-- BAL 2009-07-06 end addition -->
			<xsl:otherwise>
				<!-- otherwise just copy it -->
				<xsl:apply-templates mode="copy.attr" select="."/>
			</xsl:otherwise>
		</xsl:choose>
        </xsl:template>

	<!-- copy the override attributes -->
	<xsl:template match="@*" mode="copy.override.attrs">
		<xsl:variable name="atname" select="local-name(.)"/>
		<xsl:variable name="isDefaulted" select="$atname='minOccurs' or $atname = 'maxOccurs'"/>
		<xsl:variable name="isDefault" select=". = 1 and $isDefaulted"/>
		<xsl:if test="not($isDefault = 'true')">
			<xsl:copy-of select="."/>
		</xsl:if>
        </xsl:template>

	<!-- copy an attribute
		(extension point; allows adjustment of namespace if required -->
	<xsl:template match="@*" mode="copy.attr" >
		<xsl:copy-of select="."/>
        </xsl:template>

	<!-- default template just copies -->
	<xsl:template match="node()" mode="conv.schema" priority="-3">
		<xsl:copy-of select="."/>
        </xsl:template>


	<!-- the following templates are used for adjusting instance documents to a new view -->

	<xsl:template match="node()[local-name(.)='FpML']" mode="add-version">
		<xsl:element name="FpML" namespace="{$target.ns}">
			<xsl:attribute name="version">
				<xsl:value-of select="$version"/>
			</xsl:attribute>
			<xsl:attribute name="xsi:schemaLocation">
				<xsl:value-of select="$target.ns"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="concat($prefix, '../fpml-main-',$version,'.xsd')"/>
			</xsl:attribute>
			<xsl:copy-of select="@xsi:type"/>
			<xsl:apply-templates mode="conv.example" select="node()"/>
		</xsl:element>
        </xsl:template>
	<!-- change namespace of elements -->
	<xsl:template match="*" mode="conv.example">
		<xsl:element name="{local-name(.)}" namespace="{$target.ns}">
			<!-- namespace="{$target.ns}"> -->
			<xsl:apply-templates mode="copy.attr" select="@*"/>
			<xsl:apply-templates mode="conv.example" select="node()"/>
		</xsl:element>
        </xsl:template>
	<!-- copy non-elements -->
	<xsl:template match="node()" mode="conv.example" priority="-1">
		<xsl:copy-of select="."/>
        </xsl:template>
</xsl:stylesheet>
