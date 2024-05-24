<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:common="http://exslt.org/common" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation" exclude-result-prefixes="common">

        <xsl:import href="xl2scheme.xsl"/>

	<xsl:param name="pwd"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz1234567890_-'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_-'" />

	<xsl:template match="schemeDefinitions">
		<xsl:variable name="content">
			<schemeDefinitions>
				<xsl:copy-of select="*"/>
				<xsl:call-template name="construct-excel-schemes"/>
			</schemeDefinitions>
		</xsl:variable>
		<xsl:apply-templates select="common:node-set($content)" mode="process-files"/>
	</xsl:template>


	<xsl:template match="*" mode="process-files">
		<xsl:variable name="catalog.version" select="version[contains(@scope, $scope)]/@catalogVersion"/>
		<xsl:variable name="catalog.date" select="version/@catalogDate"/>
		<xsl:result-document href="{$pwd}/set-of-schemes-{$catalog.version}.xml">
			<gcl:CodeListSet xmlns:gcl="http://xml.genericode.org/2004/ns/CodeList/0.2/" xmlns:doc="http://www.fpml.org/coding-scheme/documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xml.genericode.org/2004/ns/CodeList/0.2/ CodeList.xsd">
				<Annotation>
					<Description>
						<doc:definition>

							<xsl:text>Definition of references to the set of FpML coding schemes.</xsl:text>
						</doc:definition>
						<doc:publicationDate>
							<xsl:value-of select="$catalog.date"/>
						</doc:publicationDate>
						<xsl:apply-templates mode="copy-changes" select="."/>
					</Description>
				</Annotation>
				<Identification>
					<ShortName>
						<xsl:text>FpML Set of Coding Schemes</xsl:text>
					</ShortName>
					<Version>
						<xsl:value-of select="$catalog.version"/>
					</Version>
					<CanonicalUri>
						<xsl:text>http://www.fpml.org/coding-scheme/set-of-schemes</xsl:text>
					</CanonicalUri>
					<CanonicalVersionUri>
						<xsl:text>http://www.fpml.org/coding-scheme/set-of-schemes-</xsl:text>
						<xsl:value-of select="$catalog.version"/>
					</CanonicalVersionUri>
					<!-- in order to publish the files and the url resolves-->
					<LocationUri>
						<xsl:text>http://www.fpml.org/coding-scheme/set-of-schemes-</xsl:text>
						<xsl:value-of select="$catalog.version"/>
						<xsl:text>.xml</xsl:text>
					</LocationUri>
				</Identification>
				<xsl:apply-templates select="scheme" mode="bigFile"/>
				<xsl:apply-templates select="scheme"/>
				<xsl:apply-templates select="scheme" mode="validateUri"/>
				<xsl:message/>
				<xsl:apply-templates select="scheme" mode="list-drafts"/>
				<xsl:message/>
			</gcl:CodeListSet>
		</xsl:result-document>
	</xsl:template>

	<xsl:template mode="list-drafts" match="node()" priority="-1"/>

	<xsl:template mode="list-drafts" match="scheme[@status = 'working-draft']">
		<xsl:message>==<xsl:value-of select="@name"/> is in working draft status.==</xsl:message>
	</xsl:template>

	<xsl:template mode="copy-changes" match="schemeDefinitions">
		<xsl:variable name="changes" select="section[@name = 'CHANGES IN THIS VERSION']"/>
		<doc:changeDescription>
			<xsl:apply-templates select="$changes"/>
		</doc:changeDescription>
	</xsl:template>

	<!-- uri validation -->
	<xsl:template match="scheme[@name = 'entityIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'entityNameScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'exchangeIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->
	<xsl:template match="scheme[@name = 'instrumentIdScheme']" mode="validateUri" priority="10"/>
	<!-- skip this due to historical issues -->

	<xsl:template match="scheme[@external = 'yes']" mode="validateUri">
		<xsl:variable name="uri" select="substring-after(@uri, 'http://www.fpml.org/coding-scheme/external/')"/>
		<xsl:variable name="canUri" select="substring-after(@canUri, 'http://www.fpml.org/coding-scheme/external/')"/>
		<xsl:if test="not(starts-with($uri, $canUri))">
			<xsl:message>!!!!!!!!!!!!!!!!!!!</xsl:message>
			<xsl:message>Invalid uri/canonical URI combination for <xsl:value-of select="@name"/></xsl:message>
			<xsl:message>URI is <xsl:value-of select="@uri"/></xsl:message>
			<xsl:message>Canonical URI is <xsl:value-of select="@canUri"/></xsl:message>
			<xsl:message>!!!!!!!!!!!!!!!!!!!</xsl:message>
		</xsl:if>
	</xsl:template>
	<xsl:template match="scheme" mode="validateUri">
		<xsl:if test="not(starts-with(@uri, @canUri))">
			<xsl:message>!!!!!!!!!!!!!!!!!!!</xsl:message>
			<xsl:message>Invalid uri/canonical URI combination for <xsl:value-of select="@name"/></xsl:message>
			<xsl:message>URI is <xsl:value-of select="@uri"/></xsl:message>
			<xsl:message>Canonical URI is <xsl:value-of select="@canUri"/></xsl:message>
			<xsl:message>!!!!!!!!!!!!!!!!!!!</xsl:message>
		</xsl:if>
	</xsl:template>

	<!-- file generation -->
	<xsl:template match="scheme" mode="bigFile">
		<xsl:choose>
			<xsl:when test="@scope and (not(contains(@scope,$scope)))">
			</xsl:when>
			<xsl:when test="schemeValues">
				<CodeListRef>
					<Annotation>
						<Description>
							<xsl:apply-templates select="schemeDefinition"/>
							<xsl:apply-templates select="schemeDescription"/>
							<xsl:apply-templates select="." mode="publication-date"/>
							<xsl:apply-templates select="." mode="status"/>
						</Description>
					</Annotation>
					<CanonicalUri>
						<xsl:value-of select="@canUri"/>
					</CanonicalUri>
					<CanonicalVersionUri>
						<xsl:value-of select="@uri"/>
					</CanonicalVersionUri>
					<!-- in order to publish the files and the url resolves-->
					<LocationUri>
						<xsl:value-of select="@url"/>
					</LocationUri>
					<xsl:apply-templates select="scheme" mode="bigFile"/>
				</CodeListRef>
			</xsl:when>
			<xsl:otherwise>
				<!--
				
				-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="scheme" mode="publication-date" priority="-1">
		<!-- default template does nothing -->
		<xsl:message>skip pub date for <xsl:value-of select="@name"/>, no date specified</xsl:message>
	</xsl:template>

	<xsl:template mode="publication-date" match="scheme[@publicationDate]">
		<xsl:message>****** pub date for <xsl:value-of select="@name"/>, ****** <xsl:value-of select="@publicationDate"/></xsl:message>
		<doc:publicationDate>
			<xsl:value-of select="@publicationDate"/>
		</doc:publicationDate>
	</xsl:template>

	<xsl:template match="scheme" mode="status" priority="-2"/>

	<xsl:template match="scheme[@status = 'working-draft']" mode="status" priority="-1">
		<doc:status>working-draft</doc:status>
	</xsl:template>

	<xsl:template match="scheme">
		<xsl:choose>
			<xsl:when test="@scope and (not(contains(@scope,$scope)))">
			</xsl:when>
			<xsl:when test="schemeValues">
				<xsl:result-document href="{$pwd}/{@fileName}">
					<gcl:CodeList xmlns:gcl="http://xml.genericode.org/2004/ns/CodeList/0.2/" xmlns:doc="http://www.fpml.org/coding-scheme/documentation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xml.genericode.org/2004/ns/CodeList/0.2/ CodeList.xsd">
						<Annotation>
							<Description>
								<xsl:apply-templates select="schemeDefinition"/>
								<xsl:apply-templates select="schemeDescription"/>
								<xsl:apply-templates select="." mode="publication-date"/>
								<xsl:apply-templates select="." mode="status"/>
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
							<xsl:if test="@canUri = 'http://www.fpml.org/coding-scheme/floating-rate-index'">
								<Column Id="Style" Use="optional">
									<ShortName>Style</ShortName>
									<Data Type="string"/>
								</Column>
								<Key Id="PrimaryKey">
									<ShortName>key</ShortName>
									<ColumnRef Ref="Code"/>
								</Key>
							</xsl:if>
							<xsl:if test="@canUri != 'http://www.fpml.org/coding-scheme/floating-rate-index'">
								<Key Id="PrimaryKey">
									<ShortName>key</ShortName>
									<ColumnRef Ref="Code"/>
								</Key>
							</xsl:if>
						</ColumnSet>
						<xsl:if test="@canUri = 'http://www.fpml.org/coding-scheme/floating-rate-index'">
							<xsl:variable name="rows">
								<xsl:apply-templates select="schemeValues/schemeValue" mode="style"/>
							</xsl:variable>
							<SimpleCodeList>
								<xsl:for-each select="$rows/Row">
									<xsl:sort select = "@sortval" data-type="text" order="ascending" />
									<xsl:copy>
										<xsl:copy-of select="*"/>
									</xsl:copy>
								</xsl:for-each>
							</SimpleCodeList>
						</xsl:if>
						<xsl:if test="@canUri != 'http://www.fpml.org/coding-scheme/floating-rate-index'">
							<xsl:variable name="rows">
								<xsl:apply-templates select="schemeValues/schemeValue" />
							</xsl:variable>
							<SimpleCodeList>
								<xsl:for-each select="$rows/Row">
									<xsl:sort select = "@sortval" data-type="text" order="ascending" />
									<xsl:copy>
										<xsl:copy-of select="*"/>
									</xsl:copy>
								</xsl:for-each>
							</SimpleCodeList>
							<!--
							<xsl:apply-templates select="schemeValues">
								<xsl:sort select = "translate(Value[1]/SimpleValue, $uppercase, $smallcase)" data-type="text" order="ascending" />
							</xsl:apply-templates>
							-->
						</xsl:if>
					</gcl:CodeList>
				</xsl:result-document>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="schemeDefinition">
		<doc:definition>
			<xsl:value-of select="."/>
		</doc:definition>
	</xsl:template>
	<xsl:template match="schemeDescription">
		<doc:description>
			<xsl:for-each select="paragraph">
				<doc:paragraph>
					<xsl:value-of select="."/>
				</doc:paragraph>
			</xsl:for-each>
		</doc:description>
	</xsl:template>
	<xsl:template match="codeDescription">
		<doc:description>
			<xsl:for-each select="paragraph">
				<doc:paragraph>
					<xsl:value-of select="*"/>
					<xsl:value-of select="."/>
				</doc:paragraph>
			</xsl:for-each>
		</doc:description>
	</xsl:template>
	<xsl:template match="schemeValues">
		<SimpleCodeList>
			<xsl:apply-templates select="schemeValue"/>
		</SimpleCodeList>
	</xsl:template>
	<xsl:template match="schemeValues" mode="style">
		<SimpleCodeList>
			<xsl:apply-templates select="schemeValue" mode="style"/>
		</SimpleCodeList>
	</xsl:template>
	<xsl:template match="schemeValue">
		<Row sortval="{translate(@name, $uppercase, $smallcase)}" >
			<xsl:if test="codeDescription">
				<Annotation>
					<Description>
						<xsl:apply-templates select="codeDescription"/>
					</Description>
				</Annotation>
			</xsl:if>
			<Value>
				<SimpleValue>
					<xsl:value-of select="@name"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue>
					<xsl:value-of select="@schemeValueSource"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue>
					<xsl:value-of select="paragraph"/>
				</SimpleValue>
			</Value>
		</Row>
	</xsl:template>
	<xsl:template match="schemeValue" mode="style">
		<Row sortval="{translate(@name, $uppercase, $smallcase)}" >
			<xsl:if test="codeDescription">
				<Annotation>
					<Description>
						<xsl:apply-templates select="codeDescription"/>
					</Description>
				</Annotation>
			</xsl:if>
			<Value>
				<SimpleValue>
					<xsl:value-of select="@name"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue>
					<xsl:value-of select="@schemeValueSource"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue>
					<xsl:value-of select="paragraph"/>
				</SimpleValue>
			</Value>
			<Value>
				<SimpleValue>
					<xsl:value-of select="@style"/>
				</SimpleValue>
			</Value>
		</Row>
	</xsl:template>
	<xsl:template match="alternateURI">
		<CodeListRef>
			<Annotation>
				<Description>
					<xsl:apply-templates select="schemeDescription"/>
				</Description>
			</Annotation>
			<CanonicalUri>
				<xsl:value-of select="@canUri"/>
			</CanonicalUri>
			<CanonicalVersionUri>
				<xsl:value-of select="@uri"/>
			</CanonicalVersionUri>
			<!--URL's added 1-2-2005-->
			<LocationUri>
				<xsl:value-of select="@url"/>
			</LocationUri>
		</CodeListRef>
	</xsl:template>

	<xsl:template match="bullets" priority="10">
		<xsl:if test="not(@scope)  or (not(contains(@scope, $notscope)) and (contains(@scope, '!') or contains(@scope, $scope)))">
		<ul class="bulleted">
			<xsl:apply-templates/>
		</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="bullet" priority="10">
		<xsl:if test="not(@scope)  or (not(contains(@scope, $notscope)) and (contains(@scope, '!') or contains(@scope, $scope)))">
		<li>
			<xsl:apply-templates/>
		</li>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
