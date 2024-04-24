<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 

	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:gcl	= "http://xml.genericode.org/2004/ns/CodeList/0.2/" 
 	xmlns:doc	= "http://www.fpml.org/coding-scheme/documentation" 

	exclude-result-prefixes = "gcl doc"
	>

<xsl:import href = "identity-transform+element-content.xsl" />
	
<xsl:output method="xml" encoding="utf-8" indent="yes" />


<xsl:template match = "ComplexValue" mode = "element.content">
	
	<xsl:variable name = "definition-mapping"	select = "doc:definedIn|doc:mapsFrom2006Fro|doc:mapsTo2021Fro" />
	
	<xsl:apply-templates select = "doc:froType" />
	<xsl:apply-templates select = "." mode = "definition" />
	<xsl:apply-templates select = "." mode = "mapping" />
	<xsl:apply-templates select = "$definition-mapping[last()]/following-sibling::*[not(self::doc:froType)]" />
	
</xsl:template>


<!-- fallback -->
<xsl:template match = "ComplexValue" mode = "definition" />

<xsl:template match = "ComplexValue[doc:definedIn]" mode = "definition">
	<xsl:element name = "doc:definition">
		<xsl:apply-templates select = "doc:definedIn" />
	</xsl:element>
</xsl:template>


<xsl:template match = "doc:definedIn">
	<xsl:apply-templates select = "self::*[contains(.,'2000')]" mode = "version">
		<xsl:with-param name = "version" select = "2000" />
	</xsl:apply-templates>
	<xsl:apply-templates select = "self::*[contains(.,'2006')]" mode = "version">
		<xsl:with-param name = "version" select = "2006" />
	</xsl:apply-templates>
	<xsl:apply-templates select = "self::*[contains(.,'2021')]" mode = "version">
		<xsl:with-param name = "version" select = "2021" />
	</xsl:apply-templates>
</xsl:template>

<xsl:template match = "doc:definedIn" mode = "version">
	<xsl:param name = "version"	select = "1900" />
	<xsl:element name = "doc:reference">
		<xsl:attribute name = "title">
			<xsl:value-of select = "concat($version,' ISDA Definitions')" />
		</xsl:attribute>
		<xsl:attribute name = "version">
			<xsl:value-of select = "$version" />
		</xsl:attribute>			
	</xsl:element>
</xsl:template>


<!-- fallback -->
<xsl:template match = "ComplexValue" mode = "mapping" />

<xsl:template match = "ComplexValue[doc:mapsFrom2006Fro|doc:mapsTo2021Fro]" mode = "mapping">
	<xsl:element name = "doc:mapping">
		<xsl:apply-templates select = "doc:mapsFrom2006Fro|doc:mapsTo2021Fro" />
	</xsl:element>
</xsl:template>

<xsl:template match = "doc:mapsFrom2006Fro|doc:mapsTo2021Fro">
	<xsl:variable name = "this.name"	select = "local-name()" />
	<xsl:variable name = "fromTo"		select = "substring-before(substring($this.name,5),'20')" />
	<xsl:element name = "{concat('doc:',translate($fromTo,'FT','ft'))}">
		<xsl:attribute name = "version">
			<xsl:value-of select = "substring(substring-after($this.name,$fromTo),1,4)" />
		</xsl:attribute>
		<xsl:value-of select = "." />
	</xsl:element>
</xsl:template>


<xsl:template match = "doc:method">
	<xsl:element name = "doc:calculationParameters">
		<xsl:apply-templates select = "." mode = "element.copy" />
	</xsl:element>
</xsl:template>


<xsl:template match = "doc:isoCode">
	<xsl:element name = "doc:external">
		<xsl:element name = "doc:code">
			<xsl:attribute name = "source">
				<xsl:value-of select = "'iso'" />
			</xsl:attribute>			
			<xsl:attribute name = "enum">
				<xsl:value-of select = "'BenchmarkCurveNameCode'" />
			</xsl:attribute>			
			<xsl:apply-templates select = "text()" />
		</xsl:element>
	</xsl:element>
</xsl:template>


<xsl:template match = "doc:froType">
	<xsl:element name = "doc:class">
		<xsl:apply-templates select = "text()" />
	</xsl:element>
</xsl:template>


</xsl:stylesheet>