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

	<xsl:import href="utils.xsl"/>

	<xsl:param name="area" select="'default value'"/>
	<xsl:param name="schema" select="'default value'"/>
	<xsl:param name="date" select="'default value'"/>
	<xsl:param name="time" select="'default value'"/>
	<xsl:param name="builddate" select="$date"/>
	<xsl:param name="buildtime" select="$time"/>
	<xsl:param name="lang" select="'en'"/>
	<xsl:param name="view" select="'Master'"/>
	<xsl:variable name="is.master" select="$view = 'master' or $view='Master' or $view = 'MASTER'"/>
	<xsl:variable name="imagePath" select="'schemaDiagrams/'"/>

	<!-- Configuration parameters -->
	<!--
	<xsl:variable name="imagePath" select="concat('svg/',substring-before ($schema,'.xsd'),'_xsd/')"/>
	<xsl:variable name="imageMap" select="document(concat('../html/',$imagePath,'id-map.xml'))"/>
	-->
	<!-- Create nodesets for the section to be processed -->
	<xsl:variable name="subschema" select="/data/file[@name=$schema]"/>
	<xsl:variable name="elements" select="$subschema/xsd:schema/xsd:element"/>
	<xsl:variable name="complexTypes" select="$subschema/xsd:schema/xsd:complexType"/>
	<xsl:variable name="simpleTypes" select="$subschema/xsd:schema/xsd:simpleType"/>
	<xsl:variable name="groups" select="$subschema/xsd:schema/xsd:group"/>
	<!-- Create nodesets for all global elements and type definitions -->
	<xsl:variable name="allElements" select="/data/file/xsd:schema/xsd:element"/>
	<xsl:variable name="allComplexTypes" select="/data/file/xsd:schema/xsd:complexType"/>
	<xsl:variable name="allSimpleTypes" select="/data/file/xsd:schema/xsd:simpleType"/>
	<xsl:variable name="allTypes" select="$allComplexTypes|$allSimpleTypes"/>
	<xsl:variable name="allComponents" select="$allElements|$allComplexTypes|$allSimpleTypes"/>
	<xsl:variable name="allGroups" select="/data/file/xsd:schema/xsd:group"/>

	<xsl:variable name="pretty.area">
		<xsl:call-template name="get.area"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="Init.Upper">
			<xsl:with-param name="str" select="$view"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="area.map">
		<area in="cm" pretty="Commodities" />
	</xsl:variable>
	<xsl:template name="get.area">
		<xsl:variable name="pretty" select="common:node-set($area.map)/area[@in=$area]"/>
		<xsl:choose>
			<xsl:when test="$pretty">
				<xsl:value-of select="$pretty/@pretty"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="Init.Upper">
					<xsl:with-param name="str" select="$area"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- body structure -->
	<xsl:template name="doBody">
		<xsl:call-template name="doApplicability"/>
		<xsl:call-template name="doSimpleTypes"/>
		<xsl:call-template name="doComplexTypes"/>
		<xsl:call-template name="doElements"/>
		<xsl:call-template name="doGroups"/>
		<xsl:call-template name="dumpSchema"/>
	</xsl:template>

	<xsl:template mode="componentApplicability" match="node()" priority="-1" />
	<xsl:template mode="componentApplicability" match="xsd:annotation|xsd:appinfo">
		<xsl:apply-templates mode="componentApplicability" select="*"/>
	</xsl:template>
	<!-- Generate global elements documentation -->
	<xsl:template name="doElements">
		<xsl:call-template name="doComponentSection">
			<xsl:with-param name="components" select="$elements"/>
			<xsl:with-param name="title" select="'Global Elements'"/>
			<xsl:with-param name="description" select="'elements'"/>
			<xsl:with-param name="anchor" select="'GlobalElements'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Generate global group documentation -->
	<xsl:template name="doGroups">
		<xsl:call-template name="doComponentSection">
			<xsl:with-param name="components" select="$groups"/>
			<xsl:with-param name="title" select="'Groups'"/>
			<xsl:with-param name="description" select="'groups'"/>
			<xsl:with-param name="anchor" select="'Groups'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Generate global complex type documentation -->
	<xsl:template name="doComplexTypes">
		<xsl:call-template name="doComponentSection">
			<xsl:with-param name="components" select="$complexTypes"/>
			<xsl:with-param name="title" select="'Complex Types'"/>
			<xsl:with-param name="description" select="'complex types'"/>
			<xsl:with-param name="anchor" select="'ComplexTypes'"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Generate global simple type documentation -->
	<xsl:template name="doSimpleTypes">
		<xsl:call-template name="doComponentSection">
			<xsl:with-param name="components" select="$simpleTypes"/>
			<xsl:with-param name="title" select="'Simple Types'"/>
			<xsl:with-param name="description" select="'simple types'"/>
			<xsl:with-param name="anchor" select="'SimpleTypes'"/>
		</xsl:call-template>
	</xsl:template>


	<!-- other documentation -->
	<xsl:template mode="otherDocumentation" match="xsd:complexType|xsd:simpleType">
		<xsl:apply-templates mode="derivedFrom" select="*"/>
		<xsl:call-template name="derivedTypes"/>
	</xsl:template>

	<xsl:template mode="otherDocumentation" match="node()" />

	<!-- descriptions -->

	<xsl:template mode="describeComponent" match="xsd:choice">
		<xsl:call-template name="describeChoice"/>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:complexType|xsd:simpleType|xsd:complexContent|xsd:simpleContent|xsd:sequence">
		<xsl:apply-templates select="*" mode="describeComponent"/>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:restriction">
		<xsl:call-template name="describeRestriction"/>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:extension">
		<xsl:call-template name="describeExtension"/>
		<xsl:apply-templates select="*" mode="docAttributes"/>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:annotation|xsd:documentation">
		<!-- <xsl:apply-templates select="*"/> -->
	</xsl:template>
	<!-- usage -->
	<xsl:template mode="usedBy" match="xsd:element">
		<xsl:variable name="target" select="@name"/>
		<xsl:apply-templates select="$allElements[.//xsd:element/@ref = $target]" mode="generateUse">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="$allComplexTypes[.//xsd:element/@ref = $target]" mode="generateUse">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="usedBy" match="xsd:group">
		<xsl:variable name="target" select="@name"/>
		<xsl:apply-templates select="$allComplexTypes[.//xsd:group/@ref = $target]" mode="generateUse">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
	</xsl:template>
		
	<xsl:template mode="usedBy" match="xsd:complexType|xsd:simpleType">
		<xsl:call-template name="generateTypeUse"/>
	</xsl:template>

	<!-- Generate references to/uses of a type -->
	<xsl:template name="generateTypeUse">
		<xsl:param name="target" select="@name|@ref"/>
		<!-- all components (elements, complex and simple types) that use the type -->
		<xsl:for-each select="$allComponents">
			<xsl:sort select="@name"/>
			<!-- if we are extending/restricting the type and aren't directly
		     defining a global element, link it -->
			<xsl:if test=".//xsd:*[(@base = $target) and (local-name(../../..) != 'schema')]">
				<xsl:apply-templates mode="generateUse" select="."/>
			</xsl:if>
			<xsl:apply-templates select=".//xsd:element[@type = $target]" mode="generateUse">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!-- derivation -->
	<xsl:template mode="derivationLabel" match="xsd:extension">Extension of:</xsl:template>
	<xsl:template mode="derivationLabel" match="xsd:restriction">Restriction of:</xsl:template>
	<xsl:template mode="derivedFrom" match="node()"/>
	<xsl:template mode="derivedFrom" match="xsd:complexContent|xsd:simpleContent">
		<xsl:apply-templates mode="derivedFrom" select="*"/>
	</xsl:template>

<!-- Referencing -->

	<!-- Generate a link to an element -->
	<xsl:template name="deRefElement">
		<xsl:param name="ref" select="@ref"/>
		<xsl:variable name="elem" select="$allElements[@name=$ref]"/>
		<xsl:choose>
			<xsl:when test="$elem">
				<xsl:apply-templates select="$elem" mode="linkToComponent"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ref"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- cardinality -->

	<xsl:template name="cardinality">
		<xsl:call-template name="describeCardinality">
			<xsl:with-param name="minNo" select="@minOccurs"/>
			<xsl:with-param name="maxNo" select="@maxOccurs"/>
		</xsl:call-template>
		<xsl:apply-templates mode="cardinalityOverride" select="xsd:annotation/xsd:appinfo/view:override" >
			<xsl:with-param name="minNo" select="@minOccurs"/>
			<xsl:with-param name="maxNo" select="@maxOccurs"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="cardinalityOverride" match="node()" priority="-1"/>

	<xsl:template mode="cardinalityOverride" match="view:override[@minOccurs]">
		<xsl:param name="minNo"/>
		<xsl:call-template name="describeCardinalityOverride">
			<xsl:with-param name="minNo" select="$minNo"/>
			<xsl:with-param name="maxNo" select="@maxOccurs"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="cardinalityOverride" match="view:override[@minOccurs]">
		<xsl:param name="maxNo"/>
		<xsl:call-template name="describeCardinalityOverride">
			<xsl:with-param name="minNo" select="@minOccurs"/>
			<xsl:with-param name="maxNo" select="$maxNo"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="cardinalityOverride" match="view:override[@minOccurs and @maxOccurs]" priority="5">
		<xsl:call-template name="describeCardinalityOverride">
			<xsl:with-param name="minNo" select="@minOccurs"/>
			<xsl:with-param name="maxNo" select="@maxOccurs"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="cardinalityOverride" match="view:override[@skip='true']" priority="6">
		<xsl:text> [Not available in "</xsl:text>
		<xsl:value-of select="@view"/>
		<xsl:text>" view] </xsl:text>
	</xsl:template>

	<xsl:template name="describeCardinalityOverride" match="view:override">
		<xsl:text> [Overriden in "</xsl:text>
		<xsl:value-of select="@view"/>
		<xsl:text>" view to: </xsl:text>
		<xsl:call-template name="describeCardinality">
			<xsl:with-param name="minNo" select="@minOccurs"/>
			<xsl:with-param name="maxNo" select="@maxOccurs"/>
		</xsl:call-template>
		<xsl:text>] </xsl:text>
	</xsl:template>
	<xsl:template name="describeCardinality">
		<xsl:param name="minNo"/>
		<xsl:param name="maxNo"/>
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="$minNo='0'"> zero </xsl:when>
				<xsl:when test="$minNo='unbounded'"> any number of </xsl:when>
				<xsl:otherwise> one </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="max">
			<xsl:choose>
				<xsl:when test="$maxNo='0'"> zero </xsl:when>
				<xsl:when test="$maxNo='unbounded'"> any number of </xsl:when>
				<xsl:otherwise> one </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$min=$max">
				<xsl:text>exactly one occurrence</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="normalize-space($max) = 'one'">
						<xsl:value-of select="normalize-space($min)"/> or <xsl:value-of select="normalize-space($max)"/><xsl:text> occurence(s)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space($min)"/> or <xsl:value-of select="normalize-space($max)"/><xsl:text> occurrences</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Describe attributes -->
	<xsl:template match="xsd:*" mode="docAttributes"/>

	<!-- Describe a element -->
	<xsl:template name="describeElement">
		<xsl:choose>
			<xsl:when test="@ref">
				<xsl:variable name="ref" select="@ref"/>
				<b>
					<xsl:apply-templates select="." mode="deRefElement"/>
				</b>
				<b>
					<xsl:value-of select="@ref"/>
				</b>
			</xsl:when>
			<xsl:otherwise>
				<b>
					<xsl:value-of select="@name"/>
				</b>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>(</xsl:text><xsl:call-template name="cardinality"/><xsl:text>;</xsl:text>
		<!-- Determine type or content -->
		<xsl:choose>
			<xsl:when test="@ref">
				<xsl:variable name="ref" select="@ref"/>
				<xsl:choose>
					<xsl:when test="$allElements[@name=$ref]">
						<xsl:for-each select="$allElements[@name=$ref]">
							<xsl:call-template name="describeElementType"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> defined in an imported schema) </xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="describeElementType"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template mode="describeComponent" match="xsd:group">
		<xsl:call-template name="describeGroup"/>
	</xsl:template>
	<!-- image lookup -->
	<xsl:template match="node()" mode="findImage">
		<xsl:variable name="target">
			<xsl:apply-templates select="." mode="imageTarget"/>
		</xsl:variable>
		<!--
		<xsl:variable name="verfile" select="document('../src/fpml-version.xml')/wrapper"/>
		-->
		<xsl:variable name="imageSuffix">
			<xsl:choose>
				<xsl:when test="$is.master"></xsl:when>
				<xsl:otherwise>
					<xsl:text>_httpwww.fpml.orgFpML</xsl:text>
					<!--
					<xsl:value-of select="$verfile/@major"/>
					<xsl:value-of select="$verfile/@minor"/>
					-->
					<xsl:text>50</xsl:text>

					<xsl:value-of select="$view"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="outputImage">
			<xsl:with-param name="loc" select="concat($target, $imageSuffix)"/>
		</xsl:call-template>
		<!--
		<xsl:for-each select="$imageMap//entry[@path=$target]">
			<xsl:apply-templates mode="outputImage" select="."/>
		</xsl:for-each>
		-->
	</xsl:template>

	<!-- image lookup -->
	<!--
	<xsl:template match="xsd:element" mode="imageTarget">
		<xsl:value-of select="concat('e:',@name)"/>
	</xsl:template>
	<xsl:template match="xsd:complexType" mode="imageTarget">
		<xsl:value-of select="concat('t:',@name)"/>
	</xsl:template>
	<xsl:template match="xsd:group" mode="imageTarget">
		<xsl:value-of select="concat('mg:',@name)"/>
	</xsl:template>
	-->
	<xsl:template match="xsd:element" mode="imageTarget">
		<xsl:value-of select="concat('element_',@name)"/>
	</xsl:template>
	<xsl:template match="xsd:attributeGroup" mode="imageTarget">
		<xsl:value-of select="concat('attributeGroup',@name)"/>
	</xsl:template>
	<xsl:template match="xsd:complexType" mode="imageTarget">
		<xsl:value-of select="concat('type_',@name)"/>
	</xsl:template>
	<xsl:template match="xsd:group" mode="imageTarget">
		<xsl:value-of select="concat('group_',@name)"/>
	</xsl:template>
</xsl:stylesheet>
