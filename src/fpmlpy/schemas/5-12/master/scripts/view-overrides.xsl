<?xml version="1.0" ?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:common="http://exslt.org/common"
	xmlns:view="http://www.fpml.org/views"
	exclude-result-prefixes="common"
	version="2.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="uri" select="document-uri(/)"/>
<xsl:param name="baseDir" select="'xml/confirmation'"/>
<xsl:param name="enumDocUri" select="concat($baseDir,'/','fpml-enum-5-3.xsd')"/>
<xsl:param name="enumDoc" select="document($enumDocUri)"/>
<xsl:param name="enums" select="$enumDoc//xsd:simpleType"/>

<xsl:variable name="allComplexTypes" select="//xsd:complexType"/>
<xsl:variable name="allSimpleTypes" select="//xsd:simpleType"/>
<xsl:variable name="allGlobalElems" select="//xsd:schema/xsd:element"/>
<xsl:variable name="allGroups" select="//xsd:schema/xsd:group"/>
<xsl:variable name="allTypeRefs" select="//xsd:*[@type|@base]"/>
<xsl:variable name="allElemRefs" select="//xsd:element[@ref]"/>
<xsl:variable name="allGroupRefs" select="//xsd:group[@ref]"/>
<xsl:variable name="allElemDefs" select="//xsd:element[@type]"/>
<xsl:variable name="allTypeRefParents">
	<xsl:apply-templates select="$allTypeRefs|$allGlobalElems|$allElemRefs|$allGroupRefs"
			mode="reference">
		<xsl:sort select="@type|@base|@ref"/>
	</xsl:apply-templates>
</xsl:variable>

<!-- reference mode -->

<xsl:template mode="reference" match="xsd:element[name(..)='xsd:schema']" priority="10">
	<referenced name="{@type}">
		<reference type="globalElement">
			<xsl:value-of select="@name"/>
		</reference>
	</referenced>
</xsl:template>

<xsl:template mode="reference" match="xsd:restriction[contains(@base, 'xsd:')]"/>


<xsl:template mode="reference" match="node()">
	<referenced name="{@type|@base|@ref}">
		<xsl:apply-templates mode="referer" 
			select="ancestor::xsd:complexType|ancestor::xsd:group"/>
	</referenced>
</xsl:template>

<xsl:template mode="referer" match="xsd:*[name(..)='xsd:schema']">
<!--
	<xsl:attribute name="reference">
	-->
	<reference type="{local-name(.)}">
		<xsl:value-of select="@name"/>
	</reference>
		<!--
	</xsl:attribute>
	-->
</xsl:template>

<!-- Roots -->

<xsl:variable name="roots">
	<asset class="Rates">
		<element>swap</element>
		<element>capFloor</element>
		<element>fra</element>
		<element>swaption</element>
		<type>bulletPayment</type>
		<type>Swap</type>
		<type>CapFloor</type>
		<type>Fra</type>
		<type>Swaption</type>
	</asset>
	<asset class="Credit">
		<element>creditDefaultSwap</element>
		<element>creditDefaultSwapOption</element>
		<element>bondOption</element>
		<type>CreditDefaultSwap</type>
		<type>CreditDefaultSwapOption</type>
		<type>BondOption</type>
	</asset>
	<asset class="FX">
		<element>fxSingleLeg</element>
		<element>fxSwap</element>
		<element>fxOption</element>
		<element>fxDigitalOption</element>
		<element>termDeposit</element>
	</asset>
	<asset class="Equities">
		<element>returnSwap</element>
		<element>equitySwapTransactionSupplement</element>
		<element>brokerEquityOption</element>
		<element>equityForward</element>
		<element>equityOption</element>
		<element>equityOptionTransactionSupplement</element>
		<element>varianceSwap</element>
		<element>varianceSwapTransactionSupplement</element>
		<element>varianceOptionTransactionSupplement</element>
		<element>dividendSwapTransactionSupplement</element>
		<element>correlationSwap</element>
	</asset>
	<asset class="Commodities">
		<element>commoditySwap</element>
		<element>commodityForward</element>
		<element>commodityOption</element>
	</asset>
</xsl:variable>

<xsl:variable name="skip">
	<type>Portfolio</type>
	<type>ValuationDocument</type>
	<type>Formula</type>
	<element>returnLeg</element>
	<element>exposureReport</element>
	<type>ExposureReport</type>
	<type>Exposure</type>
	<type>ReportedExposure</type>
	<element>exposure</element>
	<element>amendment</element>
	<element>increase</element>
	<element>termination</element>
	<element>novation</element>
	<element>optionExercise</element>
	<element>optionExpiry</element>
	<element>deClear</element>
	<element>additionalEvent</element>
</xsl:variable>

<xsl:template match="/">
	<output>
		<xsl:variable name="data">
			<isOverridden>
				<xsl:apply-templates mode="is.overridden" select="$allComplexTypes|$allGroups"/>
			</isOverridden>
			<isSkipped>
				<xsl:apply-templates mode="is.skipped" select="$allComplexTypes|$allGroups"/>
			</isSkipped>
			<xsl:message>********* Doing references </xsl:message>

			<allTypeRefs>
				<xsl:copy-of select="$allTypeRefParents"/>
			</allTypeRefs>
				

			<!--
			<xsl:apply-templates mode="hierarchy" select="$allComplexTypes"/>
			<xsl:apply-templates mode="hierarchy" select="$allGlobalElems[@name = $roots/element]"/>
			<xsl:apply-templates mode="hierarchy" select="$allComplexTypes[@name = $roots/type]"/>
			-->
		</xsl:variable>

		<data>
			<xsl:copy-of select="$data"/>
		</data>
		<xsl:message>********* Doing asset classes </xsl:message>
		<xsl:for-each select="$roots//asset">
			<assetClassOverrides>
				<xsl:copy-of select="@class"/>
				<xsl:variable name="rt" select="."/>
				<xsl:variable name="inc">
					<isIncluded>
						<xsl:copy-of select="@class"/>
						<xsl:variable name="num" select="count($allComplexTypes|$allGroups)"/>
						<xsl:apply-templates mode="is.included" select="$allComplexTypes|$allGroups">
							<xsl:with-param name="roots" select="$rt"/>
							<xsl:with-param name="num" select="$num"/>
						</xsl:apply-templates>
					</isIncluded>
				</xsl:variable>
				<xsl:copy-of select="$inc"/>
				<xsl:for-each select="$inc/isIncluded/type">
					<xsl:variable name="name" select="@name"/>
					<xsl:variable name="this.skipped" select="$data/isSkipped/*[not(@within) and .=$name]"/>
					<xsl:choose>
						<xsl:when test="$this.skipped">
							<xsl:message><xsl:value-of select="$name"/> is skipped</xsl:message>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="skipped" >
								<xsl:copy-of select="$data/isSkipped/*[@within=$name]"/>
								<xsl:copy-of select="$data/isSkipped[.=$name]"/>
							</xsl:variable>
							<xsl:variable name="overridden" >
								<xsl:copy-of select="$data/isOverridden/*[@within=$name]"/>
								<xsl:copy-of select="$data/isOverridden[.=$name]"/>
							</xsl:variable>
							<type name="{$name}">
								<skipped>
									<xsl:copy-of select="$skipped"/>
								</skipped>
								<required>
									<xsl:copy-of select="$overridden"/>
								</required>
								<optional>
									<xsl:apply-templates select="$allComplexTypes[@name=$name]" mode="contents">
										<xsl:with-param name="skipped" select="$skipped"/>
										<xsl:with-param name="overridden" select="$overridden"/>
										<xsl:with-param name="within" select="$name"/>
									</xsl:apply-templates>
								</optional>
							</type>
							<skipped>
								<xsl:copy-of select="$data/isSkipped/*[@within=$name]"/>
								<xsl:copy-of select="$data/isSkipped[.=$name]"/>
							</skipped>
							<overridden>
								<xsl:copy-of select="$data/isOverridden/*[@within=$name]"/>
								<xsl:copy-of select="$data/isOverridden[.=$name]"/>
							</overridden>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!--
				<skipped>
					<xsl:copy-of select="$data/isSkipped/*[@within=$inc/isIncluded/type/@name]"/>
					<xsl:copy-of select="$data/isSkipped[.=$inc/isIncluded/type/@name]"/>
				</skipped>
				<overridden>
					<xsl:copy-of select="$data/isOverridden/*[@within=$inc/isIncluded/type/@name]"/>
					<xsl:copy-of select="$data/isOverridden[.=$inc/isIncluded/type/@name]"/>
				</overridden>
				-->
			</assetClassOverrides>
		</xsl:for-each>
	</output>
</xsl:template>

<xsl:template mode="contents" match="xsd:complexType|xsd:group[@name]|xsd:choice|xsd:sequence|xsd:complexContent">
	<xsl:param name="skipped"/>
	<xsl:param name="overridden"/>
	<xsl:param name="within"/>
	<xsl:apply-templates select="*" mode="contents">
		<xsl:with-param name="skipped" select="$skipped"/>
		<xsl:with-param name="overridden" select="$overridden"/>
		<xsl:with-param name="within" select="$within"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template mode="contents" match="xsd:group[@ref]">
	<xsl:param name="skipped"/>
	<xsl:param name="overridden"/>
	<xsl:param name="within"/>
	<xsl:variable name="ref" select="@ref"/>
	<xsl:message>Referencing <xsl:value-of select="$ref"/> within <xsl:value-of select="$within"/>, found <xsl:value-of select="count($allGroups[@name=$ref])"/></xsl:message>
	<xsl:apply-templates select="$allGroups[@name=$ref]" mode="contents">
		<xsl:with-param name="skipped" select="$skipped"/>
		<xsl:with-param name="overridden" select="$overridden"/>
		<xsl:with-param name="within" select="$within"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template mode="contents" match="xsd:extension">
	<xsl:param name="skipped"/>
	<xsl:param name="overridden"/>
	<xsl:param name="within"/>
	<xsl:variable name="name" select="@name"/>
	<xsl:apply-templates select="$allComplexTypes[@name=$name]" mode="contents">
		<xsl:with-param name="skipped" select="$skipped"/>
		<xsl:with-param name="overridden" select="$overridden"/>
		<xsl:with-param name="within" select="$within"/>
	</xsl:apply-templates>
	<xsl:apply-templates select="*" mode="contents">
		<xsl:with-param name="skipped" select="$skipped"/>
		<xsl:with-param name="overridden" select="$overridden"/>
		<xsl:with-param name="within" select="$within"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template mode="contents" match="xsd:element">
	<xsl:param name="skipped"/>
	<xsl:param name="overridden"/>
	<xsl:param name="within"/>
	<xsl:variable name="name" select="@name"/>
	<xsl:variable name="sk" select="count(*[$skipped//text()=$name])"/>
	<xsl:variable name="ov" select="count(*[$overridden//text()=$name])"/>
	<xsl:if test="$sk = 0 and $ov = 0">
		<element>
			<xsl:value-of select="$name"/>
		</element>
	</xsl:if>
</xsl:template>

<xsl:template mode="contents" match="node()" priority="-1">
</xsl:template>

<xsl:template mode="is.skipped" match="xsd:complexType[@name='ExposureReport']"/>
<xsl:template mode="is.overridden" match="xsd:complexType[@name='ExposureReport']"/>

<xsl:template mode="is.skipped" match="xsd:complexType|xsd:group">
	<xsl:variable name="name" select="@name" />
	<!--
	<xsl:message>====================(<xsl:value-of select="$name"/>)==============</xsl:message>
	-->
	<xsl:if test="./xsd:annotation/xsd:appinfo/view:skip[@view='transparency']">
		<skipped>
			<xsl:copy-of select="./xsd:annotation/xsd:appinfo/view:skip[@view='transparency']/@rationale"/>
			<xsl:value-of select="$name"/>
		</skipped>
	</xsl:if>
	<xsl:for-each select=".//*[./xsd:annotation/xsd:appinfo/view:skip[@view='transparency']]">
		<xsl:apply-templates mode="record.skip" select=".">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="rationale" select="xsd:annotation/xsd:appinfo/view:skip[@view='transparency']/@rationale"/>
		</xsl:apply-templates>
	</xsl:for-each>
</xsl:template>

<xsl:template mode="record.skip" match="xsd:sequence|xsd:choice">
	<xsl:param name="name"/>
	<xsl:param name="rationale"/>
	<xsl:comment>Skip within sequence</xsl:comment>
	<xsl:apply-templates mode="record.skip" select=".//xsd:element|.//xsd:group">
		<xsl:with-param name="name" select="$name"/>
		<xsl:with-param name="rationale" select="$rationale"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template mode="record.skip" match="xsd:element|xsd:group">
	<xsl:param name="name" select="@name" />
	<xsl:param name="rationale"/>
	<skipped within="{$name}">
		<xsl:if test="$rationale">
			<xsl:attribute name="rationale" select="$rationale"/>
		</xsl:if>
		<xsl:value-of select="@name"/>
	</skipped>
</xsl:template>

<xsl:template mode="is.overridden" match="xsd:complexType|xsd:group">
	<xsl:variable name="name" select="@name" />
	<!--
	<xsl:message>====================(<xsl:value-of select="$name"/>)==============</xsl:message>
	-->
	<xsl:if test="./xsd:annotation/xsd:appinfo/view:override[@view='transparency']">
		<overridden>
			<xsl:value-of select="$name"/>
		</overridden>
	</xsl:if>
	<xsl:for-each select=".//*[./xsd:annotation/xsd:appinfo/view:override[@view='transparency']]">
		<overridden within="{$name}">
			<xsl:value-of select="@name"/>
		</overridden>
	</xsl:for-each>
</xsl:template>

<xsl:template mode="is.included" match="xsd:complexType[@name='ExposureReport']"/>

<xsl:template mode="is.included" match="xsd:complexType|xsd:group">
	<xsl:param name="roots"  />
	<xsl:param name="num"  />
	<xsl:variable name="name" select="@name" />
	<xsl:message>========(<xsl:value-of select="$name"/> - <xsl:value-of select="position()"/> of <xsl:value-of select="$num"/>)==============</xsl:message>
	<xsl:variable name="refs" select="$allTypeRefParents/referenced[@name=$name]/*" />
	<xsl:variable name="is.included">
		<xsl:call-template name="is.type.included">
			<xsl:with-param name="refs" select="$refs"/>
			<xsl:with-param name="roots" select="$roots"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:if test="string-length($is.included) &gt; 0">
		<xsl:message>Top return <xsl:value-of select="$is.included"/></xsl:message>
		<type name="{$name}" included="{$is.included}">
		<!--
			<xsl:copy-of select="$refs"/>
			-->
		</type>
	</xsl:if>
</xsl:template>

<xsl:template name="is.type.included" >
	<xsl:param name="refs"/>
	<xsl:param name="roots"/>
	<xsl:if test="$refs">
		<xsl:variable name="first" select="$refs[1]"/>
		<xsl:variable name="rest" select="$refs[position() &gt; 1]"/>
		<!--
		<xsl:message>Trying is.type.included with <xsl:value-of select="count($refs)"/>, rest has <xsl:value-of select="count($rest)"/></xsl:message>
		-->
		<!-- the variable "restlen" is not used but forces $rest to be evaluated correctly, to avoid an apparent Saxon bug -->
		<xsl:variable name="restlen" select="count($rest)"/>
		<xsl:variable name="is.first.included">
			<xsl:apply-templates mode="is.a.ref.included" select="$first">
				<xsl:with-param name="roots" select="$roots"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:value-of select="$is.first.included"/>
		<xsl:if test="string-length($is.first.included)">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:call-template name="is.type.included">
			<xsl:with-param name="refs" select="$rest"/>
			<xsl:with-param name="roots" select="$roots"/>
		</xsl:call-template>

			<!--
		<xsl:choose>
			<xsl:when test="string-length($is.first.included) &gt; 0">
				<xsl:message>Got <xsl:value-of select="$is.first.included"/></xsl:message>
				<xsl:value-of select="$is.first.included"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="is.type.included">
					<xsl:with-param name="refs" select="$rest"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
				-->
	</xsl:if>
</xsl:template>

<xsl:template mode="is.a.ref.included" match="node()" >
	<xsl:param name="roots" />
	<xsl:variable name="ref.item" select="text()"/>
	<!--
	<xsl:message>trying <xsl:value-of select="$ref.item"/></xsl:message>
	-->
	<xsl:variable name="res" select="$roots/*[text()=$ref.item]"/>
	<xsl:variable name="is.skip" select="$skip/*[text()=$ref.item]"/>
	<xsl:choose>
		<xsl:when test="$is.skip" > <!-- do nothing-->
			<!--
			<xsl:message>Skipped <xsl:value-of select="$ref.item"/></xsl:message>
			-->
		</xsl:when>
		<xsl:when test="string-length($res) &gt; 0">
			<!--
			<xsl:message>tried <xsl:value-of select="$ref.item"/>, got <xsl:value-of select="$res"/></xsl:message>
			-->
			<xsl:value-of select="$res"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="refs" select="$allTypeRefParents/referenced[@name=$ref.item]/*" />
			<xsl:variable name="is.included">
				<xsl:call-template name="is.type.included">
					<xsl:with-param name="refs" select="$refs"/>
					<xsl:with-param name="roots" select="$roots"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="string-length($is.included) &gt; 0">
				<!--
				<xsl:message>Returning <xsl:value-of select="$is.included"/></xsl:message>
				-->
			</xsl:if>
			<xsl:value-of select="$is.included"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<!-- hierarchy -->
<xsl:template mode="hierarchy" match="xsd:element|xsd:complexType">
	<xsl:variable name="has.parent">
		<xsl:apply-templates mode="has.included.parent" select="."/>
	</xsl:variable>
	<xsl:if test="string-length($has.parent) &gt; 0">
		<element>
			<xsl:value-of select="@name"/>
		</element>
	</xsl:if>
</xsl:template>

<xsl:template mode="has.included.parent" match="xsd:schema"/>

<xsl:template mode="has.included.parent" match="xsd:element[local-name(..) = 'schema']">
	<xsl:variable name="name" select="@name"/>
	<xsl:if test="$roots[element=$name]">1</xsl:if>
</xsl:template>

<xsl:template mode="has.included.parent" match="xsd:element">
	<xsl:apply-templates select="ancestor::xsd:complexType|ancestor::xsd:element" mode="has.included.parent"/>
</xsl:template>

<xsl:template mode="has.included.parent" match="xsd:complexType">
	<xsl:choose>
		<xsl:when test="@name = $roots/type">1</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="name" select="@name"/>
			<xsl:apply-templates mode="has.included.parent"
				select="$allTypeRefs[@type=$name]"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
