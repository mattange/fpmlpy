<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <xsl:output method="xml" indent="yes"></xsl:output>
        <xsl:template match="/">
<xsl:comment> 
== Copyright (c) 2002-2014. All rights reserved. 
== Financial Products Markup Language is subject to the FpML public license. 
== A copy of this license is available at http://www.fpml.org/documents/license
</xsl:comment>
                <xsl:apply-templates select="xsd:schema"></xsl:apply-templates>
        </xsl:template>
        <xsl:template match="xsd:schema">
                <xsl:copy>
                        <xsl:apply-templates select="/xsd:schema/@*"></xsl:apply-templates>
                        <xsl:apply-templates select="xsd:import"></xsl:apply-templates>
                        <xsl:apply-templates select="xsd:include"></xsl:apply-templates>
                        <xsl:apply-templates select="xsd:redefine"></xsl:apply-templates>
                        <xsl:apply-templates select="xsd:annotation"></xsl:apply-templates>
                        <xsl:apply-templates select="xsd:simpleType">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:complexType">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:attribute">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:attributeGroup">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:element">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:group">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                        <xsl:apply-templates select="xsd:notation">
                                <xsl:sort select="@name"></xsl:sort>
                        </xsl:apply-templates>
                </xsl:copy>
        </xsl:template>
        <xsl:template match="xsd:import">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:include">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:redefine">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:annotation">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:simpleType">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:complexType">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:attribute">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:attributeGroup">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:element">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:group">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:notation">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
        <xsl:template match="xsd:schema/@*">
                <xsl:copy-of select="."></xsl:copy-of>
        </xsl:template>
</xsl:stylesheet>
