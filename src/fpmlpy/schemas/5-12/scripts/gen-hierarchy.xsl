<?xml version="1.0" encoding="utf-8" ?>

<!--
	Before you can run this script to generate the FpML documentation
	you must merge the schema files into one file
 -->


<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:fmt="xalan://com.ibm.fpml.xslt.Format"
	xmlns:common="http://exslt.org/common"
	exclude-result-prefixes="xsl xsd fmt common">

<xsl:output encoding="UTF-8" indent="yes" method="xml" cdata-section-elements="programlisting"/> <!-- added BAL for formatting -->
<xsl:param name="schema" select="'default value'"/>
<xsl:param name="area" select="'Unknown'"/>
<xsl:param name="date" select="'default value'"/>
<xsl:param name="lang" select="'en'"/>
<xsl:param name="file-suffix" select="'html'"/>	<!-- html or pdf -->


<!-- Create nodesets for the section to be processed -->
<xsl:variable name="subschema" select="/data/file[@name=$schema]"/>
<xsl:variable name="elements" select="$subschema/xsd:schema/xsd:element"/>
<xsl:variable name="complexTypes" select="$subschema/xsd:schema/xsd:complexType"/>
<xsl:variable name="simpleTypes" select="$subschema/xsd:schema/xsd:simpleType"/>

<!-- Create nodesets for all global elements and type definitions -->
<xsl:variable name="allGlobalElements" select="/data/file/xsd:schema/xsd:element"/>
<xsl:variable name="allLocalElements" select="/data/file/xsd:schema/*//xsd:element[@name]"/>
<xsl:variable name="allLocalGroups" select="/data/file/xsd:schema/*//xsd:group"/>
<xsl:variable name="allComplexTypes" select="/data/file/xsd:schema/xsd:complexType"/>
<xsl:variable name="allSimpleTypes" select="/data/file/xsd:schema/xsd:simpleType"/>
<xsl:variable name="allGroups" select="/data/file/xsd:schema/xsd:group"/>

<!-- xref config file -->
<!--
<xsl:param name="config-file" select="'../src/fpml-xref-patterns.xml'"/>
<xsl:variable name="config" select="document($config-file)/xref"/>
-->

<!--  version file -->
<xsl:param name="version-file" select="'../src/fpml-version.xml'"/>
<xsl:variable name="version" select="document($version-file)/wrapper"/>

<!-- The main template -->
<xsl:template match="/">
	<all>
		<xsl:variable name="typesTF">
			<xsl:apply-templates select="$allComplexTypes" mode="hierarchy"/>
		</xsl:variable>
		<xsl:variable name="types" select="common:node-set($typesTF)"/>
		<allTypes>
			<xsl:copy-of select="$types/*"/>
		</allTypes>
		<simpleDerivedTypes>
			<xsl:variable name="simple">
				<foo>
					<xsl:copy-of select="$types/*[@derivation='simple']" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($simple)/*" mode="sort-by-parentType"/>
		</simpleDerivedTypes>
		<complexDerivedTypes>
			<xsl:variable name="complex">
				<foo>
					<xsl:copy-of select="$types/*[@derivation='complex']" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($complex)/*" mode="sort-by-parentType"/>
		</complexDerivedTypes>
		<messages>
			<xsl:variable name="messages">
				<foo>
					<xsl:copy-of select="$types/*[(@derivation='complex') 
						and contains(@parentType, 'Message')
						and (@parentType != 'Message')
						and not(contains(@parentType,'Header'))
						]" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($messages)/*" mode="sort-by-parentType"/>
		</messages>
		<notificationMessages>
			<xsl:variable name="messages">
				<foo>
					<xsl:copy-of select="$types/*[(@derivation='complex') 
						and contains(@parentType, 'Message')
						and (@parentType != 'Message')
						and not(contains(@parentType,'Header'))
						and contains(@parentType,'Notification')
						]" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($messages)/*" mode="sort-by-parentType"/>
		</notificationMessages>
		<requestMessages>
			<xsl:variable name="messages">
				<foo>
					<xsl:copy-of select="$types/*[(@derivation='complex') 
						and contains(@parentType, 'Message')
						and (@parentType != 'Message')
						and not(contains(@parentType,'Header'))
						and contains(@parentType,'Request')
						]" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($messages)/*" mode="sort-by-parentType"/>
		</requestMessages>
		<responseMessages>
			<xsl:variable name="messages">
				<foo>
					<xsl:copy-of select="$types/*[(@derivation='complex') 
						and contains(@parentType, 'Message')
						and (@parentType != 'Message')
						and not(contains(@parentType,'Header'))
						and contains(@parentType,'Response')
						]" />
				</foo>
			</xsl:variable>
			<xsl:apply-templates select="common:node-set($messages)/*" mode="sort-by-parentType"/>
		</responseMessages>
		<!--
		<types>
			<xsl:copy-of select="$allComplexTypes"/>
		</types>
		<hierarchy>
			<types>
				<xsl:copy-of select="$types"/>
			</types>
			<xsl:for-each select="$types">
				<xsl:sort select="@derivation"/>
				<xsl:sort select="@parentType"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</hierarchy>
		-->
	</all>
</xsl:template>

<xsl:template match="*" mode="sort-by-parentType">
	<xsl:for-each select="*">
		<xsl:sort select="@parentType"/>
		<xsl:sort select="@name"/>
		<xsl:copy-of select="."/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="node()" mode="hierarchy" priority="-10">
	<xsl:apply-templates mode="hierarchy"/>
</xsl:template>

<xsl:template match="xsd:complexType[xsd:simpleContent]" mode="hierarchy">
	<complexType name="{@name}" derivation="simple" parentType="{xsd:simpleContent/xsd:extension/@base}" />
</xsl:template>

<xsl:template match="xsd:complexType[xsd:complexContent]" mode="hierarchy">
	<complexType name="{@name}" derivation="complex" 
		parentType="{(xsd:complexContent/xsd:extension|xsd:complexContent/xsd:restriction)/@base}" />
</xsl:template>

<xsl:template match="xsd:complexType" mode="hierarchy" priority="-1">
	<complexType name="{@name}" derivation="none" />
</xsl:template>


</xsl:stylesheet>

