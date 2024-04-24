<?xml version="1.0" ?>
<!-- Author: Steven Lord -->
<!--Modified by Marc Gratacos to generate valid xhtml-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
         version="1.0">
        <xsl:output method="xml" indent="yes"/>
       <!-- <xsl:output method="xml" indent="yes" encoding="UTF-8"/>-->
        <!-- Some global variables -->
        <xsl:strip-space elements="*"/>
        <xsl:variable name="title">SCHEMES</xsl:variable>
        <xsl:variable name="schemeDefinitions">FpML SCHEME DEFINITIONS</xsl:variable>
        <xsl:variable name="extschemeDefinitions">EXTERNAL SCHEME DEFINITIONS</xsl:variable>
        
        <xsl:template match="schemeDefinitions">
                <schemeDefinitions>
                 
                                <xsl:variable name="schemeSectionNumber" select="count(section)+1"/>
                                <xsl:variable name="extschemeSectionNumber" select="count(section)+2"/>
                                              
                               
                                <xsl:for-each select="scheme">
                                 <xsl:if test="schemeValues">
                                        <!-- <xsl:sort select="@name"/> -->
                                        <xsl:apply-templates select="." mode="main">
                                                <xsl:with-param name="sectionNumber" select="$schemeSectionNumber"/>
                                                <xsl:with-param name="subSectionNumber" select="position()"/>
                                        </xsl:apply-templates>
                                 </xsl:if>                                       
                                </xsl:for-each>
                                <!--#### Create Header for External Schemes in Documentation (Maintain Subsection Number) ####-->
                          
                        
                       <!-- EXTERNAL SCHEMES SECTION HERE-->
                        
                        
                              <!--  <xsl:for-each select="scheme">
                                        <xsl:if test="count(schemeValues) &lt; 1">
                                               <!-\- <xsl:sort select="@name"/> -\->
                                                <xsl:apply-templates select="." mode="main">
                                                        <xsl:with-param name="sectionNumber" select="$extschemeSectionNumber"/>
                                                        <xsl:with-param name="subSectionNumber" select="position()"/>
                                                </xsl:apply-templates>
                                        </xsl:if>                                       
                                </xsl:for-each>-->
                                
                             
                </schemeDefinitions>
        </xsl:template>
        <xsl:template match="scheme" mode="main">
                <xsl:param name="sectionNumber"/>
                <xsl:param name="subSectionNumber"/>
                <xsl:variable name="schemeName">
                        <xsl:value-of select="@name"/>
                </xsl:variable>
                <scheme uri="{@uri}" canonicalUri="{@canUri}" name="{concat(@name,'-',@version)}">
                       
              
              
                <!-- For the floating rate index scheme we otput the Style column to show OIS, etc. -->
                <xsl:if test="@canUri='http://www.fpml.org/coding-scheme/floating-rate-index'">
                        <xsl:apply-templates select="schemeValues" />
                </xsl:if>
                <xsl:if test="@canUri!='http://www.fpml.org/coding-scheme/floating-rate-index'">
                        <xsl:apply-templates select="schemeValues"/>
                </xsl:if>
                <!--<xsl:apply-templates select="schemeValues"/>-->
                <xsl:if test="alternateURI">
                        <h4>Alternate Scheme Identification:</h4>
                        <xsl:for-each select="alternateURI">
                                 <xsl:apply-templates select="."/>                                
                        </xsl:for-each>
                </xsl:if>
                </scheme>
                <!--<br/>-->
        </xsl:template>
        
        <xsl:template match="alternateURI">
                <ul>
                <li><strong>URI:</strong><xsl:value-of select="@uri"/></li>  
                        
                        <xsl:if test="@url">
                                <li><strong>Location URL:</strong><a href="{@url}"><xsl:value-of select="@url"/></a></li>
                        </xsl:if>
                
                <xsl:if test="schemeDescription">
                       <xsl:apply-templates select="schemeDescription" mode="alternate"/>
                </xsl:if>
                
                <xsl:apply-templates select="schemeValues"/>
                </ul>
        </xsl:template>
        <xsl:template match="schemeValues">
                <xsl:if test="schemeValue">
                        <schemeValues>
                                

                                <xsl:for-each select="schemeValue">
                                        <xsl:sort select="@name"/>
                                        <schemeValue schemeValueSource="{@schemeValueSource}" name="{@name}">
                                                <xsl:if test="paragraph/text()">
                                                        
                                                        <paragraph><xsl:value-of select="substring-after(substring-after(codeDescription/paragraph, '&quot;'),'&quot;')"/> 
                                                        
                                               
                                                        
                                                        
                                                                <xsl:for-each select="paragraph">
                                                                        
                                                                        <xsl:apply-templates/>
                                                                        
                                                                        
                                                                        
                                                                </xsl:for-each>                                                   
                                                                
                                                        
                                                        </paragraph>
                                                </xsl:if>
                                        </schemeValue>

                                </xsl:for-each>

                        </schemeValues>
                </xsl:if>
        </xsl:template>
</xsl:stylesheet>
