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
	exclude-result-prefixes="xsl xsd ">

<xsl:output method="text" /> 

<xsl:param name="schemefile" select="'../src/fpml-schemeDefinitions.xml'"/>
<xsl:variable name="schemedata" select="document($schemefile)/schemeDefinitions"/>
<xsl:param name="filename" />

<!-- The main template -->
<xsl:template match="/">
	<!-- <xsl:text>Validating schemes</xsl:text> -->
	<xsl:apply-templates select="*" mode = "validate-schemes"/>
<!--
<xsl:text>
</xsl:text>
-->
</xsl:template>
	
<xsl:template mode="validate-schemes" match="*">
	<xsl:apply-templates select="*" mode = "validate-schemes"/>
</xsl:template>

<xsl:template mode="validate-schemes" match="*[contains(local-name(@*),'Scheme')]">
	<xsl:variable name="scheme" select="local-name(@*[contains(local-name(.),'Scheme')])"/>
	<xsl:variable name="uri" select="@*[local-name(.)=$scheme]"/>
	<xsl:variable name="schemeName">
		<xsl:choose>
			<xsl:when test="$scheme = 'quantityUnitScheme'">priceQuoteUnitsScheme</xsl:when>
			<xsl:when test="$scheme = 'quantityFrequencyScheme'">commodityQuantityFrequencyScheme</xsl:when>
			<xsl:when test="$scheme = 'commodityBaseScheme' and $uri = 'http://www.fpml.org/coding-scheme/commodity-code'">commodityCodeScheme</xsl:when>
			<xsl:otherwise><xsl:value-of select="$scheme"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="val" select="normalize-space(.)"/>

<!--
<xsl:text>
</xsl:text>
	<xsl:text>Found element </xsl:text><xsl:value-of select="local-name(.)"/>
	<xsl:text> and value=</xsl:text>
	<xsl:value-of select="$val"/>
	<xsl:text> and scheme=</xsl:text>
	<xsl:value-of select="$scheme"/>
	<xsl:text> and URI=</xsl:text>
	<xsl:value-of select="$uri"/>
	<xsl:text>
</xsl:text>
-->

	<xsl:variable name="scheme.contents" 
		select="$schemedata/scheme[@name=$schemeName and contains($uri, @canUri)]/schemeValues"/>
	<xsl:choose>
		<xsl:when test="not($scheme.contents)">
			<!-- the following schemes aren't defaulted so can't be checked -->
			<xsl:if test="not($scheme = 'currencyScheme')
					and not($scheme = 'conversationIdScheme')
					and not($scheme = 'tradeIdScheme')
					and not($scheme = 'issuerIdScheme')
					and not($scheme = 'contractIdScheme')
					and not($scheme = 'positionIdScheme')
					and not($scheme = 'productIdScheme')
					and not($scheme = 'linkIdScheme')
					and not($scheme = 'legIdScheme')
					and not($scheme = 'accountIdScheme')
					and not($scheme = 'resourceIdScheme')
					and not($scheme = 'languageScheme')
					and not($scheme = 'mainPublicationScheme')
					and not($scheme = 'mimeTypeScheme')
					and not($scheme = 'entityIdScheme')
					and not($scheme = 'entityNameScheme')
					and not($scheme = 'indexIdScheme')
					and not($scheme = 'indexNameScheme')
					and not($scheme = 'basketIdScheme')
					and not($scheme = 'basketNameScheme')
					and not($scheme = 'facilityTypeScheme')
					and not($scheme = 'mortgageSectorScheme')
					and not($scheme = 'settledEntityMatrixSourceScheme')
					and not($scheme = 'lienScheme')
					and not($scheme = 'loanTrancheScheme')
					and not($scheme = 'instrumentIdScheme')
					and not($scheme = 'futureIdScheme')
					and not($scheme = 'partyIdScheme')
					and not($scheme = 'creditRatingScheme')
					and not($scheme = 'industryClassificationScheme')
					and not($scheme = 'exchangeIdScheme')
					and not($scheme = 'floatingRateIndexScheme')
					and not($scheme = 'messageIdScheme')
					and not($scheme = 'routingIdScheme')
					and not($scheme = 'routingIdCodeScheme')
					and not($scheme = 'productTypeScheme')
					and not($scheme = 'valuationSetDetailScheme')
					and not($scheme = 'tradeCashflowsIdScheme')
					and not($scheme = 'tradeCashflowsStatusScheme')
					and not($scheme = 'paymentIdScheme')
					and not($scheme = 'cashflowIdScheme')
					and not($scheme = 'paymentIdScheme')
					and not($scheme = 'matchIdScheme')
					and not($scheme = 'queryParameterIdScheme')
					and not($scheme = 'rateSourcePageScheme')
					and not($scheme = 'validationScheme')
					and not($scheme = 'countryScheme')
					and not($scheme = 'additionalDataScheme')
					and not($scheme = 'correlationIdScheme')
					and not($scheme = 'messageAddressScheme')
					and not($scheme = 'creditSupportAgreementIdScheme')
					and not($scheme = 'implementationSpecificationVersionScheme')
					and not($scheme = 'portfolioNameScheme')
					and not($scheme = 'executionDateTimeScheme')
					and not($scheme = 'reasonCodeScheme')
					and not($scheme = 'regulatorIdScheme')
					and not($scheme = 'reportIdScheme')
					and not($scheme = 'timezoneLocationScheme')
					and not($uri= 'cme_cashflow_type')
					and not($uri= 'cme_measure_code')
					" >
					<xsl:value-of select="$filename"/>: ***<xsl:value-of select="$schemeName"/>
					<xsl:text> not found; value = </xsl:text>
					<xsl:value-of select="$val"/>
					<xsl:text>, uri = </xsl:text>
					<xsl:value-of select="$uri"/>
					<xsl:text>
</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			<xsl:when test="$scheme.contents/schemeValue[@name=$val]">
<!-- found <xsl:value-of select="$val"/> in <xsl:value-of select="$scheme"/>
-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$filename"/>: ***Didn't find <xsl:value-of select="$val"/> in <xsl:value-of select="$schemeName"/><xsl:text>
</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

	


</xsl:stylesheet>

