<?xml version="1.0" encoding="UTF-8"?>

<!--Script to add the version information to the schema and to example files -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://exslt.org/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:view="http://www.fpml.org/views" xmlns:abc="http://www.abc.com/master" xmlns:master="http://www.fpml.org/FpML-5/master" exclude-result-prefixes="common xsd xsi view">


	<!--
<xsl:import href="add-version.xsl"/>
	-->
	<xsl:import href="generate-extension-view.xsl"/>

	<xsl:param name="version" select="'5-0'"/>
	<xsl:param name="current.date" select="'Fri 05/20/2011'"/>
	<xsl:param name ="current.year" select="substring($current.date,11)"/>

	<xsl:template match="/">
		<xsl:comment>View is <xsl:value-of select="$view"/></xsl:comment>
		<xsl:comment>Version is <xsl:value-of select="$version"/></xsl:comment>
		<xsl:comment>NS is <xsl:value-of select="$FpML.ns"/></xsl:comment>
		<xsl:apply-templates select="." mode="go"/>
	</xsl:template>

	<xsl:template match="comment()" mode="go" priority="-2">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- update copyright notice -->
	<xsl:template match="comment()[contains(.,'Copyright (c) ')]" priority="2" mode="go">
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
	<xsl:template match="node()" mode="go" priority="-3">
		<xsl:apply-templates mode="go"/>
	</xsl:template>

	<xsl:template match="master:*" priority="-1" mode="go">
		<xsl:element name="{local-name(.)}" namespace="{$FpML.ns}">
			<!--
			<xsl:copy-of select="@fpmlVersion"/>
			-->
			<xsl:attribute name="fpmlVersion">
				<xsl:value-of select="$version"/>
			</xsl:attribute>
			<xsl:apply-templates mode="schema-loc" select="."/>
			<xsl:apply-templates mode="apply-view"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*:FpML|*:dataDocument|*[@fpmlVersion]" mode="go">
		<!--
		<xsl:call-template name="intro.comment"/>
		<xsl:variable name="ns-node">
			<xsl:element name="ns-element" namespace="{$FpML.ns}"/>
		</xsl:variable>
		-->
		<xsl:variable name="rootName">
			<xsl:apply-templates mode="root.elem.name" select="."/>
		</xsl:variable>
		<xsl:element name="{$rootName}" namespace="{$FpML.ns}">
			<!--
			<xsl:copy-of select="common:node-set($ns-node)/*/namespace::*[local-name()='']"/>
			-->
			<xsl:attribute name="fpmlVersion">
				<xsl:value-of select="$version"/>
			</xsl:attribute>
			<xsl:apply-templates mode="schema-loc" select="."/>
			<xsl:if test="not($rootName='dataDocument') and not(*:header) and $view != 'reporting'">
				<xsl:call-template name="msg.header"/>
			</xsl:if>
			<xsl:apply-templates mode="apply-view"/>
			<!--
			<xsl:copy-of select="*"/>
			-->
		</xsl:element>
	</xsl:template>

	<xsl:template name="msg.header">
		<xsl:element name="header" namespace="{$FpML.ns}">
			<xsl:element name="messageId" namespace="{$FpML.ns}">
				<xsl:attribute name="messageIdScheme">http://www.fpml.org/msg-id</xsl:attribute>
				<xsl:text>123</xsl:text>
			</xsl:element>
			<!--<xsl:element name="inReplyTo" namespace="{$FpML.ns}">120</xsl:element>-->
			<xsl:element name="sentBy" namespace="{$FpML.ns}">DEF</xsl:element>
			<xsl:element name="sendTo" namespace="{$FpML.ns}">ABC</xsl:element>
			<xsl:element name="creationTimestamp" namespace="{$FpML.ns}">2007-04-02T15:38:00-00:00</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="abc:*" mode="apply-view" priority="5">
		<xsl:element name="abc:{local-name(.)}" namespace="{$ABC.ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="apply-view"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*[contains(@xsi:schemaLocation, 'abc.com')]" mode="schema-loc">
		<xsl:attribute name="xsi:schemaLocation">
			<xsl:value-of select="$ABC.ns"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$prefix"/>
			<xsl:text>../example-extension-</xsl:text>
			<xsl:value-of select="$version"/>
			<xsl:text>.xsd </xsl:text>
			<xsl:value-of select="$FpML.ns"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$prefix"/>
			<xsl:text>../fpml-main-</xsl:text>
			<xsl:value-of select="$version"/>
			<xsl:text>.xsd</xsl:text>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*:FpML|master:*" mode="schema-loc">
		<xsl:attribute name="xsi:schemaLocation">
			<xsl:value-of select="$FpML.ns"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$prefix"/>
			<xsl:text>../fpml-main-</xsl:text>
			<xsl:value-of select="$version"/>
			<xsl:text>.xsd</xsl:text>
			<xsl:text> http://www.w3.org/2000/09/xmldsig# </xsl:text>
			<xsl:value-of select="$prefix"/>
			<xsl:text>../</xsl:text>
			<xsl:text>xmldsig-core-schema.xsd</xsl:text>
		</xsl:attribute>
	</xsl:template>

	<!--
	<xsl:template name="intro.comment">
		<xsl:choose>
			<xsl:when test="$view='pretrade'">
				<xsl:comment>Omit notional amounts, prices, adjustments, and other information not required for an RFQ</xsl:comment>
			</xsl:when>
			<xsl:when test="$view='reporting'">
				<xsl:comment>Omit some adjustments, details of procedures, and other information not required for a report</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Include all information required for a confirmation.</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->

	<xsl:template match="*" mode="root.elem.name" priority="-1">
		<xsl:value-of select="local-name(.)"/>
	</xsl:template>

	<xsl:template match="*:FpML" mode="root.elem.name">
		<xsl:variable name="msg.type" select="@xsi:type"/>
		<xsl:variable name="root.name">
			<xsl:call-template name="gen.root.name">
				<xsl:with-param name="message.type" select="$msg.type"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="cen" select="boolean(*:creditEventNotice)"/>
		<xsl:choose>
			<xsl:when test="($msg.type = 'CreditEventNotification' or $cen) and $view != 'reporting'">
				<xsl:message terminate="yes">Skipped CEN in view=<xsl:value-of select="$view"/></xsl:message>
			</xsl:when>
			<xsl:when test="$msg.type='DataDocument' and count(*:trade) &gt; 1">
				<xsl:if test="$view!='reporting'">
					<xsl:message terminate="yes">Skipped portfolio in view=<xsl:value-of select="$view"/></xsl:message>
				</xsl:if>
				<xsl:text>dataDocument</xsl:text>
			</xsl:when>
			<!--<xsl:when test="$view='confirmation' and not(contains($msg.type,'Confirm') or $msg.type='MessageRejected')">
				<xsl:value-of select="'requestTradeConfirmation'"/>
			</xsl:when>
			<xsl:when test="$view!='confirmation' and $msg.type='CreditEventNotification'">
				<xsl:message terminate="yes">Skipped CEN in view=<xsl:value-of select="$view"/></xsl:message>
			</xsl:when>
			<xsl:when test="$msg.type='MessageRejected'">
				<xsl:value-of select="'messageRejected'"/>
			</xsl:when>
			<xsl:when test="$view='pretrade'">
				<xsl:value-of select="'requestQuote'"/>
			</xsl:when>
			<xsl:when test="$view='confirmation'">
				<xsl:value-of select="$root.name"/>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Contract')">
				<xsl:value-of select="$root.name"/>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Increase')">
				<xsl:text>tradeIncreaseRequest</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'TerminationResponse')">
				<xsl:text>tradeTerminationResponse</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Termination')">
				<xsl:text>tradeTerminationRequest</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Novation')">
				<xsl:text>novationConsentRequest</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Amendment')">
				<xsl:text>tradeAmendmentRequest</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'Amendment')">
				<xsl:text>tradeAmendmentRequest</xsl:text>
			</xsl:when>
			-->
			<xsl:when test="$view='confirmation' and contains($msg.type, 'TradeCreated')">
				<xsl:text>tradeConfirmed</xsl:text>
			</xsl:when>
			<xsl:when test="$view='confirmation' and contains($msg.type, 'TradeCancelled')">
				<xsl:text>modifyTradeConfirmation</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'TradeCreated')">
				<xsl:text>tradeExecution</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'TradeCancelled')">
				<xsl:text>tradeExecutionCancelled</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'TradeAmended')">
				<xsl:text>tradeExecutionModified</xsl:text>
			</xsl:when>
			<xsl:when test="$view='reporting' and contains($msg.type, 'TradeConfirm')">
				<xsl:text>tradeExecution</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$root.name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- generate the root element name by turning the initial character of the type name to lower case and retaining the rest -->
	<xsl:template name="gen.root.name">
		<xsl:param name="message.type"/>
		<xsl:variable name="first" select="substring($message.type, 1, 1)"/>
		<xsl:variable name="rest" select="substring($message.type, 2)"/>
		<xsl:value-of select="concat(lower-case($first), $rest)"/>
	</xsl:template>


	<!-- support routines -->

	<xsl:template match="node()" mode="apply-view">
		<!--
		<xsl:message>apply-view on <xsl:value-of select="local-name(.)"/></xsl:message>
		-->
		<xsl:apply-templates mode="do-apply" select="."/>
	</xsl:template>

	<!--
	<xsl:template match="*[@href and contains(local-name(), 'Party')]" mode="do-apply" priority="-1">
		<xsl:apply-templates mode="skip-in-pretrade" select="."/>
	</xsl:template>
	-->

	<xsl:template match="node()" mode="do-apply" priority="-5">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="*" mode="do-apply">
		<!--
		<xsl:message>Do apply, loc name=<xsl:value-of select="local-name(.)"/></xsl:message>
		-->
		<xsl:element name="{local-name(.)}" namespace="{$FpML.ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="apply-view"/>
		</xsl:element>
		<!--
		<xsl:message>End do apply, loc name=<xsl:value-of select="local-name(.)"/></xsl:message>
		-->
	</xsl:template>

	<xsl:template match="node()" mode="keep-in-view">
		<xsl:param name="pretrade" select="false()"/>
		<xsl:param name="confirmation" select="false()"/>
		<xsl:param name="reporting" select="false()"/>
		<!--
		<xsl:comment>Keep in view - view:<xsl:value-of select="$view"/>; reporting: <xsl:value-of select="boolean($reporting)"/>, loc name=<xsl:value-of select="local-name(.)"/></xsl:comment>
		-->
		<xsl:choose>
			<xsl:when test="$view='pretrade' and boolean($pretrade)">
				<xsl:apply-templates mode="do-apply" select="."/>
			</xsl:when>
			<xsl:when test="$view='confirmation' and boolean($confirmation)">
				<xsl:apply-templates mode="do-apply" select="."/>
			</xsl:when>
			<xsl:when test="$view='reporting' and boolean($reporting)">
				<xsl:apply-templates mode="do-apply" select="."/>
			</xsl:when>
			<xsl:otherwise>
				<!--
				<xsl:apply-templates mode="do-apply" select="."/>
				-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="keep-in-pretrade">
		<xsl:apply-templates mode="keep-in-view" select=".">
			<xsl:with-param name="pretrade" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node()" mode="keep-in-reporting">
		<xsl:apply-templates mode="keep-in-view" select=".">
			<xsl:with-param name="reporting" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node()" mode="keep-in-confirmation">
		<xsl:apply-templates mode="keep-in-view" select=".">
			<xsl:with-param name="confirmation" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node()" mode="keep-in-pretrade-and-reporting">
		<xsl:apply-templates mode="keep-in-view" select=".">
			<xsl:with-param name="pretrade" select="true()"/>
			<xsl:with-param name="reporting" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node()" mode="skip-in-pretrade">
		<!--
		<xsl:comment>Skip in pretrade, loc name=<xsl:value-of select="local-name(.)"/></xsl:comment>
		-->
		<xsl:apply-templates mode="keep-in-view" select=".">
			<xsl:with-param name="reporting" select="true()"/>
			<xsl:with-param name="confirmation" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	

	<!-- skip all processing, just copy in the right namespace -->
	<xsl:template match="*" mode="copy">
		<xsl:element name="{local-name(.)}" namespace="{$FpML.ns}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="copy"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="node()" mode="copy" priority="-1">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- matching *:return causes an Xpath syntax error, so we hack it -->
	<!--
	<xsl:template match="*[local-name(.)='return']" mode="apply-view">
		<xsl:apply-templates mode="skip-in-pretrade" select="."/>
	</xsl:template>
	-->
	

	<!-- version 4.0 -> 5.0 migration-->
	<xsl:template match="*:contractDate" mode="apply-view">
		<xsl:element name="tradeDate" namespace="{$FpML.ns}">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="text()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*:cashFlowType" mode="apply-view">
		<xsl:element name="cashflowType" namespace="{$FpML.ns}">
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="text()"/>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>
