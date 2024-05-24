<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">
        <xsl:import href="sharedTemplates.xsl"/>
        <xsl:param name="date" select="'default value'"/>
        <xsl:param name="time" select="'default value'"/>
        <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
        <xsl:template match="documentBase">
                <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
                        <head>
                                <title>
                                        <xsl:value-of select="title"/>
					<xsl:call-template name="view.label"/>
                                </title>
                                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                                <link rel="stylesheet" type="text/css" href="fpml.css"/>
                        </head>
                        <body>
				<!--
                                <h1>
                                        <xsl:value-of select="title"/>
                                </h1>
				-->
				<xsl:apply-templates select="title"/>
                             
                                <h2 class="tocHeader">Table Of Contents</h2>
                                <p class="toc">
                                        <xsl:for-each select="section">
                                                <xsl:apply-templates select="." mode="toc">
                                                        <xsl:with-param name="level" select="$startLevel"/>
                                                        <xsl:with-param name="sectionName" select="position()"/>
                                                </xsl:apply-templates>
                                        </xsl:for-each>
                                </p>
                                <xsl:for-each select="section">
                                        <xsl:apply-templates select="." mode="main">
                                                <xsl:with-param name="level" select="$startLevel"/>
                                                <xsl:with-param name="sectionName" select="position()"/>
                                        </xsl:apply-templates>
                                </xsl:for-each>
                                  <p>Last Updated: <xsl:value-of select="concat($date, ' ', $time)"/>
                </p>
                                <p>
                                        <a href="http://validator.w3.org/">
                                                <img src="http://www.w3.org/Icons/valid-xhtml11" alt="Valid XHTML 1.1!" height="31" width="88"/>
                                        </a>
                                        <a href="http://jigsaw.w3.org/css-validator/">
                                                <img style="border:0;width:88px;height:31px" src="http://jigsaw.w3.org/css-validator/images/vcss" alt="Valid CSS!"/>
                                        </a>
                                </p>
                        </body>
                </html>
        </xsl:template>
</xsl:transform>
