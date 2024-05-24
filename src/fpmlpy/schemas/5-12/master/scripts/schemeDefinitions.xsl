<?xml version="1.0" ?>
<!-- Author: Steven Lord -->
<!--Modified by Marc Gratacos to generate valid xhtml-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:common="http://exslt.org/common" 
	xmlns:doc="http://www.fpml.org/coding-scheme/documentation"
        xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="common saxon doc">
        <xsl:import href="sharedTemplates.xsl"/>
        <xsl:import href="xl2scheme.xsl"/>
        <xsl:param name="date" select="'default value'"/>
        <xsl:param name="time" select="'default value'"/>
        <xsl:output method="xml" indent="yes" encoding="UTF-8"
                doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
        <!-- Some global variables -->
        <xsl:variable name="title">SCHEMES</xsl:variable>
        <xsl:variable name="schemeDefinitions">FpML SCHEME DEFINITIONS</xsl:variable>
        <xsl:variable name="extschemeDefinitions">EXTERNAL SCHEME DEFINITIONS</xsl:variable>
        

        <xsl:template match="*" >
		<xsl:apply-templates select="." mode="do-html"/>
	</xsl:template>

<!-- html -->
        <xsl:template match="schemeDefinitions" mode="do-html">
		<xsl:variable name="excel">
			<xsl:call-template name="construct-excel-schemes"/>
		</xsl:variable>
		<xsl:message>Excel schemes generated:  <xsl:value-of select="count(common:node-set($excel)/scheme[@source='excel'])"/></xsl:message>
		<xsl:variable name="content">
			<xsl:element xmlns="" name="schemeDefinitions">
				<xsl:copy-of select="version"/>
				<xsl:copy-of select="section"/>
				<xsl:copy-of select="scheme[not(@scope) or contains(@scope, $scope)]"/>
				<xsl:copy-of select="common:node-set($excel)/*"/>
			</xsl:element>
		</xsl:variable>
		<xsl:message>!!! Generate doc !!!</xsl:message>
		<xsl:apply-templates select="common:node-set($content)/*" mode="generate-doc"/>
		<!--
		<xsl:copy-of select="common:node-set($content)"/>
		-->
	</xsl:template>

        <xsl:template match="*" mode="generate-doc" priority="-1">
		<xsl:apply-templates select="*" mode="generate-doc"/>
	</xsl:template>

        <xsl:template match="schemeDefinitions" mode="generate-doc">
		<xsl:message>Got <xsl:value-of select="count(scheme)"/> schemes and <xsl:value-of select="count(scheme[@source='excel'])"/> excel schemes</xsl:message>
                <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
                        <head>
                                <title>
					<xsl:value-of select="version/@catalogTitle"/>
                                </title>
                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                                <meta http-equiv="Content-Style-Type" content="text/css"/>
                                <style type="text/css"> ul.simple {list-style-type: none}
                                        ul.bulleted {list-style-type: disc} ul.dashed
                                        {list-style-type: square} ol.arabic {list-style-type:
                                        decimal} ol.ualpha {list-style-type: upper-alpha} ol.uroman
                                        {list-style-type: upper-roman} ol.lalpha {list-style-type:
                                        lower-alpha} ol.lroman {list-style-type: lower-roman}
                                        ol.ftnote {list-style-type: decimal} p {display:inline}</style>
                                <link rel="stylesheet" type="text/css" href="fpml.css"/>
                        </head>
                        <body>
				<!--
                                <xsl:apply-templates select="version">
                                        <xsl:with-param name="builddate" select="$date"/>
                                        <xsl:with-param name="buildtime" select="$time"/>
                                </xsl:apply-templates>
				-->
				<h1><xsl:value-of select="version/@catalogTitle"/></h1>
				<h2 class="abstractHeader">Version: <xsl:value-of select="version/@catalogVersionNumber"/> </h2>
				<p> </p>
                                <xsl:variable name="schemeSectionNumber" select="count(section)+1"/>
                                <xsl:variable name="extschemeSectionNumber" select="count(section)+2"/>
                                <h2 class="tocHeader">Table Of Contents</h2>
                                
                                
                                <p class="toc">                                        
                                        
                                        <xsl:for-each select="section">
                                                <xsl:apply-templates select="." mode="toc">
                                                  <xsl:with-param name="level" select="$startLevel"/>
                                                  <xsl:with-param name="sectionName" select="position()"/>
                                                </xsl:apply-templates>
                                        </xsl:for-each>                                        
                                        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>                                        
                                        <!--#### Begin Table of Contents for FpML Schemes ####-->
                                        <b>
                                                <xsl:value-of select="$schemeSectionNumber"/>
                                                <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                                                <!--  <xsl:value-of select="$space"/> -->
                                                <a href="#s{$schemeSectionNumber}">
                                                  <xsl:value-of select="$schemeDefinitions"/>
                                                </a>
                                        </b>                                        
                                        <br/>
                                        <xsl:for-each select="scheme[count(schemeValues)&gt;0]"> 
                                                <xsl:sort select="@name"/> 
						<xsl:if test="@source='excel'"><xsl:message>Doing TOC for excel scheme <xsl:value-of select="@name"/></xsl:message></xsl:if>
                                                <xsl:apply-templates select="." mode="toc">
                                                  <xsl:with-param name="sectionNumber" select="$schemeSectionNumber"/>
                                                  <xsl:with-param name="subSectionNumber" select="position()"/>
                                                </xsl:apply-templates>
                                                <br/>
                                        </xsl:for-each>
                                        <!--#### Begin Table of Contents for External Schemes (Section FpML+1) ####-->
                                        <b>
                                                <xsl:value-of select="$extschemeSectionNumber"/>
                                                <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                                                <!--  <xsl:value-of select="$space"/> -->
                                                <a href="#s{$extschemeSectionNumber}">
                                                        <xsl:value-of select="$extschemeDefinitions"/>
                                                </a>
                                        </b>                                        
                                        <br/>
                                        
                                        <xsl:for-each select="scheme[count(schemeValues) &lt; 1]"> 
							<xsl:apply-templates select="." mode="toc">
								<xsl:with-param name="sectionNumber" select="$extschemeSectionNumber"/>
								<xsl:with-param name="subSectionNumber" select="position()"/>
							</xsl:apply-templates>
							<br/>
                                        </xsl:for-each>
                                        
                                </p>
                                <!--#### End of Table of Contents ####-->
                                
                                
                                <xsl:for-each select="section">
                                        <xsl:apply-templates select="." mode="main">
                                                <xsl:with-param name="level" select="$startLevel"/>
                                                <xsl:with-param name="sectionName" select="position()"/>
                                        </xsl:apply-templates>
                                </xsl:for-each>
                                
                                <!--#### Create Header for FpML Schemes in Documentation ####-->
                                
                                <h2>
                                        <xsl:value-of select="$schemeSectionNumber"/>
                                        <xsl:value-of select="$space"/>
                                        <a id="s{$schemeSectionNumber}">
                                                <xsl:value-of select="$schemeDefinitions"/>
                                        </a>
                                </h2>                                
                               
                                <xsl:for-each select="scheme[count(schemeValues) &gt; 0]">
					<xsl:sort select="@name"/> 
					<xsl:if test="@source='excel'"><xsl:message>Doing content for excel scheme <xsl:value-of select="@name"/></xsl:message></xsl:if>
                                        <!-- <xsl:sort select="@name"/> -->
                                        <xsl:apply-templates select="." mode="main">
                                                <xsl:with-param name="sectionNumber" select="$schemeSectionNumber"/>
                                                <xsl:with-param name="subSectionNumber" select="position()"/>
                                        </xsl:apply-templates>
                                </xsl:for-each>
                                <!--#### Create Header for External Schemes in Documentation (Maintain Subsection Number) ####-->
                                <h2>
                                        <xsl:value-of select="$extschemeSectionNumber"/>
                                        <xsl:value-of select="$space"/>
                                        <a id="s{$extschemeSectionNumber}">
                                                <xsl:value-of select="$extschemeDefinitions"/>
                                        </a>
                                       
                                </h2>                                
                                
                                <xsl:for-each select="scheme[count(schemeValues) &lt; 1]">
                                               <!-- <xsl:sort select="@name"/> -->
                                                <xsl:apply-templates select="." mode="main">
                                                        <xsl:with-param name="sectionNumber" select="$extschemeSectionNumber"/>
                                                        <xsl:with-param name="subSectionNumber" select="position()"/>
                                                </xsl:apply-templates>
                                </xsl:for-each>
                                
                                <!--#### End Headers ####-->
                                <p>
                                        <a href="http://validator.w3.org/">
                                                <img src="http://www.w3.org/Icons/valid-xhtml11"
                                                  alt="Valid XHTML 1.1!" height="31" width="88"/>
                                        </a>
                                        <a href="http://jigsaw.w3.org/css-validator/">
                                                <img style="border:0;width:88px;height:31px"
                                                  src="http://jigsaw.w3.org/css-validator/images/vcss" alt="Valid CSS!"/>
                                        </a>
                                </p>
                        </body>
                </html>
        </xsl:template>
        <xsl:template match="scheme" mode="main">
                <xsl:param name="sectionNumber"/>
                <xsl:param name="subSectionNumber"/>
                <xsl:variable name="schemeName">
                        <xsl:value-of select="@name"/>
                </xsl:variable>
                <h3>
                        <xsl:variable name="schemeSectionNumber">
                                <xsl:value-of select="concat($sectionNumber,'.',$subSectionNumber)"/>
                        </xsl:variable>
                        <xsl:value-of select="concat($sectionNumber,'.',$subSectionNumber)"/>
                        <xsl:value-of select="$space"/>
                        <a id="s{$schemeSectionNumber}">
                                <xsl:value-of select="@name"/>
                                
                               <!-- #### Display Version number in headers for FpML-Defined Schemes (currently unused) #### 
                                <xsl:if test="schemeValues">
                                <xsl:value-of select="@version"/>
                                </xsl:if>
                                -->
                        
                        </a>
                </h3>
                <h4>Scheme Definition:</h4>
                <p>
                        <xsl:value-of select="schemeDefinition"/>
                                
                </p>               
                <h4>Scheme Identification:</h4>
                <ul>
                        <li><strong>URI:</strong>&#160;<xsl:value-of select="@uri"/></li>
                        <xsl:if test="@url">
                        <li><strong>Location URL:</strong><a href="{@url}"><xsl:value-of select="@url"/></a></li>
                        </xsl:if>
                <xsl:if test="schemeValues">
                        <li><strong>Canonical URI:</strong>&#160;<xsl:value-of select="@canUri"/><br/></li>
                        <li><strong>Version:</strong>&#160;<xsl:value-of select="@version"/></li>  
			<xsl:if test="@publicationDate">
			        <li><strong>Publication Date:</strong>&#160;<xsl:value-of select="@publicationDate"/></li>  
			</xsl:if>
			<xsl:if test="@status">
			        <li><strong>Status:</strong>&#160;<xsl:value-of select="@status"/></li>  
			</xsl:if>
                        <!--<li><strong>Location URL:</strong>&#160;<a href="{@url}"><xsl:value-of select="@url"/></a></li>-->
                </xsl:if>
                
                <xsl:if test="schemeDescription">
                        <xsl:apply-templates select="schemeDescription"/>
                </xsl:if>
                </ul>
                <!-- For the floating rate index scheme we otput the Style column to show OIS, etc. -->
                <xsl:if test="@canUri='http://www.fpml.org/coding-scheme/floating-rate-index'">
                        <xsl:apply-templates select="schemeValues" mode="style"/>
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
                <br/>
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

	<xsl:template match="bullets" priority="100"/>

	<xsl:template match="bullets" mode="main" priority="10">
		<xsl:if test="not(@scope)  or contains(@scope, $scope)">
			<ul class="bulleted">
				<xsl:apply-templates mode="main"/>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="bullet"  mode="main" priority="10">
		<xsl:if test="not(@scope)  or contains(@scope, $scope)">
			<li>
				<xsl:apply-templates mode="main"/>
			</li>
		</xsl:if>
	</xsl:template>

        <xsl:template match="schemeValues">
                <xsl:if test="schemeValue">
                        <h4>Coding Scheme</h4>
                        <table class="table">
                                <tr>
                                        <th>CODE</th>
                                        <th>SOURCE</th>
                                        <th>DESCRIPTION</th>
                                </tr>
                                <xsl:for-each select="schemeValue">
                                        <xsl:sort select="@name"/>
                                        <tr>
                                                <td>
                                                  <xsl:value-of select="@name"/>
                                                </td>
                                                <td>
                                                  <xsl:value-of select="@schemeValueSource"/>
                                                </td>
                                                <td>
                                                  <br/>
                                                  <!--    
                                                  <xsl:for-each select="paragraph|bullets">
                                                  <xsl:apply-templates/>
                                                  <br/>
                                                  <br/>
                                                  </xsl:for-each>
                                                  -->
                                                        <xsl:value-of select="substring-after(substring-after(codeDescription/paragraph, '&quot;'),'&quot;')"/>
                                                              <!--  <xsl:apply-templates/>-->
                                                               <!-- <br/>-->
                                                     
                                                 <xsl:for-each select="codeDescription">
                                                                <xsl:apply-templates/>
                                                                <br/>
                                                                <br/>
                                                  </xsl:for-each>
                                                  <xsl:for-each select="paragraph">
                                                  <xsl:apply-templates/>
                                                  <br/>
                                                  <br/>
                                                  </xsl:for-each>                                                   
                                                  <xsl:for-each select="bullets">
                                                  <ul class="bulleted">
                                                  <xsl:apply-templates/>
                                                  </ul>
                                                  </xsl:for-each>
                                                  <xsl:for-each select="bullet">
                                                  <li>
                                                  <xsl:apply-templates/>
                                                  </li>
                                                  </xsl:for-each>
                                                </td>
                                        </tr>
                                </xsl:for-each>
                        </table>
                </xsl:if>
        </xsl:template>
        <xsl:template match="schemeValues" mode="style">
                <xsl:if test="schemeValue">
                        <h4>Coding Scheme</h4>
                        <table class="table">
                                <tr>
                                        <th>CODE</th>
                                        <th>SOURCE</th>
                                        <th>DESCRIPTION</th>
					<th>(CALCULATION) METHOD</th>
					<th>IN LOAN?</th>
                                </tr>
                                <xsl:for-each select="schemeValue">
                                        <xsl:sort select="@name"/>
                                        <tr>
                                                <td>
                                                        <xsl:value-of select="@name"/>
                                                </td>
                                                <td>
                                                        <xsl:value-of select="@schemeValueSource"/>
                                                </td>
                                                <td>
                                                        <br/>
                                                        <!--    
                                                  <xsl:for-each select="paragraph|bullets">
                                                  <xsl:apply-templates/>
                                                  <br/>
                                                  <br/>
                                                  </xsl:for-each>
                                                  -->
                                                        <xsl:value-of select="substring-after(substring-after(codeDescription/paragraph, '&quot;'),'&quot;')"/>
                                                        <!--  <xsl:apply-templates/>-->
                                                        <!-- <br/>-->
                                                        
                                                        <xsl:for-each select="codeDescription">
                                                                <xsl:apply-templates/>
                                                                <br/>
                                                                <br/>
                                                        </xsl:for-each>
                                                        <xsl:for-each select="paragraph">
                                                                <xsl:apply-templates/>
                                                                <br/>
                                                                <br/>
                                                        </xsl:for-each>                                                   
                                                        <xsl:for-each select="bullets">
                                                                <ul class="bulleted">
                                                                        <xsl:apply-templates/>
                                                                </ul>
                                                        </xsl:for-each>
                                                        <xsl:for-each select="bullet">
                                                                <li>
                                                                        <xsl:apply-templates/>
                                                                </li>
                                                        </xsl:for-each>
                                                </td>
                                                <td>
                                                        <xsl:value-of select="@style"/>
                                                </td>
                                                <td>
                                                        <xsl:value-of select="@inLoan"/>
                                                </td>
                                        </tr>
                                </xsl:for-each>
                        </table>
                </xsl:if>
        </xsl:template>
        <xsl:template match="schemeDescription">
                <!--<h4>Description:</h4>-->
                
              <a></a> <li><strong>Description:</strong><xsl:apply-templates/><br/><br/></li>
                
               
                
        </xsl:template>
        <!--mode alternate gives the output for the description for each Alternate URI element-->
        <xsl:template match="schemeDescription" mode="alternate">
                <!--<h5>Description:</h5>-->
              
                <li><strong>Description:</strong><xsl:apply-templates/><br/><br/></li>
             
        </xsl:template>
        <xsl:template match="scheme" mode="toc">
                <xsl:param name="sectionNumber"/>
                <xsl:param name="subSectionNumber"/>
                <xsl:variable name="schemeName">
                        <xsl:value-of select="@name"/>
                </xsl:variable>
                <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
                <b>
                        <xsl:value-of select="concat($sectionNumber,'.',$subSectionNumber)"/>
                        <xsl:variable name="schemeSectionNumber">
                                <xsl:value-of select="concat($sectionNumber,'.',$subSectionNumber)"/>
                        </xsl:variable>
                        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                        <!--     <xsl:value-of select="$space"/>  -->
                        <a href="#s{$schemeSectionNumber}">
                                <xsl:value-of select="@name"/>
                        </a>
                </b>
        </xsl:template>
</xsl:transform>
