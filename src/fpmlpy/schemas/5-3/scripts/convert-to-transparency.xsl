<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
	xmlns="http://www.fpml.org/FpML-5/transparency"
	xmlns:common="http://exslt.org/common" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:saxon="http://saxon.sf.net/"
	exclude-result-prefixes="common xsd saxon"
	>
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" standalone="yes"/>


	<xsl:param name="sender.msg.id.scheme" select="'http://abc.com/message-id'"/>
	<xsl:param name="msg.id" select="'123'"/>
	<xsl:param name="sender.corr.id.scheme" select="'http://abc.com/correlation-id'"/>
	<xsl:param name="correlation.id" select="'456'"/>
	<xsl:param name="sender" select="'abc'"/>
	<xsl:param name="recipient" select="'sdr'"/>
	<xsl:param name="time" select="'2011-01-01T00:00:00'"/>
	<xsl:param name="exec.timestamp" select="'2011-01-01T09:12:34'"/>
	<xsl:param name="current.date" select="'Fri 05/20/2011'"/>
	<xsl:param name ="current.year" select="substring($current.date,11)"/>

	<!--<xsl:param name="uri">http://www.fpml.org/FpML-5/confirmation</xsl:param>-->
	
	<xsl:variable name="ns" select="'http://www.fpml.org/FpML-5/transparency'"/>

	<xsl:template match="node() | @*" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>	
	<!-- update copyright notice -->
	<xsl:template match="comment()[contains(.,'Copyright (c) ')]" >
		<xsl:variable name="front" select="substring-before(.,'Copyright (c) ')"/>
		<xsl:variable name="temp" select="substring-after(.,'Copyright (c) ')"/>
		<xsl:variable name="back" select="substring-after($temp, ' ')"/>
		<xsl:comment>
			<xsl:value-of select="$front"/>
			<xsl:text>Copyright (c) 2002-</xsl:text>
			<xsl:value-of select="$current.year"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$back"/>
		</xsl:comment>
        </xsl:template>

	<xsl:template match="*[*:trade]">
		<xsl:apply-templates select="." mode="gen-transparency-message"/>
	</xsl:template>	

	<xsl:template match="*" mode="gen-transparency-message">
		<publicExecutionReport fpmlVersion="5-3" xsi:schemaLocation="http://www.fpml.org/FpML-5/transparency ../../fpml-main-5-3.xsd" >
			<xsl:apply-templates mode="conv-header" select="."/>
			<isCorrection>false</isCorrection>
			<correlationId correlationIdScheme="{$sender.corr.id.scheme}">
				<xsl:value-of select="$correlation.id"/>
			</correlationId>
			<sequenceNumber>1</sequenceNumber>
			<xsl:apply-templates mode="conv-trade" select="*:trade"/>
		</publicExecutionReport>
	</xsl:template>	

	<!-- message header -->
	<xsl:template match="*[*:header]" mode="conv-header">
		<xsl:apply-templates mode="migrate-namespace" select="*[*:header]"/>
	</xsl:template>	

	<xsl:template match="*" mode="conv-header" priority="-1">
		<header>
			<messageId messageIdScheme="{$sender.msg.id.scheme}">
				<xsl:value-of select="$msg.id"/>
			</messageId>
			<sentBy>
				<xsl:value-of select="$sender"/>
			</sentBy>
			<sendTo>
				<xsl:value-of select="$recipient"/>
			</sendTo>
			<creationTimestamp>
				<xsl:value-of select="$time"/>
			</creationTimestamp>
		</header>
	</xsl:template>	

	<xsl:template match="node()" mode="migrate-namespace" priority="-1">
		<xsl:copy-of select="."/>
	</xsl:template>	

	<xsl:template match="*" mode="migrate-namespace">
		<xsl:variable name="tag" select="local-name(.)"/>
		<xsl:element name="{$tag}" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="migrate-namespace" />
		</xsl:element>
	</xsl:template>	

	<!-- trade -->
	<xsl:template match="*" mode="conv-trade">
		<xsl:variable name="trade" select="."/>
		<xsl:variable name="header" select="$trade/*[1]"/>
		<xsl:variable name="product" select="$trade/*[2]"/>

		<originatingEvent>Trade</originatingEvent>
		<trade>
			<tradeHeader>
				<xsl:apply-templates mode="conv-info" select="$header/*:partyTradeIdentifier"/>
				<xsl:call-template name="generate-trade-info"/>
				<xsl:apply-templates mode="migrate-namespace" select="$header/*:tradeDate"/>
			</tradeHeader>
			<xsl:apply-templates mode="convert-product" select="$product"/>
		</trade>
	</xsl:template>	

	<xsl:template name="generate-trade-info">
		<tradeInformation>
			<executionDateTime>
				<xsl:value-of select="$exec.timestamp"/>
			</executionDateTime>
			<intentToClear>false</intentToClear>
			<nonStandardTerms>true</nonStandardTerms>
			<offMarketPrice>true</offMarketPrice>
			<largeSizeTrade>false</largeSizeTrade>
			<executionType>Electronic</executionType>
			<executionVenueType>SEF</executionVenueType>
		</tradeInformation>
	</xsl:template>	

	<xsl:variable name="skipped.tags.tf">
		<skip>partyReference</skip>
		<skip>payerPartyReference</skip>
		<skip>receiverPartyReference</skip>
		<skip>buyerPartyReference</skip>
		<skip>sellerPartyReference</skip>
		<skip>dateAdjustments</skip>
		<skip>relevantUnderlyingDate</skip>
		<skip fail="true">relativeEffectiveDate</skip>
		<skip fail="true">relativeTerminationDate</skip>
		<skip>earliestExerciseTime</skip>
		<skip>optionalEarlyTerminationParameters</skip>
		<skip>optionalEarlyTerminationAdjustedDates</skip>
		<skip>mandatoryEarlyTerminationDate</skip>
		<skip>cashSettlement</skip>
		<skip>mandatoryEarlyTerminationAdjustedDates</skip>
		<skip>singlePartyOption</skip>
		<skip>exerciseNotice</skip>
		<skip>followupConfirmation</skip>
		<skip></skip>
		<skip>latestExerciseTime</skip>
		<skip>latestExerciseTimeDetermination</skip>
		<skip>expirationTime</skip>
		<skip>exerciseProcedure</skip>
		<skip>multipleExercise</skip>
		<skip>partialExercise</skip>
		<skip>expirationTime</skip>
		<skip>exerciseNotice</skip>
		<skip>followUpConfirmation</skip>
		<skip>exerciseFee</skip>
		<skip>exerciseFeeSchedule</skip>
		<skip fail="true">fxLinkedNotionalSchedule</skip>
		<skip>settlementDate</skip>
		<skip>premiumType</skip>
		<skip>dayType</skip>
		<skip>paymentDate</skip>
		<skip>adjustablePaymentDate</skip>
		<skip>adjustedPaymentDate</skip>
		<skip>settlementType</skip>
		<skip>calculationPeriodDatesAdjustments</skip>
		<skip>calculationPeriodFrequency</skip>
		<skip>rollConvention</skip>
		<skip>calculationPeriodDatesReference</skip>
		<skip>payRelativeTo</skip>
		<skip>paymentDatesAdjustments</skip>
		<skip>calculationPeriodDatesReference</skip>
		<skip>resetRelativeTo</skip>
		<skip>fixingDates</skip>
		<skip>fixingDateOffset</skip>
		<skip>calculationPeriodNumberOfDays</skip>
		<skip>resetDatesAdjustments</skip>
		<skip>stepValue</skip>
		<skip>step</skip>
		<skip>mainPublication</skip>
		<skip>interpolationMethod</skip>
		<skip>initialIndexLevel</skip>
		<skip>fallbackBondApplicable</skip>
		<skip>cashflows</skip>
		<skip>paymentDaysOffset</skip>
		<skip>finalRateRounding</skip>
		<skip>calculationAgent</skip>
		<skip>guarantor</skip>
		<skip>guarantorReference</skip>
		<skip>primaryObligor</skip>
		<skip>primaryObligorReference</skip>
		<skip>securedList</skip>
		<skip>additionalTerms</skip>
		<skip>referencePrice</skip>
		<skip>marketFixedRate</skip>
		<skip product="creditDefaultSwap">paymentFrequency</skip>
		<skip>firstPaymentDate</skip>
		<skip>firstRegularPeriodStartDate</skip>
		<skip>lastRegularPeriodEndDate</skip>
		<skip>firstPeriodStartDate</skip>
		<skip>stub</skip>
		<skip>stubCalculationPeriodAmount</skip>
		<skip>stubCalculationPeriod</skip>
		<skip>indexSeries</skip>
		<skip>indexAnnexVersion</skip>
		<skip>indexAnnexDate</skip>
		<skip>indexAnnexSource</skip>
		<skip>excludedReferenceEntity</skip>
		<skip>settledEntityMatrix</skip>
		<skip>lastRegularPaymentDate</skip>
		<skip>allGuarantees</skip>
		<skip>paymentDelay</skip>
		<skip>compoundingMethod</skip>
		<skip>rateTreatment</skip>
		<skip>linkId</skip>
		<skip product="creditDefaultSwap">dayCountFraction</skip>
		<skip product="creditDefaultSwapOption">dayCountFraction</skip>
		<skip>bankruptcy</skip>
		<skip>failureToPay</skip>
		<skip>failureToPayPrincipal</skip>
		<skip>failureToPayInterest</skip>
		<skip>obligationDefault</skip>
		<skip>obligationAcceleration</skip>
		<skip>repudiationMoratorium</skip>
		<skip>distressedRatingsDowngrade</skip>
		<skip>maturityExtension</skip>
		<skip>writedown</skip>
		<skip>impliedWritedown</skip>
		<skip>defaultRequirement</skip>
		<skip>creditEventNotice</skip>
		<skip>restructuringType</skip>
		<skip>multipleHolderObligation</skip>
		<skip>multipleCreditEventNotices</skip>

		<skip>obligations</skip>
		<skip>floatingAmountEvents</skip>
		<skip>physicalSettlementTerms</skip>
		<skip>cashSettlement</skip>
		<skip>cashSettlementTerms</skip>
		<skip>floatingRateMultiplierSchedule</skip>
		<skip>valuationDatesReference</skip>
		<skip product="dividendSwapTransactionSupplement">valuationDate</skip>
		<skip>settlementProvision</skip>
		<skip>initialRate</skip>
		<skip>swaptionAdjustedDates</skip>
		<skip>feature</skip>
		<skip>description</skip>
		<skip product="returnSwap" fail="true">fxFeature</skip>
		<skip product="returnSwap" fail="true">principalExchangeFeatures</skip>
		<skip product="returnSwap">businessCentersReference</skip>
		<skip product="returnSwap" fail="true">periodicDates</skip>
		<skip product="equitySwapTransactionSupplement" fail="true">fxFeature</skip>
		<skip product="equitySwapTransactionSupplement" fail="true">principalExchangeFeatures</skip>
		<skip product="equitySwapTransactionSupplement">businessCentersReference</skip>
		<skip product="equityOptionTransactionSupplement" fail="true">fxFeature</skip>
		<skip product="equityOptionTransactionSupplement" fail="true">principalExchangeFeatures</skip>
		<skip product="equityOptionTransactionSupplement">businessCentersReference</skip>
		<skip>numberOfValuationDates</skip>
		<skip>optionsPriceValuation</skip>
		<skip>futuresPriceValuation</skip>
		<skip fail="true">periodicDates</skip>
		<skip>fxFeature</skip>
		<skip>strategyFeature</skip>
		<skip>dividendCondition</skip>
		<skip>dividendConditions</skip>
		<skip>dividendAdjustment</skip>
		<skip>methodOfAdjustment</skip>
		<skip>extraordinaryEvents</skip>
		<skip>automaticExercise</skip>
		<skip>makeWholeProvisions</skip>
		<skip>prePayment</skip>
		<skip>settlementCurrency</skip>
		<skip product="equityForward">settlementCurrency</skip>
		<skip>settlementPriceSource</skip>
		<skip product="equityOptionTransactionSupplement">settlementType</skip>
		<skip product="equityOptionTransactionSupplement">exchangeTradedContractNearest</skip>
		<skip product="varianceSwap">settlementType</skip>
		<skip>multipleExchangeIndexAnnexFallback</skip>
		<skip>componentSecurityIndexAnnexFallback</skip>
		<skip>localJurisdiction</skip>
		<skip>relevantJurisdiction</skip>
		<skip>exchangeLookAlike</skip>
		<skip>settlementMethodElectionDate</skip>
		<skip>settlementMethodElectingPartyReference</skip>
		<skip>settlementPriceDefaultElection</skip>
		<skip>optionsExchangeDividends</skip>
		<skip>additionalDividends</skip>
		<skip>allDividends</skip>
		<skip>initialFixingDate</skip>
		<skip fail="true">strikePercentage</skip>
		<skip>interestLegResetDates</skip>
		<skip>strikeDeterminationDate</skip>
		<skip>indexAdjustmentEvents</skip>
		<skip>formula</skip>
		<skip>encodedDescription</skip>
		<skip>asian</skip>
		<skip>barrier</skip>
		<skip>knock</skip>
		<skip>passThrough</skip>
		<skip>representations</skip>
		<skip>averagingDates</skip>
		<skip>breakFundingRecovery</skip>
		<skip>breakFeeElection</skip>
		<skip>breakFeeRate</skip>
		<skip>quantityFrequency</skip>
		<skip product="commoditySwap">calculationPeriodsScheduleReference</skip>
		<skip product="commodityOption">calculationPeriodsScheduleReference</skip>
		<skip product="commodityOption">exerciseFrequency</skip>
		<skip>calculationPeriodsSchedule</skip>
		<skip>lag</skip>
		<skip>businessCalendar</skip>
		<skip>settlementPeriodsReference</skip>
		<skip product="commoditySwap">calculationDates</skip>
		<skip product="commoditySwap">calculationPeriods</skip>
		<skip product="commoditySwap">calculationPeriodsSchedule</skip>
		<skip product="commoditySwap">calculationPeriodsReference</skip>
		<skip product="commoditySwap">calculationPeriodsScheduleReference</skip>
		<skip product="commoditySwap">calculationDatesReference</skip>
		<skip product="commoditySwap">paymentDates</skip>
		<skip product="commoditySwap">masterAgreementPaymentDates</skip>
		<skip product="commoditySwap">relativePaymentDates</skip>
		<skip product="commodityOption">relativePaymentDates</skip>
		<skip product="commodityOption">paymentDates</skip>
		<skip product="commodityOption">masterAgreementPaymentDates</skip>
		<skip product="swap">averagingMethod</skip>
		<skip>conversionFactor</skip>
		<skip>deliveryDateRollConvention</skip>
		<skip>rounding</skip>
		<skip>spreadSchedule</skip>
		<skip>fx</skip>
		<skip>commonPricing</skip>
		<skip>marketDisruption</skip>
		<skip>settlementDisruption</skip>
		<skip>writtenConfirmation</skip>
		<skip>businessDayConvention</skip>
		<skip>businessCenters</skip>
		<skip product="varianceSwap">relativeDate</skip>
		<skip>determinationMethod</skip>
		<skip>commodityDetails</skip>
		<skip>deliveryDate</skip>
		<skip>deliveryDateYearMonth</skip>
		<skip>deliveryDateYearRollConvention</skip>
		<skip product="commoditySwap">quality</skip>
		<skip product="commodityOption">deliveryConditions</skip>
		<skip product="commoditySwap">physicalQuantity</skip>
		<skip product="commoditySwap">physicalQuantitySchedule</skip>
		<skip product="commoditySwap">btuQualityAdjustment</skip>
		<skip product="commoditySwap">quantityVariationAdjustment</skip>
		<skip product="commoditySwap">transportationEquipment</skip>
		<skip product="commodityForward">quantityReference</skip>
		<skip product="commodityForward">paymentDates</skip>
		<skip>balanceOfFirstPeriod</skip>
		<skip>masterAgreementPaymentDates</skip>
		<skip product="commodityOption" fail="true">electricityPhysicalLeg</skip>
		<skip product="commodityOption" fail="true">oilPhysicalLeg</skip>
		<skip product="commodityOption" fail="true">coalPhysicalLeg</skip>
		<skip fail="true">versionedTradeId</skip>
		<skip product="equitySwapTransactionSupplement" fail="true">relativeDateSequence</skip>
		<skip product="equitySwapTransactionSupplement" fail="true">relativeDates</skip>
		<skip product="varianceSwapTransactionSupplement" fail="true">relativeDate</skip>
		<skip>settlementInformation</skip>
		<skip>features</skip>
		<skip>nonDeliverableSettlement</skip>
		<skip>expiryTime</skip>
		<skip>cutName</skip>
	</xsl:variable>
	<xsl:variable name="skipped.tags" select="common:node-set($skipped.tags.tf)"/>

	<xsl:variable name="product.info.tf">
		<product tag="swap" assetClass="InterestRates" productType="InterestRateSwap"/>
		<product tag="fra" assetClass="InterestRates" productType="FRA"/>
		<product tag="bondOption" assetClass="InterestRates" productType="BondOption"/>
		<product tag="equityOptionTransactionSupplement" assetClass="Equities" productType="EquityOption"/>
		<product tag="equityForward" assetClass="Equities" productType="EquityForward"/>
		<product tag="commoditySwap" assetClass="Commodities" productType="CommoditySwap"/>
		<product tag="commodityOption" assetClass="Commodities" productType="CommodityOption"/>
		<product tag="commodityForward" assetClass="Commodities" productType="CommodityForward"/>
		<product tag="creditDefaultSwapOption" assetClass="Commodities" productType="CreditDefaultOption"/>
		<product tag="varianceSwap" map="varianceSwapTransactionSupplement" assetClass="Equities" productType="VarianceSwap"/>
		<product tag="varianceOptionTransactionSupplement" assetClass="Equities" productType="VarianceOption"/>
		<product tag="varianceOption" map="varianceOptionTransactionSupplement" assetClass="Equities" productType="VarianceOption"/>
		<product tag="returnSwap" assetClass="Equities" productType="EquitySwap"/>
		<product tag="equitySwapTransactionSupplement" assetClass="Equities" productType="EquitySwap"/>
		<product tag="equitySwap" map="equitySwapTransactionSupplement" assetClass="Equities" productType="EquitySwap"/>
		<product tag="dividendSwapTransactionSupplement" assetClass="Equities" productType="DividendSwap"/>
		<product tag="fxSingleLeg" assetClass="ForeignExchange" productType="FX Forward"/>
		<product tag="fxSwap" assetClass="ForeignExchange" productType="FX Swap"/>
		<product tag="fxOption" assetClass="ForeignExchange" productType="FX Option"/>
	</xsl:variable>

	<xsl:variable name="product.info" select="common:node-set($product.info.tf)"/>

	<xsl:template match="node()" mode="conv-info" priority="-1">
		<xsl:copy-of select="."/>
	</xsl:template>	


	<xsl:template match="*:swaption" mode="ir.swaption.type">
		<xsl:variable name="option.buyer" select="*:buyerPartyReference/@href"/>
		<xsl:variable name="swap.fixed.leg" select="*:swap/*:swapStream[.//*:fixedRateSchedule]"/>
		<xsl:variable name="swap.buyer" select="$swap.fixed.leg/*:payerReference/@href"/>
		<xsl:element name="optionType" namespace="{$ns}">
			<xsl:choose>
				<xsl:when test="$option.buyer = $swap.buyer">Payer</xsl:when>
				<xsl:otherwise>Receiver</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="*" mode="conv-info">
		<xsl:param name="product" />
		<xsl:apply-templates select="." mode="generate-and-convert">
			<xsl:with-param name="product" select="$product"/>
		</xsl:apply-templates>
	</xsl:template>	

	<xsl:template match="*:optionalEarlyTermination/*:europeanExercise" mode="conv-info"/>
	<xsl:template match="*:optionalEarlyTermination/*:bermudaExercise" mode="conv-info"/>
	<xsl:template match="*:optionalEarlyTermination/*:americanExercise" mode="conv-info"/>

	<xsl:template match="*" mode="generate-and-convert">
		<xsl:param name="product" />
		<xsl:variable name="tag" select="local-name(.)"/>
		<xsl:variable name="skip" select="$skipped.tags//*[.= $tag and (not(@product) or @product=$product)]"/>
		<xsl:if test="$skip/@fail = 'true'">
			<xsl:message terminate="yes">Contains customizations (<xsl:value-of select="$tag"/>), skipped</xsl:message>
		</xsl:if>
		<!--
		<xsl:message>first skipped is  <xsl:value-of select="$skipped.tags//*[1]"/></xsl:message>
		-->
		<xsl:if test="not($skip)">
			<xsl:element name="{$tag}" namespace="{$ns}">
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates mode="additional" select="."/>
				<xsl:apply-templates mode="conv-info" >
					<xsl:with-param name="product" select="$product"/>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:if>
	</xsl:template>	

	<xsl:template match="*:swaption/*:premium" mode="conv-info">
		<xsl:param name="product" />
		<xsl:apply-templates select="." mode="generate-and-convert">
			<xsl:with-param name="product" select="$product"/>
		</xsl:apply-templates>
		<xsl:apply-templates mode="ir.swaption.type" select=".."/>
	</xsl:template>	

	<xsl:template match="*:quantity[local-name(..) != 'totalPhysicalQuantity' and local-name(../../..) != 'oilPhysicalLeg']" mode="conv-info"/>

	<xsl:template match="*:fixedAmountCalculation/*:calculationAmount" mode="conv-info"/>

	<xsl:template match="*:pricingDates/*:pricingDates" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:pricingDates" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:calculationPeriods" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:americanExercise/*:frequency" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:americanExercise/*:relativeCommencementDates" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:americanExercise/*:relativeExpirationDates" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:europeanExercise/*:expirationDate" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:europeanExercise/*:relativeExpirationDates" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:commoditySwap" mode="conv-info"/>
	<xsl:template match="*:commodityOption/*:commodityForward" mode="conv-info"/>
	<xsl:template match="*:commodityPhysicalExercise/*:automaticExercise" mode="conv-info"/>
	<xsl:template match="*:commodityPhysicalExercise/*:writtenConfirmation" mode="conv-info"/>
	<xsl:template match="*:commodityPhysicalExercise/*:writtenConfirmation" mode="conv-info"/>


	<xsl:template match="*:commodity/*:unit" mode="conv-info"/>
	<xsl:template match="*:commodity/*:currency" mode="conv-info"/>
	<xsl:template match="*:commodity/*:exchangeId" mode="conv-info"/>
	<xsl:template match="*:commodity/*:publication" mode="conv-info"/>
	<xsl:template match="*:commodity/*:multiplier" mode="conv-info"/>

	<xsl:template match="*:deliveryPeriods/*:periods/*:dateAdjustments" mode="conv-info"/>
	<xsl:template match="*:deliveryPeriods/*:periods/*:adjustedDate" mode="conv-info"/>
	<xsl:template match="*:fixedLeg/*:calculationDates/*:dateAdjustments" mode="conv-info"/>
	<xsl:template match="*:fixedLeg/*:calculationDates/*:adjustedDate" mode="conv-info"/>
	<xsl:template match="*:fixedLeg/*:calculationPeriods/*:dateAdjustments" mode="conv-info"/>
	<xsl:template match="*:fixedLeg/*:calculationPeriods/*:adjustedDate" mode="conv-info"/>

	<xsl:template match="*:floatingLeg/*:calculationDates/*:dateAdjustments" mode="conv-info"/>
	<xsl:template match="*:floatingLeg/*:calculationDates/*:adjustedDate" mode="conv-info"/>
	<xsl:template match="*:floatingLeg/*:calculationPeriods/*:dateAdjustments" mode="conv-info"/>
	<xsl:template match="*:floatingLeg/*:calculationPeriods/*:adjustedDate" mode="conv-info"/>

	<xsl:template match="*:floatingLeg/*:quantityReference|*:fixedLeg/*:quantityReference" mode="conv-info">
		<notionalQuantity><quantityUnit>BBL</quantityUnit></notionalQuantity>
		<totalNotionalQuantity>10000</totalNotionalQuantity>
	</xsl:template>

	<xsl:template match="*:commodityOption/*:commoditySwap/*:effectiveDate" mode="conv-info">
		<xsl:param name="product" />
		<xsl:element name="effectiveDate" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="additional" select="."/>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="$product"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>	

	<!-- gas overrides -->
	<xsl:template match="*:gasPhysicalLeg/*:deliveryPeriods" mode="conv-info"/>

	<!-- oil overrides -->
	<xsl:template match="*:oilPhysicalLeg/*:deliveryPeriods" mode="conv-info"/>

	<!-- power overrides -->
	<xsl:template match="*:electricityPhysicalLeg/*:deliveryPeriods" mode="conv-info"/>
	<xsl:template match="*:settlementPeriods[local-name(..) != 'electricityPhysicalLeg']" mode="conv-info"/>
	<xsl:template match="*:deliveryQuantity[not(*)]" mode="conv-info"/>

	<xsl:template match="*:electricityPhysicalLeg/*:deliveryConditions" mode="conv-info">
		<xsl:param name="product" />
		<xsl:if test="not(entryPoint) or not(withdrawalPoint)">
			<xsl:message terminate="yes">Failed, no entry or withdrawal point</xsl:message>
		</xsl:if>
		<xsl:element name="deliveryConditions" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="additional" select="."/>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="$product"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="*:electricityPhysicalLeg/*:deliveryQuantity[not(*:totalQuantity)]/*:physicalQuantity" mode="conv-info">
		<xsl:param name="product" />
		<xsl:element name="totalPhysicalQuantity" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:element name="quantityUnit" namespace="{$ns}"><xsl:value-of select="*:quantityUnit"/></xsl:element>
			<xsl:element name="quantity" namespace="{$ns}">60000.0</xsl:element>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="*:firm|*:nonFirm|*:systemFirm|*:unitFirm" mode="conv-info">
		<xsl:variable name="tag" select="local-name(.)"/>
		<xsl:element name="{$tag}" namespace="{$ns}"/>
	</xsl:template>	

	<!-- for period = 1T swaps, copy period qty to total qty if total qty is missing -->

	<xsl:template match="*:oilPhysicalLeg[*:deliveryPeriods/*:periodsSchedule/*:period='T']/*:deliveryQuantity[not(*:totalQuantity)]/*:physicalQuantity" mode="conv-info">
		<xsl:param name="product" />
		<xsl:element name="totalPhysicalQuantity" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="additional" select="."/>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="$product"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>	

	<!-- coal overrides -->
	<xsl:template match="*:coalPhysicalLeg/*:deliveryPeriods" mode="conv-info"/>


	<xsl:template match="*:coalPhysicalLeg/*:deliveryConditions|*:coalPhysicalLeg/*:deliveryQuantity" mode="conv-info">
		<xsl:param name="product" />
		<xsl:variable name="tag" select="local-name(.)"/>
		<xsl:element name="{$tag}" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="additional" select="."/>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="$product"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="*:coalPhysicalLeg[*:deliveryPeriods/*:periodsSchedule/*:period='T']/*:deliveryQuantity[not(*:totalQuantity)]/*:physicalQuantity" mode="conv-info">
		<xsl:param name="product" />
		<xsl:element name="totalPhysicalQuantity" namespace="{$ns}">
			<xsl:element name="quantityUnit" namespace="{$ns}"><xsl:value-of select="*:quantityUnit"/></xsl:element>
			<xsl:element name="quantity" namespace="{$ns}"><xsl:value-of select="*:quantity"/></xsl:element>
		</xsl:element>
	</xsl:template>	

	<!-- bullion overrides -->

	<xsl:template match="*:bullionPhysicalLeg[not(*:totalQuantity)]/*:physicalQuantity" mode="conv-info">
		<xsl:param name="product" />
		<xsl:element name="totalPhysicalQuantity" namespace="{$ns}">
			<xsl:copy-of select="@*"/>
			<xsl:element name="quantityUnit" namespace="{$ns}"><xsl:value-of select="*:quantityUnit"/></xsl:element>
			<xsl:element name="quantity" namespace="{$ns}"><xsl:value-of select="*:quantity"/></xsl:element>
		</xsl:element>
	</xsl:template>	

	<!-- generic logic -->

	<xsl:template match="*" mode="convert-product" priority="-1">
		<xsl:apply-templates mode="validate" select="."/>
		<xsl:apply-templates mode="validate2" select="."/>
		<xsl:variable name="tag" select="local-name(.)"/>
		<xsl:variable name="prod" select="$product.info//*[@tag=$tag]"/>
		<xsl:choose>
			<xsl:when test="$prod">
				<xsl:variable name="p"> 
					<xsl:choose>
						<xsl:when test="$prod/@map">
							<xsl:value-of select="$prod/@map"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$tag"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="{$p}" namespace="{$ns}">
					<primaryAssetClass>
						<xsl:apply-templates mode="asset-class" select="."/>
					</primaryAssetClass>
					<productType>
						<xsl:apply-templates mode="product-type" select="."/>
					</productType>
					<xsl:apply-templates mode="conv-info" >
						<xsl:with-param name="product" select="$p"/>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag}" namespace="{$ns}">
					<primaryAssetClass>
						<xsl:apply-templates mode="asset-class" select="."/>
					</primaryAssetClass>
					<productType>
						<xsl:apply-templates mode="product-type" select="."/>
					</productType>
					<xsl:apply-templates mode="conv-info" >
						<xsl:with-param name="product" select="$tag"/>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	



	<xsl:template match="*" mode="additional" priority="-1"/>

	<xsl:template match="*:commodityOption/*:commoditySwap/*:gasPhysicalLeg/*:deliveryQuantity/*:physicalQuantity" mode="conv-info"/>

	<xsl:template match="*:commodityOption/*:commoditySwap/*:gasPhysicalLeg/*:deliveryPeriods" mode="additional" >
	       	<xsl:if test="not(*:supplyStartTime)">
			<xsl:element name="supplyStartTime" namespace="{$ns}">
				<xsl:element name="hourMinuteTime" namespace="{$ns}">00:00:00</xsl:element>
				<xsl:element name="location" namespace="{$ns}">Europe/Amsterdam</xsl:element>
			</xsl:element>
		</xsl:if>
	       	<xsl:if test="not(*:supplyEndTime)">
			<xsl:element name="supplyEndTime" namespace="{$ns}">
				<xsl:element name="hourMinuteTime" namespace="{$ns}">23:00:00</xsl:element>
				<xsl:element name="location" namespace="{$ns}">Europe/Amsterdam</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*:commodityOption/*:commoditySwap[not(*:productType) or not(*:primaryAssetClass)]" mode="additional" >
		<xsl:if test="not(*:primaryAssetClass)">
			<xsl:element name="primaryAssetClass" namespace="{$ns}">Commodities</xsl:element>
		</xsl:if>
	       	<xsl:if test="not(*:productType)">
			<xsl:element name="productType" namespace="{$ns}">CommoditySwap</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*:commodityOption/*:premium[not(*:premiumPerUnit)]" mode="conv-info" >
		<premium>
			<xsl:apply-templates select="*" mode="conv-info"/>
			<premiumPerUnit>
				<xsl:apply-templates mode="conv-info" select="*:paymentAmount/*:currency"/>
				<xsl:if test="not(*:paymentAmount/*:currency)">
					<currency>USD</currency>
				</xsl:if>
				<amount>1.23</amount>
			</premiumPerUnit>
		</premium>
	</xsl:template>

	<xsl:template match="*:bondOption/*:optionType" mode="conv-info" >
		<xsl:apply-templates select="." mode="generate-and-convert">
			<xsl:with-param name="product" select="'bondOption'"/>
		</xsl:apply-templates>
		<xsl:if test="not(../*:premium)">
			<premium>
				<paymentAmount>
					<currency>
						<xsl:value-of select="*:entitlementCurrency"/>
					</currency>
					<amount>0</amount>
				</paymentAmount>
			</premium>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="product-type" priority="-1">
		<xsl:message terminate="yes"><xsl:value-of select="local-name(.)"/> not supported, stopping</xsl:message>
	</xsl:template>	

	<xsl:template match="*" mode="asset-class" priority="-2">
		<xsl:message terminate="yes"><xsl:value-of select="local-name(.)"/> not supported, stopping</xsl:message>
	</xsl:template>	

	<xsl:template match="*[.//*:assetClass]" mode="asset-class" priority="-1"><xsl:value-of select=".//*:assetClass"/></xsl:template>
	<xsl:template match="*[.//*:assetClass='InterestRates']" mode="asset-class" priority="0">InterestRate</xsl:template>
	<xsl:template match="*[.//*:assetClass='Credits']" mode="asset-class" priority="0">Credit</xsl:template>
	<xsl:template match="*[.//*:assetClass='Equities']" mode="asset-class" priority="0">Equity</xsl:template>
	<xsl:template match="*[.//*:assetClass='Commodities']" mode="asset-class" priority="0">Commodity</xsl:template>
	<xsl:template match="*[.//*:assetClass='InterestRates']" mode="asset-class" priority="0">InterestRate</xsl:template>
	<xsl:template match="*[.//*:assetClass='FX']" mode="asset-class" priority="0">ForeignExchange</xsl:template>

	<xsl:template match="*:commoditySwap" mode="asset-class">Commodity</xsl:template>	
	<xsl:template match="*:commodityOption" mode="asset-class">Commodity</xsl:template>	
	<xsl:template match="*:commodityForward" mode="asset-class">Commodity</xsl:template>	
	<xsl:template match="*:swap" mode="asset-class">InterestRate</xsl:template>	
	<xsl:template match="*:fra" mode="asset-class">InterestRate</xsl:template>	
	<xsl:template match="*:swaption" mode="asset-class">InterestRate</xsl:template>	
	<xsl:template match="*:equityOptionTransactionSupplement" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:equityOption" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:equityForward" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:equitySwap|*:equitySwapTransactionSupplement" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:returnSwap" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:varianceSwap|*:varianceSwapTransactionSupplement" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:correlationSwap|*:correlationSwapTransactionSupplement" mode="asset-class">Equity</xsl:template>	
	<xsl:template match="*:dividendSwap|*:dividendSwapTransactionSupplement" mode="asset-class">Equity</xsl:template>	


	<xsl:template match="*:creditDefaultSwap" mode="asset-class">Credit</xsl:template>	
	<xsl:template match="*:creditDefaultSwapOption" mode="asset-class">Credit</xsl:template>	
	<xsl:template match="*:capFloor" mode="asset-class">InterestRate</xsl:template>
	<xsl:template match="*:bondOption" mode="asset-class" priority="0">InterestRate</xsl:template>	

	<xsl:template match="*:fxSingleLeg" mode="asset-class" priority="0">ForeignExchange</xsl:template>	
	<xsl:template match="*:fxSwap" mode="asset-class" priority="0">ForeignExchange</xsl:template>	
	<xsl:template match="*:fxOption" mode="asset-class" priority="0">ForeignExchange</xsl:template>	



	<xsl:template match="*:bondOption" mode="product-type" priority="0">InterestRate:Options:Debtoptions</xsl:template>	
	<xsl:template match="*:bondOption[.//*:convertibleBond]" mode="product-type" priority="10">
		<xsl:message terminate="yes">Convertible bond options not supported, stopping</xsl:message>
	</xsl:template>	

	<xsl:template match="*:creditDefaultSwap" mode="product-type" priority="0">Credit:SingleName:Corporate:StandardNorthAmericanCorporate</xsl:template>	

	<xsl:template match="*:creditDefaultSwap[..//*:documentation/*:contractualMatrix/*:matrixTerm]" mode="product-type" priority="1">Credit:SingleName:Corporate:<xsl:value-of select="..//*:documentation/*:contractualMatrix/*:matrixTerm"/></xsl:template>	

	<xsl:template match="*:creditDefaultSwap[.//*:indexReferenceInformation/*:tranche]" mode="product-type" priority="10">Credit:IndexTranche:Lcdx:Lcdxtranche</xsl:template>	
	<xsl:template match="*:creditDefaultSwap[.//*:indexReferenceInformation]" mode="product-type" priority="9">Credit:Index:Cdx:Cdx.Hy</xsl:template>	
	<xsl:template match="*:creditDefaultSwap[.//*:loan]" mode="product-type" priority="10">Credit:SingleName:Loan:Elcds</xsl:template>	
	<xsl:template match="*:creditDefaultSwap[.//*:mortgage]" mode="product-type" priority="10">Credit:SingleName:Abs:Cmbs</xsl:template>	

	<xsl:template match="*:creditDefaultSwap[.//*:basketReferenceInformation]" mode="product-type" priority="9">
		<xsl:message terminate="yes">CDS on baskets not supported, stopping</xsl:message>
	</xsl:template>	

	<xsl:template match="*:capFloor" mode="product-type" priority="10">InterestRate:Cap-Floor</xsl:template>

	<xsl:template match="*:swap[(.//*:notionalStepSchedule/*:currency)[1] != (.//*:notionalStepSchedule/*:currency)[2]]" mode="product-type" priority="12">InterestRate:CrossCurrency:Fixed-Float</xsl:template>
	<xsl:template match="*:swap[(.//*:notionalStepSchedule/*:currency)[1] != (.//*:notionalStepSchedule/*:currency)[2] and count(.//*:fixedRateSchedule)=2]" mode="product-type" priority="14">InterestRate:CrossCurrency:Fixed-Fixed</xsl:template>
	<xsl:template match="*:swap[(.//*:notionalStepSchedule/*:currency)[1] != (.//*:notionalStepSchedule/*:currency)[2] and count(.//*:floatingRateCalculation)=2]" mode="product-type" priority="14">InterestRate:CrossCurrency:Basis</xsl:template>

	<xsl:template match="*:swap[count(.//*:fixedRateSchedule)=2]" mode="product-type" priority="2">InterestRate:Irswap:Fixed-Fixed</xsl:template>
	<xsl:template match="*:swap[count(.//*:floatingRateCalculation)=2]" mode="product-type" priority="11">InterestRate:Irswap:Basis</xsl:template>
	<xsl:template match="*:swap" mode="product-type" priority="2">InterestRate:Irswap:Fixed-Float</xsl:template>
	<xsl:template match="*:swap[count(.//*:fixedRateSchedule)=2]" mode="product-type" priority="10">InterestRate:Irswap:Fixed-Fixed</xsl:template>
	<xsl:template match="*:swap[count(.//*:floatingRateCalculation)=2]" mode="product-type" priority="10">InterestRate:Irswap:Basis</xsl:template>
	<xsl:template match="*:swap[.//*:resetDates/period='T']" mode="product-type" priority="10">InterestRate:Irswap:Ois</xsl:template>

	<xsl:template match="*:returnSwap" mode="product-type" priority="10">Equity:Swap:Equityswap:Single-name</xsl:template>
	<xsl:template match="*:equitySwap|*:equitySwapTransactionSupplement" mode="product-type">Equity:Swap:Equityswap:Single-name</xsl:template>

	<xsl:template match="*:equityOption" mode="product-type" priority="10">Equity:Option:Vanilla:Single-name</xsl:template>
	<xsl:template match="*:equityOptionTransactionSupplement" mode="product-type" priority="10">Equity:Option:Vanilla:Single-name</xsl:template>
	<xsl:template match="*:equityForward" mode="product-type" priority="10">Equity:Forward:Vanilla:Single-name</xsl:template>
	<xsl:template match="*:varianceSwap|*:varianceSwapTransactionSupplement" mode="product-type" priority="10">Equity:Option:Variance:Single-Name</xsl:template>
	<xsl:template match="*:dividendSwap|*:dividendSwapTransactionSupplement" mode="product-type" priority="10">Equity:Swap:Dividend:Single-Name</xsl:template>

	<xsl:template match="*:commoditySwap" mode="product-type" priority="10">Commodity:Energy:Gas:Swap:Cash</xsl:template>
	<xsl:template match="*:commodityOption" mode="product-type" priority="10">Commodity:Energy:Gas:Option:Cash</xsl:template>
	<xsl:template match="*:commoditySwap//*:instrumentId[contains(., 'ELEC')]" mode="product-type" priority="12">Commodity:Energy:Elec:Swap:Cash</xsl:template>
	<xsl:template match="*:commoditySwap//*:instrumentId[contains(., 'POWER')]" mode="product-type" priority="13">Commodity:Energy:Elec:Swap:Cash</xsl:template>
	<xsl:template match="*:commoditySwap[.//*:gasPhysicalLeg]" mode="product-type" priority="12">Commodity:Energy:Gas:Swap:Physical</xsl:template>
	<xsl:template match="*:commoditySwap[.//*:oilPhysicalLeg]" mode="product-type" priority="12">Commodity:Energy:Oil:Swap:Physical</xsl:template>
	<xsl:template match="*:commoditySwap[.//*:electricityPhysicalLeg]" mode="product-type" priority="12">Commodity:Energy:Elec:Swap:Physical</xsl:template>
	<xsl:template match="*:commoditySwap[.//*:coalPhysicalLeg]" mode="product-type" priority="12">Commodity:Energy:Coal:Swap:Physical</xsl:template>

	<xsl:template match="*:fxSingleLeg" mode="product-type" priority="10">ForeignExchange:Forward</xsl:template>	
	<xsl:template match="*:fxSingleLeg[.//*:nonDeliverableSettlement]" mode="product-type" priority="11">ForeignExchange:Ndf</xsl:template>	
	<xsl:template match="*:fxOption" mode="product-type" priority="10">ForeignExchange:VanillaOptions</xsl:template>	
	<xsl:template match="*:fxOption[.//*:barrier]" mode="product-type" priority="11">ForeignExchange:SimpleExotics:Barrier</xsl:template>	
	<xsl:template match="*:fxOption[.//*:asian]" mode="product-type" priority="11">
		<xsl:message terminate="yes">Asian FX option not supported, stopping</xsl:message>
	</xsl:template>	
	<xsl:template match="*:fxDigitalOption" mode="product-type" priority="10">ForeignExchange:SimpleExotics:Binary-Digitals</xsl:template>	
	<xsl:template match="*:fxOption[.//*:cashSettlement]" mode="product-type" priority="11">ForeignExchange:Ndo</xsl:template>	

	<xsl:template match="*:genericProduct" mode="product-type" priority="10"><xsl:value-of select="../*:assetClass"/>:Exotic</xsl:template>


	<xsl:template match="*:swaption" mode="convert-product" priority="10">
		<swaption>
			<primaryAssetClass>InterestRate</primaryAssetClass>
			<productType>InterestRate:Options:Swaption</productType>
			<xsl:if test="not(*:premium)">
				<premium>
					<paymentAmount>
						<currency>
							<xsl:value-of select="*:notionalAmount/*:currency"/>
						</currency>
						<amount>0</amount>
					</paymentAmount>
				</premium>
				<xsl:apply-templates mode="ir.swaption.type" select="."/>
			</xsl:if>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="'swaption'"/>
			</xsl:apply-templates>
		</swaption>
	</xsl:template>	

	<xsl:template match="*:equityOption" mode="convert-product" priority="10">
		<equityOptionTransactionSupplement>
			<primaryAssetClass>Equity</primaryAssetClass>
			<productType>Equity:Options:Vanilla:Single-name</productType>
			<xsl:apply-templates mode="conv-info" >
				<xsl:with-param name="product" select="'equityOptionTransactionSupplement'"/>
			</xsl:apply-templates>
		</equityOptionTransactionSupplement>
	</xsl:template>	

	<xsl:variable name="validation.rules.tf">
		<rule product="creditDefaultSwap">*:generalTerms/*:effectiveDate/*:unadjustedDate</rule>
	</xsl:variable>
	<xsl:variable name="validation.rules" select="common:node-set($validation.rules.tf)/*"/>

	<xsl:template match="*" mode="validate" >
		<xsl:param name="product" select="local-name(.)"/>
		<xsl:variable name="this" select="."/>
		<xsl:variable name="rules" select="$validation.rules[@product=$product]"/>
		<xsl:for-each select="$rules">
			<xsl:variable name="rule" select="concat('./',.)"/>
			<xsl:for-each select="$this">
				<xsl:variable name="result" select="saxon:evaluate($rule)"/>
				<xsl:if test="not(boolean($result))">
					<xsl:message terminate="yes">For rule = <xsl:value-of select="$rule"/>, result is <xsl:value-of select="$result"/></xsl:message>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>	

	<xsl:template match="*" mode="validate2" />

	<xsl:template match="*:commoditySwap[*:gasPhysicalLeg]" mode="validate2" >
		<xsl:if test="not(.//*:supplyStartTime)">
			<xsl:message terminate="yes">Physical Gas Swap Missing supply start time, skipped</xsl:message>
		</xsl:if>
	</xsl:template>	

	<xsl:template match="*:commoditySwap[*:electricityPhysicalLeg]" mode="validate2" >
		<xsl:if test="not(.//*:deliveryConditions/*:deliveryType)">
			<xsl:message terminate="yes">Physical Electricity Swap Missing delivery type, skipped</xsl:message>
		</xsl:if>
	</xsl:template>	

	<xsl:template match="*:productType|*:assetClass" mode="conv-info" priority="5"/>

	<xsl:template match="*:optionEntitlement" mode="conv-info" />

	<xsl:template match="*:dividendValuationDates/*:adjustableDates|*:interestLegPaymentDates/*:adjustableDates" mode="conv-info" priority="5">
		<xsl:message terminate="yes">Contains unsupported features, skipped</xsl:message>
	</xsl:template>



	<xsl:template match="*:party[1]/*:partyId" mode="conv-info">
		<partyId partyIdScheme="http://www.fpml.org/coding-scheme/external/iso17442">QKJ01YU6XEBG546Z2Y67</partyId>
	</xsl:template>

	<xsl:template match="*:partyTradeIdentifier[1]" mode="conv-info">
		<partyTradeIdentifier>
			<issuer issuerIdScheme="http://www.fpml.org/coding-scheme/external/iso17442">VTOUP9FCHUXIINML4787</issuer>
			<tradeId tradeIdScheme="http://www.fpml.org/coding-scheme/external/unique-transaction-identifier">12345678901234567890123456789012</tradeId>
		</partyTradeIdentifier>
	</xsl:template>
	<xsl:template match="*:partyTradeIdentifier[2]" mode="conv-info"/>

	<!-- issues -->
	<!-- 
	correlation swaps have no product type
	more credit derivative examples don't have enough info for them to be classified
	not clear how to classify options on convertible bonds
	asian FX option unsupported in taxonomy
	-->
</xsl:stylesheet>
