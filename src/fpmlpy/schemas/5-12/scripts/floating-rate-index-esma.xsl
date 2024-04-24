<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.1" 

	xmlns:xsl	= "http://www.w3.org/1999/XSL/Transform"
	xmlns:common="http://exslt.org/common" 
	xmlns:gcl	= "http://xml.genericode.org/2004/ns/CodeList/0.2/" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation"
	exclude-result-prefixes="common">

<xsl:import href = "floating-rate-index.extract.xsl" />
 
<xsl:output method="text" encoding="utf-8" />

<xsl:variable name = "alpha.lower"	select = "'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name = "alpha.upper"	select = "'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<!-- MiFIR transaction reporting validation rules -->
<xsl:variable name = "digits"		select = "'123456789'" />
<xsl:variable name = "delim" 		select = "$tab" />


<xsl:variable name = "Indx" select = "document('../src/BenchmarkCurveName.map.xml')//Indx" />

<xsl:template match = "Row" mode="gen-iso">
	<xsl:variable name="froName" select="Value[1]/SimpleValue"/>
	<xsl:variable name="style" select="Value[4]/SimpleValue"/>

	<xsl:call-template name="generate-iso-code">
		<xsl:with-param name="froName" select="$froName"/>
		<xsl:with-param name="style" select="$style"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match = "index" mode="gen-iso">
	<xsl:variable name="froName" select="name"/>
	<xsl:variable name="style">
		<xsl:copy-of 	select="froType" />
		<xsl:if test="method = 'OIS Compounding'"><style>OIS</style></xsl:if>
		<xsl:if test="method = 'OIS Compounding'"><style>OIS</style></xsl:if>
		<xsl:if test="style = 'Index'"><style>Index</style></xsl:if>
	</xsl:variable>

	<xsl:call-template name="generate-iso-code">
		<xsl:with-param name="froName" select="$froName"/>
		<xsl:with-param name="style" select="common:node-set($style)/*"/>
	</xsl:call-template>
</xsl:template>


<xsl:template name = "generate-iso-code">
	<xsl:param name="froName"/>
	<xsl:param name="style"/>

	<xsl:variable name = "this.indx" select = "$Indx[normalize-space(@token)!=''][contains($froName,@token)][not($style=exclude/@style)][not(normalize-space(exclude/@token)!='' and contains($froName,exclude/@token))]" />

	<xsl:variable name="styletxt" select="$style/text()"/>
		<!--  We are not including the compressed code at the moment -->
		<!--
	<xsl:choose>

		<xsl:when test =  "not($this.indx)">
			<doc:code target="iso20022" method="CompressedIndexCode" >
				<xsl:if test="$style"><xsl:attribute name="style"><xsl:value-of select="$styletxt"/></xsl:attribute></xsl:if>
				<xsl:apply-templates select = "$froName" mode = "compress" />
			</doc:code>
		</xsl:when>
		
		<xsl:otherwise>
		-->
	<xsl:if test="$this.indx">
			<!-- ISO BenchmarkCurveName2Code -->
			<!--
			<xsl:for-each select = "$this.indx">
				<xsl:if test="position()&gt;1">,</xsl:if>
				<xsl:value-of select = "@token" />
			</xsl:for-each>
			<xsl:value-of select = "$delim" />
			-->

			<doc:code target="iso20022" method="BenchmarkCurveNameCode" >
				<xsl:if test="$style"><xsl:attribute name="style"><xsl:value-of select="$styletxt"/></xsl:attribute></xsl:if>
				<!-- <xsl:copy-of select="$style"/> -->
				<xsl:apply-templates select = "$this.indx[not(@priority&lt;$this.indx/@priority)]" />
			</doc:code>

	</xsl:if>
	<!--
		</xsl:otherwise>
	</xsl:choose>
	-->


</xsl:template>


<!--
<xsl:template match = "Value[1]/SimpleValue">
	<xsl:variable name = "index.strip">
		<xsl:apply-templates select = "." mode = "strip" />
	</xsl:variable>
	<xsl:value-of select = "." />
	<xsl:value-of select = "$delim" />
	<xsl:apply-templates select = "ancestor::Row/Value[4]" />
	<xsl:value-of select = "$delim" />
	<xsl:apply-templates select = "." mode = "compress" />
	<xsl:value-of select = "$delim" />
	<xsl:value-of select = "substring($index.strip,26)" />
</xsl:template>
-->


<xsl:template match = "*" mode = "strip">
	<!-- extract & remove non-alphanumeric chars, truncate to 25 chars -->
	<xsl:variable name = "index.upper"	select = "translate(.,$alpha.lower,$alpha.upper)" />
	<xsl:variable name = "char.special"	select = "translate($index.upper, concat($alpha.upper,$digits),'')" />
	<xsl:value-of select = "translate($index.upper, $char.special,'')" />
</xsl:template>


<xsl:template match = "*" mode = "compress">
	<xsl:variable name = "index.strip">
		<xsl:apply-templates select = "." mode = "strip" />
	</xsl:variable>
	<xsl:value-of select = "substring($index.strip,1,25)" />
</xsl:template>


<xsl:template match = "Indx">
	<!--
	<xsl:value-of select = "@token" />
	<xsl:value-of select = "$delim" />
	-->
	<xsl:value-of select = "@code" />
</xsl:template>


<!-- override for column headings -->
<xsl:template match = "ColumnSet">

	<xsl:apply-templates select = "Column[1]|Column[4]" />

	<xsl:value-of select = "concat(

		$delim,
		'Compressed(Prefix)',

		$delim,
		'Compressed(Tail)',

		$delim,
		'Match Token(s)',

		$delim,
		'Resolved Token',

		$delim,
		'ISO Code',

		$delim,
		'Max25Text',

		$nl

		)" />
	
</xsl:template>

</xsl:stylesheet>
