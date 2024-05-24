<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="common saxon">
	<xsl:param name="pwd"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz1234567890_-'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-'" />

	<xsl:variable name="fieldsTF">
		<field datatype="structured" name="metadata">metadata</field>
	</xsl:variable>
	<xsl:variable name="fieldsTF2">
		<field 
			description="This field will contain the value 'OIS' for 2006 FROs designated by FpML as OIS rates, and will be empty for other types of rates.">froType</field>
		<field name="method" datatype="custom" 
			description="This field will contain the value 'OIS Compound' for 2021 OIS rates, and will be empty for other types of rates.">method</field>
		<field name="supportedDefinitions" datatype="custom" 
			description="For 2021 FROs, indicates whether which Definition version is supported in, either 2021 only, or 2006 and 2021. ">supportedDefinition</field>
		<field name="inBrMatrix" datatype="boolean" trueval="BR" falseval=""
			description="If the FRO is defined in the 2021 Broker Matrix, this field will contain the value 'BR'">inBrMatrix</field>
		<field datatype="custom" name="mapping" description="This field sets out, if applicable, the name of an FRO under the 2006 Definitions which derives from the same underlying benchmark as the listed FRO under the 2021 Definitions, or vice versa.  Please note that more than one FRO under the 2006 Definitions may derive from such underlying benchmark and map to the same FRO under the 2021 Definitions.">mapping</field>
		<field>isoCode</field>
		<field datatype="structured" name="metadata">metadata</field>
<!--
		<field name="in2006Definitions" datatype="boolean" trueval="2006" falseval=""
			description="For 2021 FROs, indicates whether the FRO was also present in 2006.  If so will contain the value '2006'.">boolean(supportedDefinition = '2006' and supportedDefinition='2021')</field>
		<field name="in2021Definitions" datatype="boolean" trueval="2021" falseval=""
			description="If the FRO is defined in the 2021 FROs, this field will contain the value '2021'">boolean(supportedDefinition[. = '2021'])</field>
		<field description="This field sets out, if applicable, the name of the FRO under the 2021 Definitions which derives from the same underlying benchmark as the listed FRO under the 2006 Definitions.">mapsTo</field>
		<field>currency</field>
		<field>category</field>
		<field>style</field>
		<field>method</field>
		<field>daycount</field>
		<field>administrator</field>
		<field>administratorWebsite</field>
		<field>fixingTime</field>
		<field>fixingTimeBusinessCenter</field>
		<field>fixingTimeOffsetPeriod</field>
		<field>fixingTimeOffsetPeriodMultiplier</field>
		<field>fixingOffsetBusinessCenter</field>
		<field datatype="boolean">inLoan</field>
-->
	</xsl:variable>

	<xsl:variable name="fields" select="common:node-set($fieldsTF)"/>

	<!-- uri validation -->
	<xsl:template match="scheme[@name = 'entityIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'entityNameScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'exchangeIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'instrumentIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->

	<xsl:template match="floatingRateOptions">
		<xsl:message>uri is <xsl:value-of select="@uri"/></xsl:message>
		<xsl:message>file name is <xsl:value-of select="@fileName"/></xsl:message>
		<xsl:choose>
			<xsl:when test="index">
				<xsl:document href="{$pwd}\{@fileName}">
					<gcl:CodeList xmlns:gcl="http://xml.genericode.org/2004/ns/CodeList/0.2/" xmlns:doc="http://www.fpml.org/coding-scheme/documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xml.genericode.org/2004/ns/CodeList/0.2/ CodeList.xsd">
						<Annotation>
							<Description>
								 <doc:definition>ISDA Floating Rate Options as published by ISDA in the 2021 ISDA Definitions, the 2006 ISDA Definitions or the Annex to the 2000 Definitions, Section 7.1. Rate Options.</doc:definition>
								 <doc:publicationDate><xsl:value-of select="@publicationDate"/></doc:publicationDate>
								 <xsl:if test="@status = 'working draft'"><doc:status>working-draft</doc:status></xsl:if>
								 <doc:disclaimer>IMPORTANT: This document maps certain Floating Rate Option labels in the 2006 ISDA Definitions against Floating Rate Option labels in the 2021 ISDA Interest Rate Derivatives Definitions to the extent that they derive from the same underlying benchmark and is provided for information purposes only.  It does not signify that one Floating Rate Option is a successor to another Floating Rate Option or that the definition of such Floating Rate Options are identical.  Among other differences, Floating Rate Options under the 2021 ISDA Interest Rate Derivatives Definitions may have updated fixing dates and fixing times, administrator names and fallback provisions in comparison to mapped Floating Rate Options under the 2006 ISDA Definitions. No representation is made as to its accuracy or completeness and the information it contains should not be relied on for any particular purpose. None of ISDA, FpML, their directors, staff or agents accept any responsibility for any inaccuracy or any loss incurred by any party as a result of any use to which it may be put. Consumers of this document should undertake their own due diligence on the subject matter it contains, in combination with such professional advisors as may be appropriate.</doc:disclaimer>
							</Description>
						</Annotation>
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
						<ColumnSet>
							<Column Id="Code" Use="required">
								<ShortName>Code</ShortName>
								<Data Type="token">
									<Parameter ShortName="maxLength">63</Parameter>
								</Data>
							</Column>
							<Column Id="Source" Use="optional">
								<ShortName>Source</ShortName>
								<Data Type="string"/>
							</Column>
							<Column Id="Description" Use="optional">
								<ShortName>Description</ShortName>
								<Data Type="string"/>
							</Column>
							<xsl:for-each select="$fields/field">
								<xsl:variable name="fieldname">
									<xsl:choose>
										<xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="datatype">
									<xsl:choose>
										<xsl:when test="@datatype='boolean' and not(@trueval)"><xsl:value-of select="@datatype"/></xsl:when>
										<xsl:when test="@datatype='structured'">structured</xsl:when>
										<xsl:otherwise>token</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>


								<Column Id="{$fieldname}" Use="optional">
									<xsl:apply-templates mode="column-annotation" select="."/>
									<ShortName><xsl:value-of select="$fieldname"/></ShortName>
									<Data Type="{$datatype}"/>
								</Column>
							</xsl:for-each>
							<!--
							<Column Id="Style" Use="optional">
								<ShortName>Style</ShortName>
								<Data Type="string"/>
							</Column>
							-->
							<Key Id="PrimaryKey">
								<ShortName>key</ShortName>
								<ColumnRef Ref="Code"/>
							</Key>
						</ColumnSet>
							<xsl:variable name="rows">
								<!-- <xsl:apply-templates select="index" /> -->
								<xsl:apply-templates select="index[currency='CAD']" />
							</xsl:variable>
							<SimpleCodeList>
								<xsl:for-each select="$rows/Row">
									<xsl:sort select = "@sortval" data-type="text" order="ascending" />
									<xsl:copy>
										<xsl:copy-of select="*"/>
									</xsl:copy>
								</xsl:for-each>
							</SimpleCodeList>
					</gcl:CodeList>
				</xsl:document>
			</xsl:when>
		</xsl:choose>
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

	<xsl:template match="index[supportedDefinition]" >
		<Row sortval="{translate(name, $uppercase, $smallcase)}" >
			<xsl:if test="codeDescription">
				<Annotation>
					<Description>
						<xsl:apply-templates select="codeDescription"/>
					</Description>
				</Annotation>
			</xsl:if>
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
			<xsl:variable name="index" select="."/>
			<xsl:variable name="others">
				<xsl:for-each select="$fields/field">
					<xsl:variable name="f" select="."/>
					<xsl:variable name="xpath" select="text()"/>
					<xsl:variable name="value" >
						<xsl:for-each select="$index">
							<xsl:value-of select="saxon:evaluate($xpath)"/>
						</xsl:for-each>
					</xsl:variable>
					<xsl:apply-templates mode="format-field" select="$f">
						<xsl:with-param name="value" select="$value"/>
						<xsl:with-param name="index" select="$index"/>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:variable>
			<xsl:copy-of select="$others"/>
			<!--
			<xsl:for-each select="$others/*">
				<xsl:if test="SimpleValue or following-sibling::Value[SimpleValue]">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
			-->
		</Row>
	</xsl:template>
	<xsl:template match="field[@datatype='custom' and .='method']" mode="format-field" priority="10">
		<xsl:param name="value"/>
		<xsl:if test="$value='OIS' or $value='OIS Compounding'">
			<Value>
				<SimpleValue>
					<xsl:value-of select="$value"/>
				</SimpleValue>
			</Value>
		</xsl:if>
	</xsl:template>

	<xsl:template match="field[@datatype='custom' and @name='mapping']" mode="format-field" priority="15">
		<xsl:param name="value"/>
		<xsl:param name="index"/>
		<Value>
			<ComplexValue>
				<xsl:for-each select="$index[supportedDefinition='2021']/replaces">
					<doc:mapsFrom2006Fro>
						<xsl:value-of select="text()"/>
					</doc:mapsFrom2006Fro>
				</xsl:for-each>
				<xsl:for-each select="$index[supportedDefinition='2006']/replacedBy">
					<doc:mapsTo2021Fro>
						<xsl:value-of select="text()"/>
					</doc:mapsTo2021Fro>
				</xsl:for-each>
			</ComplexValue>
		</Value>
	</xsl:template>
	<xsl:template match="field[@datatype='custom' and .='supportedDefinition']" mode="format-field" priority="10">
		<xsl:param name="value"/>
		<xsl:param name="index"/>
		<Value>
			<ComplexValue>
				<xsl:choose>
					<xsl:when test="$index[supportedDefinition='2021']">
						<xsl:for-each select="$index/supportedDefinition">
							<doc:supportedDefinition>
								<xsl:value-of select="text()"/>
							</doc:supportedDefinition>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise><doc:supportedDefinition>Pre-2021</doc:supportedDefinition></xsl:otherwise>
				</xsl:choose>
			</ComplexValue>
		</Value>
	</xsl:template>

	<xsl:template match="field[@datatype='structured' and @name='metadata']" mode="format-field" priority="10">
		<xsl:param name="value"/>
		<xsl:param name="index"/>
		<Value>
			<ComplexValue>
				<xsl:choose>
					<xsl:when test="$index[supportedDefinition='2021']">
						<xsl:for-each select="$index/supportedDefinition">
							<doc:definedIn>
								<xsl:value-of select="text()"/><xsl:text> Definitions</xsl:text>
							</doc:definedIn>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise><doc:definedIn>2006 or 2000 Definitions</doc:definedIn></xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$index[inBrMatrix='true']">
					<doc:definedIn>Broker Matrix</doc:definedIn>
				</xsl:if>
				<xsl:for-each select="$index[supportedDefinition='2021']/replaces">
					<doc:mapsFrom2006Fro>
						<xsl:value-of select="text()"/>
					</doc:mapsFrom2006Fro>
				</xsl:for-each>
				<xsl:for-each select="$index[supportedDefinition='2006']/replacedBy">
					<doc:mapsTo2021Fro>
						<xsl:value-of select="text()"/>
					</doc:mapsTo2021Fro>
				</xsl:for-each>
				<xsl:if test="$index[method='OIS Compounding']">
					<doc:method>OIS Compounding</doc:method>
				</xsl:if>
				<xsl:if test="$index[froType='OIS']">
					<doc:froType>OIS</doc:froType>
				</xsl:if>
				<xsl:if test="$index[isoCode]">
					<doc:isoCode><xsl:value-of select="$index/isoCode"/></doc:isoCode>
				</xsl:if>
			</ComplexValue>
		</Value>
	</xsl:template>


	<xsl:template match="field" mode="format-field">
		<xsl:param name="value"/>
		<xsl:call-template name="generate-field">
			<xsl:with-param name="val" select="$value"/>
		</xsl:call-template>	
	</xsl:template>

	<xsl:template match="field[@datatype='boolean']" mode="format-field" priority="8">
		<xsl:param name="value"/>
		<xsl:variable name="val2">
			<xsl:choose>
				<xsl:when test="@datatype = 'boolean'">
					<xsl:variable name="bval" select="translate($value, $uppercase, $smallcase)"/>
					<xsl:choose>
						<xsl:when test="@trueval and $bval = 'true'">
							<xsl:value-of select="@trueval"/>
						</xsl:when>
						<xsl:when test="@falseval and $bval != 'true'">
							<xsl:value-of select="@falseval"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$bval"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="generate-field">
			<xsl:with-param name="val" select="$val2"/>
		</xsl:call-template>	
	</xsl:template>

	<xsl:template name="generate-field">
		<xsl:param name="val"/>
		<xsl:choose>
			<xsl:when test="string-length($val) &gt; 0">
				<Value>
					<SimpleValue><xsl:value-of select="$val"/></SimpleValue>
				</Value>
			</xsl:when>
			<xsl:otherwise><Value><SimpleValue/></Value></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="source" match="index[name='CLP-TNA']">EMT-ISDA</xsl:template>
	<xsl:template mode="source" match="index">ISDA</xsl:template>

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
-->
	</xsl:template>
</xsl:stylesheet>
