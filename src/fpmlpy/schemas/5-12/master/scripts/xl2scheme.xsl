<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="common saxon">


	<xsl:variable name="excel.data.file.name" select="'../fpml_reference_data.xml'"/>

	<xsl:param name="pwd"/>
	<xsl:param name="extended" select="'demo'" />
	<xsl:param name="filter.currency" />
	<xsl:param name="scope"/>
	<xsl:variable name="notscope" select="concat('!', $scope)"/>

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz1234567890_-'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-'" />

	<xsl:variable name="is.extended" select="$extended = 'full'" />

	<xsl:variable name="demo.extended.currencies.TF">
		<currency>CAD</currency>
	</xsl:variable>

	<xsl:variable name="major.currencies.TF">
		<currency>USD</currency>
		<currency>EUR</currency>
		<currency>GBP</currency>
		<currency>JPY</currency>
		<currency>CHF</currency>
		<currency>CAD</currency>
		<currency>AUD</currency>
		<currency>HKD</currency>
	</xsl:variable>

	<xsl:variable name="extended.currencies">
		<xsl:choose>
			<xsl:when test="$extended='demo'">
				<xsl:copy-of select="common:node-set($demo.extended.currencies.TF)"/>
			</xsl:when>
			<xsl:when test="$extended='majors'">
				<xsl:copy-of select="common:node-set($major.currencies.TF)"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="filename.suffix">
		<xsl:choose>
			<xsl:when test="$extended='demo'"/>
			<xsl:when test="$extended='none'"/>
			<xsl:when test="$extended='majors'">-majors</xsl:when>
			<xsl:otherwise>-full</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- uri validation -->
	<xsl:template match="scheme[@name = 'entityIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'entityNameScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'exchangeIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'instrumentIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->

<!-- HTML and catalog processing -->

	<xsl:template name="construct-excel-schemes">
		<xsl:if test="$scope!='no.excel'">
			<xsl:variable name="external.doc" select="document($excel.data.file.name)"/>
			<xsl:message>Excel file is  <xsl:value-of select="$excel.data.file.name"/>, loaded= <xsl:value-of select="count($external.doc/*)"/></xsl:message>
			<xsl:apply-templates mode="construct-schemes" select="$external.doc"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="construct-schemes" priority="-1">
		<xsl:apply-templates mode="construct-schemes" select="*"/>
	</xsl:template>

        <xsl:template match="codingSchemes" mode="construct-schemes">
		<xsl:message>Working on Excel data root</xsl:message>
		<xsl:choose>
			<xsl:when test="$scope='enhanced.excel'">
				<xsl:apply-templates select="*[@inEnhanced='YES']" mode="do-construct-scheme"/>
			</xsl:when>
			<xsl:when test="$scope='basic.excel'">
				<xsl:apply-templates select="*[@inBasic='YES']" mode="do-construct-scheme"/>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>


        <xsl:template match="*" mode="do-construct-scheme">
		<xsl:variable name="def">
			<xsl:apply-templates select="." mode="generate-description"/>
		</xsl:variable>
		<xsl:variable name="deftext" select="common:node-set($def)//doc:definition/text()"/>

		<xsl:element xmlns="" name="scheme" >
			<xsl:copy-of select = "@*"/>
			<xsl:attribute name="source">excel</xsl:attribute>
			<xsl:message>Constructing Excel scheme <xsl:value-of select="@name"/> with element <xsl:value-of select="local-name(.)"/></xsl:message>
			<xsl:message>Def: <xsl:value-of select="$deftext"/></xsl:message>
			<xsl:element xmlns="" name="schemeDefinition">
				<xsl:value-of select="$deftext"/>
			</xsl:element>
			<xsl:element xmlns="" name="schemeValues">
				<xsl:apply-templates select="*" mode="generate-row-html"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- skip fros that are not linked to any Definition -->
	<xsl:template match="index[not(supportedDefinition) and not(inOtherDoc='YES')]" mode="generate-row-html" priority="10"/>

        <xsl:template match="*" mode="generate-row-html" priority="-1">
		<xsl:variable name="code">
			<xsl:apply-templates select="." mode="generate-row-code"/>
		</xsl:variable> 
		<xsl:variable name="desc">
			<xsl:apply-templates select="." mode="generate-row-description"/>
		</xsl:variable> 

		<xsl:element xmlns="" name="schemeValue">
			<xsl:attribute name="name"><xsl:value-of select="common:node-set($code)"/></xsl:attribute>
			<xsl:attribute name="schemeValueSource"><xsl:apply-templates mode="source" select="."/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="froType and method = 'OIS Compounding'">
					<xsl:attribute name="style">OIS/OIS Compounding</xsl:attribute>
				</xsl:when>
				<xsl:when test="froType and not(method)">
					<xsl:attribute name="style">OIS</xsl:attribute>
				</xsl:when>
				<xsl:when test="method = 'OIS Compounding' and not(froType)">
					<xsl:attribute name="style">OIS Compounding</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="inLoan"><xsl:value-of select="inLoan"/></xsl:attribute>
			<xsl:element xmlns="" name="paragraph">
				<xsl:value-of select="common:node-set($desc)"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

<!-- file processing -->

<xsl:template match = "/" >
	<xsl:apply-templates select = "*" />
</xsl:template>

<xsl:template match = "codingSchemes" >
	<xsl:choose>
		<xsl:when test="$is.extended">
			<xsl:apply-templates select = "*[@inEnhanced='YES']"  mode="generate-file"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select = "*[@inBasic='YES']"  mode="generate-file"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
	
	
	
<xsl:template match="*" priority="-2" mode="generate-file">
	<xsl:message>Generated no file for <xsl:value-of select="local-name(.)"/></xsl:message>
</xsl:template>


<xsl:template match="*[@fileName]" priority="1" mode="generate-file">
	<xsl:result-document href="{$pwd}/{@fileName}">
		<xsl:apply-templates select="." mode="generate-data"/>
	</xsl:result-document>
</xsl:template>


	<xsl:template match="floatingRateOptions"  priority="3" mode="generate-file"/>

	<xsl:template match="floatingRateOptions[index]" priority="10" mode="generate-file">
		<xsl:message>uri is <xsl:value-of select="@uri"/></xsl:message>
		<xsl:variable name="filename">
			<xsl:value-of select="substring-before(@fileName,'.')"/>
			<!-- <xsl:value-of select="$filename.suffix"/> -->
			<xsl:text>.</xsl:text>
			<xsl:value-of select="substring-after(@fileName,'.')"/>
		</xsl:variable>
		<xsl:message>file name is <xsl:value-of select="$filename"/></xsl:message>
		<xsl:result-document href="{$pwd}/{$filename}">
			<xsl:apply-templates select="." mode="generate-data"/>
		</xsl:result-document>
	</xsl:template>


	<xsl:template match="*" mode="generate-data">
		<gcl:CodeList xmlns:gcl="http://xml.genericode.org/2004/ns/CodeList/0.2/" xmlns:doc="http://www.fpml.org/coding-scheme/documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xml.genericode.org/2004/ns/CodeList/0.2/ CodeList.xsd">
			<xsl:apply-templates select="." mode="generate-description"/>
			<xsl:apply-templates select="." mode="generate-identification"/>
			<xsl:apply-templates select="." mode="generate-columnset"/>
			<xsl:apply-templates select="." mode="generate-rows"/>
		</gcl:CodeList>
	</xsl:template>

	<xsl:template match="*" mode="generate-description" >
		<Annotation>
			<Description>
				<xsl:apply-templates select="." mode="generate-definition"/>
				<doc:publicationDate><xsl:value-of select="@publicationDate"/></doc:publicationDate>
				<xsl:if test="@status = 'working draft'"><doc:status>working-draft</doc:status></xsl:if>
				<xsl:call-template name="confidentiality"/>
				<xsl:if test="local-name(.) = 'administrators'">
					<doc:disclaimer>Aggregate Information Disclaimer: This content aggregates individual data submissions received by ISDA from third party participants. ISDA does not warrant that such aggregated data is comprehensive, and makes no warranty or guarantees to the accuracy of the underlying data provided by third parties.</doc:disclaimer>
				</xsl:if>
			</Description>
		</Annotation>
	</xsl:template>

	<xsl:template name="confidentiality" >
		<xsl:choose>
			<xsl:when test="$is.extended">
				<doc:confidentiality>This document contains proprietary data provided under license.  This data may not be shared beyond the terms of the license under which it was provided.</doc:confidentiality>
			</xsl:when>
			<xsl:otherwise>
				<doc:confidentiality>This document contains only public information.</doc:confidentiality>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*" mode="generate-definition" priority="-1" />

	<xsl:template match="currencies" mode="generate-definition" >
		 <doc:definition>FpML currencies and currency metadata</doc:definition>
	</xsl:template>

	<xsl:template match="administrators" mode="generate-definition" >
		 <doc:definition>FpML Administrators and administrator metadata</doc:definition>
	</xsl:template>

	<xsl:template match="benchmarks" mode="generate-definition" >
		 <doc:definition>FpML Benchmark rates</doc:definition>
	</xsl:template>

	<xsl:template match="businessCenters" mode="generate-definition" >
		 <doc:definition>The coding-scheme accepts a 4 character code of the real geographical business calendar location or FpML format of the rate publication calendar. While the 4 character codes of the business calendar location are implicitly locatable and used for identifying a bad business day for the purpose of payment and rate calculation day adjustments, the rate publication calendar codes are used in the context of the fixing day offsets.</doc:definition>
		 <doc:description>
		    <doc:paragraph>The 4 character codes are based on the business calendar location some of which based on the ISO country code or exchange code, or some other codes.</doc:paragraph>
		    <doc:paragraph>Additional business day calendar location codes could be built according to the following rules: the first two characters represent the ISO 3166 country code [https://www.iso.org/obp/ui/#search/code/], the next two characters represent either a) the first two letters of the location, if the location name is one word, b) the first letter of the first word followed by the first letter of the second word, if the location name consists of at least two words. Note: for creating new city codes for US and Canada: the two-letter combinations used in postal US states (http://pe.usps.gov/text/pub28/28apb.htm ) and Canadian provinces (http://www.canadapost.ca/tools/pg/manual/PGaddress-e.asp) abbreviations cannot be utilized (e.g. the code for Denver, United States is USDN and not USDE, because of the DE is the abbreviation for Delaware state ). </doc:paragraph>
		    <doc:paragraph>Exchange codes could be added based on the ISO 10383 MIC code [https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.xls] according to the following rules: 1. it would be the acronym of the MIC. If acronym is not available, 2. it would be the MIC code. If the MIC code starts with an 'X', 3. the FpML AWG will compose the code.</doc:paragraph>
		    <doc:paragraph>'Publication Calendar Day', per 2021 ISDA Interest Rate Derivatives Definitions, means, in respect of a benchmark, any day on which the Administrator is due to publish the rate for such benchmark pursuant to its publication calendar, as updated from time to time. FpML format of the rate publication calendar. The construct: CCY-[short codes to identify the publisher], e.g. GBP-ICESWAP. The FpML XAPWG will compose the code.</doc:paragraph>
		 </doc:description>
	</xsl:template>


	<!--Adds Difinition, Publication Date and Disclaimers to the floating-rate-index-3-x -->
	<xsl:template match="floatingRateOptions" mode="generate-description" >
		<Annotation>
			<Description>
				<doc:definition>The FpML floating rate index codes contained in this document are based on the ISDA Floating Rate Options as published by ISDA in the 2021 ISDA Definitions, the 2006 ISDA Definitions, the Annex to the 2000 Definitions, Section 7.1. Rate Options, and other sources, including broker rates.  The codes correspond to their respective ISDA FRO only in the context of a transaction incorporating the corresponding contractual definitions.</doc:definition>
				<doc:publicationDate><xsl:value-of select="@publicationDate"/></doc:publicationDate>
				<xsl:if test="@status = 'working draft'"><doc:status>working-draft</doc:status></xsl:if>
				<xsl:call-template name="confidentiality"/>
				<doc:disclaimer>Aggregate Information Disclaimer: This content aggregates individual data submissions received by ISDA from third party participants. ISDA does not warrant that such aggregated data is comprehensive, and makes no warranty or guarantees to the accuracy of the underlying data provided by third parties.</doc:disclaimer>
				<doc:disclaimer>IMPORTANT: This document maps certain Floating Rate Option labels in the 2006 ISDA Definitions against Floating Rate Option labels in the 2021 ISDA Interest Rate Derivatives Definitions to the extent that they derive from the same underlying benchmark and is provided for information purposes on an 'as is' basis only.  It does not signify that one Floating Rate Option is a successor to another Floating Rate Option or that the definition of such Floating Rate Options are identical.  Among other differences, Floating Rate Options under the 2021 ISDA Interest Rate Derivatives Definitions may have updated fixing dates and fixing times, administrator names and fallback provisions in comparison to mapped Floating Rate Options under the 2006 ISDA Definitions. No representation is made as to its accuracy or completeness and the information it contains should not be relied on for any particular purpose. None of ISDA, FpML, their directors, staff or agents accept any responsibility for any inaccuracy or any loss incurred by any party as a result of any use to which it may be put. Consumers of this document should undertake their own due diligence on the subject matter it contains, in combination with such professional advisors as may be appropriate.</doc:disclaimer>
			</Description>
		</Annotation>
	</xsl:template>

	<xsl:template match="*" mode="generate-identification" >
		<Identification>
			<ShortName>
				<xsl:value-of select="@name"/>
			</ShortName>
			<!-- Values Have Been Added 1-2-2005-->
			<Version>
				<xsl:value-of select="@version"/>
			</Version>
			<CanonicalUri>
				<xsl:value-of select="@canUri"/>
			</CanonicalUri>
			<!-- End New Values Added-->
			<CanonicalVersionUri>
				<xsl:value-of select="@uri"/>
			</CanonicalVersionUri>
			<!-- in order to publish the files and the url resolves-->
			<LocationUri>
				<xsl:value-of select="@url"/>
			</LocationUri>
		</Identification>
	</xsl:template>

	<xsl:template match="floatingRateOptions" mode="code-definition" >The unique string/code identifying the ISDA floating rate option, e.g. USD-LIBOR-BBA</xsl:template>
	<xsl:template match="currencies" mode="code-definition" >The unique ISO 3-character currency code identifying the currency, e.g. USD</xsl:template>
	<xsl:template match="businessCenters" mode="code-definition" >The unique string/code identifying the business center, usually a 4-character code based on a 2-character ISO country code and a 2 character code for the city, but with exceptions for special cases such as index publication calendars, as described above.</xsl:template>
	<xsl:template match="administrators" mode="code-definition" >The unique string/code identifying the administrator</xsl:template>
	<xsl:template match="benchmarks" mode="code-definition" >The unique string/code identifying the benchmark rate.</xsl:template>
	<xsl:template match="*" mode="code-definition" >The unique string/code identifying the value</xsl:template>

	<xsl:template match="*" mode="generate-columnset" >
		<ColumnSet>
			<Column Id="Code" Use="required">
				<ShortName>Code</ShortName>
				<Data Type="token">
					<Annotation>
						<Description>
							<doc:field name="Code Name" ><xsl:apply-templates select="." mode="code-definition"/></doc:field>
						</Description>
					</Annotation>
					<Parameter ShortName="maxLength">63</Parameter>
				</Data>
			</Column>
			<Column Id="Source" Use="optional">
				<ShortName>Source</ShortName>
				<Data Type="string"/>
			</Column>
			<Column Id="Description" Use="optional">
				<ShortName>Description</ShortName>
				<Data Type="string">
					<xsl:if test="local-name(.) = 'floatingRateOptions'">
						<Annotation>
							<Description>
								<doc:field name="FRO annotations" >Does not provide the actual FRO Definitions, but rather point the user to the place where the FRO definitions can be found, e.g. Per 2021 ISDA Interest Rate Derivatives Definitions Floating Rate Matrix, as amended through the date on which parties enter into the relevant transaction.</doc:field>
							</Description>
						</Annotation>
					</xsl:if>
				</Data>
			</Column>
			<xsl:apply-templates mode="generate-metadata-description" select="."/>
			<Key Id="PrimaryKey">
				<ShortName>key</ShortName>
				<ColumnRef Ref="Code"/>
			</Key>
		</ColumnSet>
	</xsl:template>


	<xsl:template match="floatingRateOptions" mode="generate-metadata-description" >
		<xsl:if test="$extended != 'none'">
			<Column Id="Metadata" Use="optional">
				<ShortName>Metadata</ShortName>
				<Data Type="structured">
					<Annotation>
						<xsl:choose>
							<xsl:when test="count($extended.currencies/*) =0">
								<Description>
									<doc:description>Full metadata is supplied for 2021 ISDA FROs in all currencies. Partial metada is provided for non-2021 FROs.</doc:description>
									<doc:disclaimer>This metadata is only relevant if the floating rate index code is used as an ISDA-defined Floating Rate Option as part of a Transaction as defined under the ISDA Definitions.  For any other use of this floating rate index code (for instance as part of a loan transaction), the metadata is not applicable.</doc:disclaimer>
								</Description>
								<AppInfo>
									<xsl:call-template name="document-fro-metadata"/>
								</AppInfo>
							</xsl:when>
							<xsl:otherwise>
								<Description>
									<doc:description>Partial metadata is supplied for all ISDA FROs.  Full metadata is provided for demonstration purposes for 2021 FROs in the currencies listed below.</doc:description>
									<doc:disclaimer>This metadata is only relevant if the floating rate index code is used as an ISDA-defined Floating Rate Option as part of a Transaction as defined under the ISDA Definitions.  For any other use of this floating rate index code (for instance as part of a loan transaction), the metadata is not applicable.</doc:disclaimer>
								</Description>
								<AppInfo>
									<doc:currencies>
										<xsl:copy-of select="$extended.currencies"/>
									</doc:currencies>
									<xsl:call-template name="document-fro-metadata"/>
								</AppInfo>
							</xsl:otherwise>
						</xsl:choose>
					</Annotation>
				</Data>
			</Column>
		</xsl:if>
	</xsl:template>

	<xsl:template name="document-fro-metadata" >

		<doc:field name="Reference in 2006 Defs" section="doc:definition" tagName="doc:reference[@version='2006']" source="ISDA 2006 or Supps">2006 Definitions includes the FRO.</doc:field>
		<doc:field name="Reference in 2021 Defs" section="doc:definition" tagName="doc:reference[@version='2021']" source="2021 FRO Matrix">2021 Definitions includes the FRO.</doc:field>
		<doc:field name="Reference in Broker Rate" section="doc:definition" tagName="doc:reference[@source='BR Source']" source="BR Source">Broker Rate Source includes the BR.</doc:field>

		<doc:field name="Start Date" section="doc:definition" tagName="doc:startDate" source="2006 ISDA Defs and 2021 Floating Rate Matrix">The date the Floating Rate Option was added to the 2006 Definitions or 2021 Floating Rate Matrix. e.g.  2017/4/6</doc:field>
		<doc:field name="First Defined In" section="doc:definition" tagName="doc:firstDefinedIn" source="2006 ISDA Defs and 2021 Floating Rate Matrix">The supplement or version the FRO was first added to the 2006 Definitions or 2021 Floating Rate Matrix. e.g. S52</doc:field>
		<doc:field name="Update Date" section="doc:definition" tagName="doc:updateDate" source="2006 ISDA Defs and 2021 Floating Rate Matrix">The date the Floating Rate Option was last updated in the 2006 Definitions or 2021 Floating Rate Matrix. e.g.  2013/8/29</doc:field>
		<doc:field name="Last Updated Supplement" section="doc:definition" tagName="doc:lastUpdatedIn" source="2006 ISDA Defs and 2021 Floating Rate Matrix">The supplement or version the FRO was last updated in the 2006 Definitions or 2021 Floating Rate Matrix. e.g.  S36 </doc:field>
		<doc:field name="End Date" section="doc:definition" tagName="doc:endDate" source="2006 ISDA Defs and 2021 Floating Rate Matrix">The date the Floating Rate Option was removed from the 2006 Definitions or 2021 Floating Rate Matrix. e.g.  2014/1/1 </doc:field>

		<doc:field name="Administrator" section="doc:definition" tagName="doc:administrator" source="2021 FRO Matrix">The administrator for that rate or benchmark or, if there is no administrator, the provider of that rate or benchmark.</doc:field>
		<doc:field name="Designated Maturity" section="doc:definition" tagName="doc:designatedMaturity" source="2021 FRO Matrix">Whether Designated Maturity is Applicable/ Not Applicable in the Floating Rate Matrix.</doc:field>
		<doc:field name="Broker Rate Description" section="doc:definition" tagName="brokerRateDescription" source="BR Source" available="no">Broker Rate Description from ISDA Broker Rate Source.</doc:field>
		<doc:field name="Broker Rate Publication Page/Screen" section="doc:definition" tagName="brokerRateScreen" source="BR Source">Broker Rate Publication Page/Screen from ISDA Broker Rate Source.</doc:field>
		<doc:field name="In Loan" section="doc:definition" tagName="doc:inLoan" source="FpML">YES / NO to flag FROs identified by the FpML Syndicated Loan WG as having underlying benchmark that may also be referenced in syndicated loans, e.g.NO.</doc:field>
		
		<doc:field name="Maps-to" section="doc:mapping" tagName="doc:to" source="ISDA mapping document">Where FROs under the 2006 ISDA Definitions map to FROs under the 2021 Definitions; 'mapping' means that the FROs share a common underlying benchmark, not that the Floating Rates Options are identical.</doc:field>
		<doc:field name="Maps-from" section="doc:mapping" tagName="doc:from" source="ISDA mapping document">Where FROs under the 2021 Definitions from Floating Rate Options under the 2006 ISDA Definitions map; 'mapping' means that the FROs share a common underlying benchmark, not that the Floating Rates Options are identical.</doc:field>
		<doc:field name="ISOcode" section="doc:external" tagName="doc:code[@target='iso20022']" source="External">4-character ISO BenchmarkCurveNameCode(s) mapped to ISDA FROs for Regulatory purposes. e.g. "BBSW" ISO code is mapped to "AUD-BBSW" FRO</doc:field>

		<doc:field name="Category" section="doc:calculationParameters" tagName="doc:category" source="2021 FRO Matrix">The 'Category' as set out in such column for the FRO in the Floating Rate Matrix.</doc:field>
		<doc:field name="Style" section="doc:calculationParameters" tagName="doc:style" source="2021 FRO Matrix">The 'Style' as set out in such column for the FRO in the Floating Rate Matrix.</doc:field>
		<doc:field name="Method" section="doc:calculationParameters" tagName="doc:method" source="2021 FRO Matrix">The method or formula as set out in the Category/Style column for the FRO in the Floating Rate Matrix.</doc:field>
		<doc:field name="Calculation Method (2006)" section="doc:calculationParameters" tagName="doc:calculationMethod" source="2006 ISDA Defs">Applicable to 2006 FROs only. 'OIS' indicates that an OIS formula is embedded in the FRO.</doc:field>

		<doc:field name="Daycount" section="doc:calculationParameters" tagName="doc:daycount" source="2021 FRO Matrix">The default Floating Rate Day Count Fraction as set out in such column for the FRO in the Floating Rate Matrix.</doc:field>
		
		<doc:field name="Fixing Time Definition" section="doc:calculationParameters" tagName="doc:fixingTimeDefinition" source="2021 FRO Matrix">Fixing Time as defined in the Fixing Time column for the FRO in the Floating Rate Matrix.</doc:field>
		<doc:field name="Fixing Time" section="doc:calculationParameters/doc:fixing" tagName="doc:time" source="2021 FRO Matrix">The Fixing Time in the Fixing Time Business Center as defined in the Fixing Time Definition.</doc:field>
		<doc:field name="Fixing Time Business Center" section="doc:calculationParameters/doc:fixing" tagName="doc:businessCenter" source="2021 FRO Matrix">The business center specified for the Fixing Time as defined in the Fixing Time Definition.</doc:field>
		
		<doc:field name="(Alternative) Fixing Time" section="doc:calculationParameters/doc:fixing[doc:reason or doc:indexTenor]" tagName="doc:time" source="2021 FRO Matrix">Any alternative Fixing Time that might apply under any specified scenario as defined in the Fixing Time Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Time Business Center" section="doc:calculationParameters/doc:fixing[doc:reason or doc:indexTenor]" tagName="doc:businessCenter" source="2021 FRO Matrix">The business center used for any alternative Fixing Time as defined in the Fixing Time Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Time Business Designated Maturity" section="doc:calculationParameters/doc:fixing" tagName="doc:indexTenor" source="2021 FRO Matrix">The Designated Maturity (index tenor) for which the Alternative Fixing Time applies as defined in the Fixing Time Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Time Business Reason" section="doc:calculationParameters/doc:fixing" tagName="doc:reason" source="2021 FRO Matrix">The description of the specified scenario that would result in the alternative Fixing Time being used as defined in the Fixing Time Definition.</doc:field>

		<doc:field name="Fixing Offset Definition" section="doc:calculationParameters" tagName="doc:fixingOffsetDefinition" source="2021 FRO Matrix">Fixing Day offset as defined in the Fixing Day column for the FRO in the Floating Rate Matrix.</doc:field>
		<doc:field name="Fixing Offset Period Multiplier" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:periodMultiplier" source="2021 FRO Matrix">Default fixing offset period multiplier as defined in the Fixing Offset Definition.</doc:field>
		<doc:field name="Fixing Offset Period" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:period" source="2021 FRO Matrix">Default fixing offset period (typically days) as defined in the Fixing Offset Definition.</doc:field>
		<!--<doc:field name="Fixing Offset Business Center" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:businessCenter" source="2021 FRO Matrix">Business Centers for fixing offset as defined Fixing Offset Definition.</doc:field>-->
		
		<doc:field name="(Alternative) Fixing Offset Period Multiplier" section="doc:calculationParameters/doc:fixingOffset[doc:indexTenor]" tagName="doc:periodMultiplier" source="2021 FRO Matrix">Alternative fixing offset period multiplier where any specified condition applies as defined Fixing Offset Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Offset Period" section="doc:calculationParameters/doc:fixingOffset[doc:indexTenor]" tagName="doc:period" source="2021 FRO Matrix">Alternative fixing offset period where any specified condition applies (typically days) as defined Fixing Offset Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Offset Business Center" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:businessCenter" source="2021 FRO Matrix">Business Center for alternative fixing offset period as defined Fixing Offset Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Offset Designated Maturity" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:indexTenor" source="2021 FRO Matrix">The Designated Maturity (index tenor) for which the Fixing Day offset applies as defined in the Fixing Offset Definition.</doc:field>
		<doc:field name="(Alternative) Fixing Offset Reason" section="doc:calculationParameters/doc:fixingOffset" tagName="doc:reason" source="2021 FRO Matrix">The specific condition that would result in an alternative fixing offset period applying as defined in the Fixing Offset Definition.</doc:field>
		
		<doc:field name="Applicable Business Day" section="doc:calculationParameters" tagName="doc:applicableBusinessDay" source="2021 FRO Matrix">Applicability of Designated Maturity as set out in such column for FRO in the Floating Rate Matrix, in case the applicable business days omitted from confirmation.</doc:field>
	</xsl:template>

	<xsl:template match="*" mode="generate-metadata-description" priority="-1">
		<xsl:if test="$is.extended">
			<Column Id="Metadata" Use="optional">
				<ShortName>Metadata</ShortName>
				<Data Type="structured">
					<Annotation>
						<Description>
							<doc:description>All available metadata is supplied.</doc:description>
						</Description>
					</Annotation>
				</Data>
			</Column>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="generate-rows" priority = "-1"/>

	<xsl:template match="*" mode="generate-rows" >
		<xsl:variable name="rows">
			<xsl:apply-templates select="*" mode="generate-row"/>
		</xsl:variable>
		<SimpleCodeList>
			<xsl:for-each select="$rows/Row">
				<xsl:sort select = "@sortval" data-type="text" order="ascending" />
				<xsl:copy>
					<xsl:copy-of select="*"/>
				</xsl:copy>
			</xsl:for-each>
		</SimpleCodeList>
	</xsl:template>

	<xsl:template match="floatingRateOptions" mode="generate-rows" >
		<xsl:variable name="rows">
			<xsl:choose>
				<xsl:when test="string-length($filter.currency) &gt; 0">
					<xsl:apply-templates select="index[currency=$filter.currency]" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="index" /> 
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<SimpleCodeList>
			<xsl:for-each select="$rows/Row">
				<xsl:sort select = "@sortval" data-type="text" order="ascending" />
				<xsl:copy>
					<xsl:copy-of select="*"/>
				</xsl:copy>
			</xsl:for-each>
		</SimpleCodeList>
	</xsl:template>

	<xsl:template match="field" mode="column-annotation" />

	<xsl:template match="field[@description]" mode="column-annotation" >
		<Annotation>
			<Description>
				<doc:description>
					<doc:paragraph><xsl:value-of select="@description"/></doc:paragraph>
				</doc:description>
			</Description>
		</Annotation>
	</xsl:template>


	<xsl:template match="index" priority ="-1" />

	<xsl:template match="codeDescription" mode="code-description" priority ="-1" >
		<Annotation>
			<Description>
				<doc:description>
					<doc:paragraph><xsl:value-of select="."/></doc:paragraph>
				</doc:description>
			</Description>
		</Annotation>
	</xsl:template>


	<xsl:template match="index[supportedDefinition or inOtherDoc]" >
		<Row sortval="{translate(name, $uppercase, $smallcase)}" >
			<xsl:apply-templates mode="code-description" select="codeDescription"/>
			<Value>
				<SimpleValue>
					<xsl:value-of select="name"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue><xsl:apply-templates mode="source" select="."/></SimpleValue>
			</Value>
			<Value>
				<xsl:apply-templates mode="description" select="."/>
			</Value>
			<xsl:if test="$extended != 'none'">
				<xsl:apply-templates mode="format-metadata" select="."/>
			</xsl:if>
		</Row>
	</xsl:template>

	<xsl:template mode="source" match="index[source]" priority="1000"><xsl:value-of select="source"/></xsl:template>
	<xsl:template mode="source" match="index[name='CLP-TNA']">EMTA-ISDA</xsl:template>
	<xsl:template mode="source" match="index">ISDA</xsl:template>

	<xsl:template mode="description" match="index[description]" priority="1000">
		<SimpleValue><xsl:value-of select="description"/></SimpleValue>
	</xsl:template>

	<xsl:template mode="description" match="index[name='CLP-TNA']" priority="100">
		<SimpleValue>Refers to the Indice Camara Promedio ("ICP") rate for Chilean Pesos which, for a Reset Date, is determined and published by the Asociacion de Bancos e Instituciones Financieras de Chile A.G. ("ABIF") in accordance with the "Reglamento Indice de Camara Promedio" of the ABIF as published in the Diario Oficial de la Republica de Chile (the "ICP Rules") and which is reported on the ABIF website by not later than 10:00 a.m., Santiago time, on that Reset Date.</SimpleValue>
	</xsl:template>
	<xsl:template mode="description" match="index[supportedDefinition='2021' and supportedDefinition='2006']" priority="10">
		<SimpleValue>Per 2021 ISDA Interest Rate Derivatives Definitions Floating Rate Matrix and 2006 ISDA Definitions, Section 7.1 Rate Options, as amended and supplemented through the date on which parties enter into the relevant transaction.</SimpleValue>
	</xsl:template>
	<xsl:template mode="description" match="index[supportedDefinition='2006' or supportedDefinition='2000']">
		<SimpleValue>Per 2006 ISDA Definitions or Annex to the 2000 ISDA Definitions, Section 7.1 Rate Options, as amended and supplemented through the date on which parties enter into the relevant transaction.</SimpleValue>
	</xsl:template>
	<xsl:template mode="description" match="index[supportedDefinition='2021']">
		<SimpleValue>Per 2021 ISDA Interest Rate Derivatives Definitions Floating Rate Matrix, as amended through the date on which parties enter into the relevant transaction.</SimpleValue>
	</xsl:template>
	<xsl:template mode="description" match="index">
		<SimpleValue>Per 2021 ISDA Interest Rate Derivatives Definitions Floating Rate Matrix, 2006 ISDA Definitions, or Annex to the 2000 ISDA Definitions, Section 7.1 Rate Options, as amended and supplemented through the date on which parties enter into the relevant transaction.</SimpleValue>
	</xsl:template>

	<xsl:template match="index" mode="format-metadata" priority="10">
		<xsl:variable name="metadata">
			<xsl:apply-templates mode="format-reference" select="."/>
			<xsl:apply-templates mode="format-mapping" select="."/>
			<xsl:apply-templates mode="format-external" select="."/>
			<xsl:apply-templates mode="format-calc-params" select="."/>
		</xsl:variable>
		<Value>
			<ComplexValue>
				<xsl:copy-of select="$metadata/*[*]"/>
			</ComplexValue>
		</Value>
	</xsl:template>

	<xsl:template match="index" mode="format-reference" priority="10">
		<doc:definition>
			<xsl:for-each select="supportedDefinition[.='2006' or .='2021']">
				<doc:reference>
					<xsl:attribute name="title"><xsl:value-of select="text()"/> ISDA Definitions</xsl:attribute>
					<xsl:attribute name="source">ISDA Definitions</xsl:attribute>
					<xsl:attribute name="version"><xsl:value-of select="text()"/></xsl:attribute>
				</doc:reference>
			</xsl:for-each>
			<xsl:if test="inBrMatrix='true'">
				<doc:reference source="Broker Matrix" version="2021"/>
			</xsl:if>
			<xsl:if test="$extended != 'none'">
				<xsl:apply-templates mode="extended-definitions" select="."/>
			</xsl:if>
			<xsl:apply-templates mode="copy-metadata-field" select="inLoan"/>
		</doc:definition>
	</xsl:template>

	<xsl:template match="index" mode="format-mapping" priority="10">
		<xsl:variable name="index" select="."/>

		<doc:mapping>
			<xsl:for-each select="$index[supportedDefinition='2021']/replaces">
				<doc:from version="2006" >
					<xsl:value-of select="text()"/>
				</doc:from>
			</xsl:for-each>
			<xsl:for-each select="$index[supportedDefinition='2006']/replacedBy">
				<doc:to version="2021" >
					<xsl:value-of select="text()"/>
				</doc:to>
			</xsl:for-each>
		</doc:mapping>
	</xsl:template>


	<xsl:template match="index" mode="format-external" priority="10">
		<xsl:variable name="index" select="."/>
		<xsl:variable name="ccy" select="currency"/>

		<doc:external>
			<xsl:if test="isoCode">
				<doc:code target="iso20022" method="BenchmarkCurveNameCode"><xsl:value-of select="isoCode"/></doc:code>
			</xsl:if>
		</doc:external>
		<!--
		<xsl:if test="count($extended.currencies/*) = 0 or $extended.currencies/*[.=$ccy]">
			<doc:external>
				<xsl:apply-templates mode="gen-iso" select="."/>
			</doc:external>
		</xsl:if>
		-->
	</xsl:template>

	<xsl:template match="index" mode="format-calc-params" priority="10">
		<xsl:variable name="index" select="."/>

		<doc:calculationParameters>
			<xsl:apply-templates mode="extended-calc-params" select="."/>
		</doc:calculationParameters>
	</xsl:template>

	<xsl:template match="index" mode="extended-definitions" priority="-1">
		<xsl:variable name="ccy" select="currency"/>
		<xsl:if test="count($extended.currencies/*) = 0 or $extended.currencies/*[.=$ccy]">
			<xsl:apply-templates mode="output-extended-definitions" select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="index" mode="output-extended-definitions" priority="10">
		<xsl:apply-templates mode="copy-metadata-field" select="startDate"/>
		<xsl:apply-templates mode="copy-metadata-field" select="firstDefinedIn"/>
		<xsl:apply-templates mode="copy-metadata-field" select="updateDate"/>
		<xsl:apply-templates mode="copy-metadata-field" select="lastUpdatedIn"/>
		<xsl:apply-templates mode="copy-metadata-field" select="endDate"/>
		<xsl:apply-templates mode="copy-metadata-field" select="administrator"/>
		<!--
		<xsl:apply-templates mode="copy-metadata-field" select="administratorWebsite"/>
		<xsl:apply-templates mode="copy-metadata-field" select="inLoan"/>
		-->
		<xsl:apply-templates mode="copy-metadata-field" select="designatedMaturity"/>
	</xsl:template>


	<xsl:template match="index" mode="extended-calc-params" priority="-1">
		<xsl:variable name="ccy" select="currency"/>
		<xsl:choose>
			<xsl:when test="count($extended.currencies/*) = 0 or $extended.currencies/*[.=$ccy]">
				<xsl:apply-templates mode="output-extended-calc-params" select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="copy-metadata-field" select="method"/>
				<xsl:if test="froType='OIS'">
					<doc:calculationMethod version="2006">OIS</doc:calculationMethod>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="index" mode="output-extended-calc-params" priority="10">
		<xsl:apply-templates mode="copy-metadata-field" select="category"/>
		<xsl:apply-templates mode="copy-metadata-field" select="style"/>
		<xsl:apply-templates mode="copy-metadata-field" select="method"/>
		<xsl:if test="froType='OIS'">
			<doc:calculationMethod version="2006">OIS</doc:calculationMethod>
		</xsl:if>
		<xsl:apply-templates mode="copy-metadata-field" select="daycount"/>
		<!--<xsl:apply-templates mode="copy-metadata-field" select="publicationCalendar"/>-->
		<xsl:apply-templates mode="copy-metadata-field" select="fixingTimeDefinition"/>
		<xsl:if test="fixingTime | fixingTimeBusinessCenter | fixingTimeDefinition"> <doc:fixing>
				<xsl:apply-templates mode="copy-metadata-field" select="fixingTime">
					<xsl:with-param name="name" select="'time'"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="fixing-business-center" select="."/>
			</doc:fixing>
			<xsl:apply-templates mode="alternative-fixing" select="."/>
		</xsl:if>
		<xsl:apply-templates mode="copy-metadata-field" select="fixingOffsetDefinition"/>
		<xsl:if test="fixingOffsetPeriod | fixingOffsetPeriodMultiplier | fixingOffsetBusinessCenter | fixingOffsetDefinition">
			<doc:fixingOffset>
				<xsl:apply-templates mode="copy-metadata-field" select="fixingOffsetPeriodMultiplier">
					<xsl:with-param name="name" select="'periodMultiplier'"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="copy-metadata-field" select="fixingOffsetPeriod">
					<xsl:with-param name="name" select="'period'"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="fixing-offset-business-center" select="*"/>
			</doc:fixingOffset>
			<xsl:apply-templates mode="alternative-fixing-offset" select="."/>
		</xsl:if>
		<xsl:apply-templates mode="copy-metadata-field" select="applicableBusinessDay"/>
	</xsl:template>


	<xsl:template match="*" mode="fixing-business-center" >
		<xsl:apply-templates mode="copy-metadata-field" select="fixingTimeBusinessCenter">
			<xsl:with-param name="name" select="'businessCenter'"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="alternative-fixing" priority="-1"/>

	<xsl:template match="*[contains(alternativeFixingReason, 'overnight') and contains(alternativeFixingReason, 'tomorrow/next')]" mode="alternative-fixing"  priority="10">
		<doc:fixing>
			<xsl:call-template name="overnight" />
			<xsl:apply-templates mode="alternative-fixing-time" select="."/>
			<xsl:apply-templates mode="fixing-business-center" select="."/>
		</doc:fixing>
		<doc:fixing>
			<xsl:call-template name="tomnext" />
			<xsl:apply-templates mode="alternative-fixing-time" select="."/>
			<xsl:apply-templates mode="fixing-business-center" select="."/>
		</doc:fixing>
	</xsl:template>

	<xsl:template match="*" mode="alternative-fixing-time" priority="-1">
		<doc:time>
			<xsl:value-of select="alternativeFixingTime"/>
		</doc:time>
	</xsl:template>

	<xsl:template match="*[contains(alternativeFixingReason, 'overnight')]" mode="alternative-fixing"  priority="8">
		<doc:fixing>
			<xsl:call-template name="overnight" />
			<xsl:apply-templates mode="alternative-fixing-time" select="."/>
			<xsl:apply-templates mode="fixing-business-center" select="."/>
		</doc:fixing>
	</xsl:template>

	<xsl:template name="overnight" >
		<doc:indexTenor>
			<doc:periodMultiplier>1</doc:periodMultiplier>
			<doc:period>D</doc:period>
		</doc:indexTenor>
	</xsl:template>

	<xsl:template name="tomnext" >
			<doc:indexTenor>
				<doc:periodMultiplier>2</doc:periodMultiplier>
				<doc:period>D</doc:period>
			</doc:indexTenor>
	</xsl:template>

	<xsl:template match="*[alternativeFixingTime]" mode="alternative-fixing"  priority="5">
		<doc:fixing>
			<xsl:apply-templates mode="alternative-fixing-reason" select="alternativeFixingReason"/>
			<xsl:apply-templates mode="alternative-fixing-time" select="."/>
			<xsl:apply-templates mode="fixing-business-center" select="."/>
		</doc:fixing>
	</xsl:template>


	<xsl:template match="*" mode="alternative-fixing-reason" priority="-1"/>

	<xsl:template match="*[contains(., 'day following')]" mode="alternative-fixing-reason" priority="5">
		<doc:reason>EarlyClose</doc:reason>
	</xsl:template>

	<xsl:template match="*[contains(., 'half day')]" mode="alternative-fixing-reason" priority="5">
		<doc:reason>EarlyClose</doc:reason>
	</xsl:template>


	<!-- fixing offset -->

	<xsl:template match="*" mode="alternative-fixing-offset" priority="-1"/>

	<xsl:template match="*[contains(alternativeFixingOffsetReason, 'overnight')]" mode="alternative-fixing-offset"  priority="8">
		<doc:fixingOffset >
			<xsl:call-template name="overnight" />
			<xsl:apply-templates mode="copy-metadata-field" select="alternativeFixingOffsetPeriodMultiplier">
				<xsl:with-param name="name" select="'periodMultiplier'"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="copy-metadata-field" select="alternativeFixingOffsetPeriod">
				<xsl:with-param name="name" select="'period'"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="fixing-offset-business-center" select="*"/>
			<xsl:choose>
				<xsl:when test="alternativeFixingOffsetBusinessCenter">
					<xsl:apply-templates mode="copy-metadata-field" select="alternativeFixingOffsetBusinessCenter">
						<xsl:with-param name="name" select="'businessCenter'"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="fixing-offset-business-center" select="*"/>
				</xsl:otherwise>
			</xsl:choose>
		</doc:fixingOffset>
	</xsl:template>


	<xsl:template match="*" mode="fixing-offset-business-center" >
		<xsl:apply-templates mode="copy-metadata-field" select="fixingOffsetBusinessCenter">
			<xsl:with-param name="name" select="'businessCenter'"/>
		</xsl:apply-templates>
	</xsl:template>



	<xsl:template match="*" mode="copy-metadata-field" priority="10">
		<xsl:param name="name" select="local-name(.)"/>
		<xsl:element name="doc:{$name}">
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="fixingTime[contains(.,'Close of business')]" mode="copy-metadata-field" priority="20">
		<doc:timeType souce="ISDA">CloseOfBusiness</doc:timeType>
	</xsl:template>

	<xsl:template match="fixingTime[contains(.,'Underlying Benchmark')]" mode="copy-metadata-field" priority="20">
		<doc:timeType souce="ISDA">UnderlyingBenchmarkPublication</doc:timeType>
	</xsl:template>


	<xsl:template match="*" mode="generate-row" priority="-1">
		<xsl:variable name="sortcode">
			<xsl:apply-templates select="." mode="row-code"/>
		</xsl:variable>
		<Row sortval="{translate($sortcode, $uppercase, $smallcase)}" >
			<xsl:apply-templates mode="code-description" select="codeDescription"/>
			<xsl:apply-templates select="." mode="generate-row-code"/>
			<xsl:apply-templates select="." mode="generate-row-source"/>
			<xsl:apply-templates select="." mode="generate-row-description"/>
			<xsl:apply-templates select="." mode="generate-row-metadata"/>
		</Row>
	</xsl:template>


	<xsl:template match="*" mode="generate-row-code" priority="-1">TBD</xsl:template>

	<xsl:template match="*" mode="generate-row-code" priority="10">
		<Value>
			<SimpleValue><xsl:apply-templates select="." mode="row-code"/></SimpleValue>
		</Value>
	</xsl:template>

	<xsl:template match="*" mode="row-code" priority="-1">TBD</xsl:template>

	<xsl:template match="index" mode="row-code" priority="10"><xsl:value-of select="name"/></xsl:template>
	<xsl:template match="currency" mode="row-code" priority="10"><xsl:value-of select="currencyCode"/></xsl:template>
	<xsl:template match="businessCenter" mode="row-code" priority="10"><xsl:value-of select="code"/></xsl:template>
	<xsl:template match="administrator" mode="row-code" priority="10"><xsl:value-of select="administrator"/></xsl:template>
	<!--<xsl:template match="publicationCalendar" mode="row-code" priority="10"><xsl:value-of select="code"/></xsl:template>-->
	<xsl:template match="benchmark" mode="row-code" priority="10"><xsl:value-of select="name"/></xsl:template>

	<xsl:template match="*" mode="generate-simple-value" >
		<Value>
			<SimpleValue><xsl:value-of select="."/></SimpleValue>
		</Value>
	</xsl:template>

	<xsl:template match="*" mode="generate-row-source" >
		<Value>
			<SimpleValue>ISDA</SimpleValue>
		</Value>
	</xsl:template>

	<xsl:template match="*" mode="generate-row-description" >
		<Value>
			<SimpleValue><xsl:apply-templates select="." mode="generate-row-description-value"/></SimpleValue>
		</Value>
	</xsl:template>

	<xsl:template match="index" mode="generate-row-description" >
		<Value>
			<xsl:apply-templates select="." mode="description"/>
		</Value>
	</xsl:template>

	<xsl:template match="*" mode="generate-row-description-value" priority="-1" >Per 2021 ISDA Definitions.</xsl:template>

	<xsl:template match="*[definition]" mode="generate-row-description-value" priority="5" >
		<xsl:value-of select="definition"/>
	</xsl:template>

	<xsl:template match="administrator" mode="generate-row-description-value" priority="3" >2021 ISDA Interest Rate Derivatives Definitions Floating Rate Matrix, column Administrator.</xsl:template>

	<xsl:template match="benchmark" mode="generate-row-description-value" priority="10" >
		<xsl:value-of select="definition1"/>
	</xsl:template>

	<xsl:template match="*[description]" mode="generate-row-description-value" priority="2">
		<xsl:value-of select="description"/>
	</xsl:template>

	<xsl:template match="currency" mode="generate-row-description-value" priority="2">
		<xsl:value-of select="name"/>
	</xsl:template>


	<xsl:template match="*" mode="generate-row-metadata" priority="-1" >
		<xsl:if test="$is.extended">
			<xsl:apply-templates mode="output-row-metadata" select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="output-row-metadata" priority="-1" />

	<xsl:template match="currency" mode="output-row-metadata" >
		<Value>
			<ComplexValue>
				<xsl:apply-templates mode="copy-metadata-field" select="name"/>
				<xsl:apply-templates mode="copy-metadata-field" select="synonym"/>
				<xsl:apply-templates mode="copy-metadata-field" select="definition"/>
				<xsl:apply-templates mode="copy-metadata-field" select="businessCenter"/>
				<xsl:apply-templates mode="copy-metadata-field" select="additionalProvisions"/>
			</ComplexValue>
		</Value>
	</xsl:template>

	<xsl:template match="administrator" mode="output-row-metadata" >
		<Value>
			<ComplexValue>
				<xsl:apply-templates mode="copy-metadata-field" select="administratorWebsite"/>
			</ComplexValue>
		</Value>
	</xsl:template>

<!--	<xsl:template match="publicationCalendar" mode="output-row-metadata" >
		<Value>
			<ComplexValue>
				<xsl:apply-templates mode="copy-metadata-field" select="notes"/>
			</ComplexValue>
		</Value>
	</xsl:template>-->

	<xsl:template match="benchmark" mode="output-row-metadata" >
		<Value>
			<ComplexValue>
				<xsl:apply-templates mode="copy-metadata-field" select="definition"/>
				<xsl:apply-templates mode="copy-metadata-field" select="administratorWebsite"/>
			</ComplexValue>
		</Value>
	</xsl:template>

	<xsl:template match="businessCenter" mode="output-row-metadata" >
		<Value>
			<ComplexValue>
				<xsl:apply-templates mode="copy-metadata-field" select="notes"/>
				<xsl:apply-templates mode="copy-metadata-field" select="cityName"/>
				<xsl:apply-templates mode="copy-metadata-field" select="countryName"/>
			</ComplexValue>
		</Value>
	</xsl:template>



</xsl:stylesheet>
