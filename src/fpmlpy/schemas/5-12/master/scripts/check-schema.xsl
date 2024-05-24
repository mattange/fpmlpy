<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files, and translate for view-specific overrides -->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:view="http://www.fpml.org/views" 
	xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
	exclude-result-prefixes="common xsd xsi"
	>

	<xsl:param name="file" select="'unknown file'"/>

        <xsl:template match="/">
		<xsl:apply-templates mode="validate-component" select="*"/>
        </xsl:template>

	<xsl:template match="xsd:*" mode="validate-component">
		<xsl:apply-templates mode="validate-component" select="*"/>
        </xsl:template>

	<xsl:template match="node()" mode="validate-component"/>

	<xsl:template match="xsd:complexType" mode="validate-component">
		<xsl:apply-templates mode="validate-name" select="."/>
		<xsl:if test="not(@abstract='true') and (count(*) - count(xsd:annotation))=0 and not(@name='Empty')">
			<xsl:message><xsl:value-of select="$file"/>: Undefined content model in <xsl:value-of select="@name"/></xsl:message>
		</xsl:if>
		<xsl:apply-templates mode="validate-subcomponent" select="*">
			<xsl:with-param name="component" select="@name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="xsd:simpleType" mode="validate-component">
		<xsl:apply-templates mode="validate-name" select="."/>
	</xsl:template>

	<xsl:template match="xsd:element" mode="validate-component">
		<xsl:apply-templates mode="validate-name" select="."/>
		<xsl:if test="not(@type) and ((count(*) - count(xsd:annotation))=0) and not(@abstract='true')">
			<xsl:message><xsl:value-of select="$file"/>: Undefined content model in <xsl:value-of select="@name"/></xsl:message>
		</xsl:if>
	</xsl:template>


	<xsl:template match="xsd:group" mode="validate-component">
		<xsl:apply-templates mode="validate-name" select="."/>
		<xsl:apply-templates mode="validate-subcomponent" select="*">
			<xsl:with-param name="component" select="@name"/>
		</xsl:apply-templates>
	</xsl:template>



	<xsl:template match="xsd:annotation" mode="validate-subcomponent"/>
	<xsl:template match="node()" mode="validate-subcomponent" priority="-1"/>

	<xsl:template match="xsd:element" mode="validate-subcomponent">
		<xsl:param name="component"/>
		<xsl:if test="not(@ref)">
			<xsl:apply-templates mode="validate-name" select="."/>
		</xsl:if>
		<xsl:apply-templates mode="validate-subcomponent" select="*">
			<xsl:with-param name="component" select="$component"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="xsd:complexType" mode="validate-subcomponent">
		<xsl:param name="component"/>
		<xsl:message><xsl:value-of select="$file"/>: Illegal nested type in <xsl:value-of select="$component"/></xsl:message>
	</xsl:template>

	<xsl:template match="*" mode="validate-subcomponent">
		<xsl:param name="component"/>
		<xsl:apply-templates mode="validate-subcomponent" select="*">
			<xsl:with-param name="component" select="$component"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="xsd:complexType|xsd:simpleType" mode="validate-name">
		<xsl:variable name="prnt" select="ancestor::*[@name][1]/@name"/>
		<xsl:if test="not(@name)">
			<xsl:message><xsl:value-of select="$file"/>:Missing type name on <xsl:value-of select="local-name(.)"/>
				<xsl:if test="$prnt"> within <xsl:value-of select="$prnt"/></xsl:if>.</xsl:message>
		</xsl:if>
		<xsl:variable name="first" select="substring(@name, 1, 1)"/>
		<xsl:variable name="upper" select="translate($first,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		<xsl:if test="not($first = $upper)">
			<xsl:message><xsl:value-of select="$file"/>:Bad type name <xsl:value-of select="@name"/> - not capitalized</xsl:message>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsd:group" mode="validate-name">
		<xsl:if test="not(@name)">
			<xsl:message><xsl:value-of select="$file"/>:Missing group name.</xsl:message>
		</xsl:if>
		<xsl:variable name="first" select="substring(@name, 1, 1)"/>
		<xsl:variable name="upper" select="translate($first,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		<xsl:if test="not(substring-after(@name, '.') = 'model')">
			<xsl:message><xsl:value-of select="$file"/>:Bad group name <xsl:value-of select="@name"/> - missing ".model"</xsl:message>
		</xsl:if>
		<xsl:if test="not($first = $upper)">
			<xsl:message><xsl:value-of select="$file"/>:Bad group name <xsl:value-of select="@name"/> - not capitalized</xsl:message>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsd:element" mode="validate-name">
		<xsl:if test="not(@name)">
			<xsl:message><xsl:value-of select="$file"/>:Missing element name.</xsl:message>
		</xsl:if>
		<xsl:variable name="first" select="substring(@name, 1, 1)"/>
		<xsl:variable name="upper" select="translate($first,'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		<xsl:if test="$first = $upper">
			<xsl:message><xsl:value-of select="$file"/>:Bad element name <xsl:value-of select="@name"/> - capitalized</xsl:message>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
