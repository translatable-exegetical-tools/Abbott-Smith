<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.crosswire.org/2008/TEIOSIS/namespace" 
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" />

<xsl:template match="tei:TEI">
	<html>
		<head>
			<title>A MANUAL GREEK LEXICON OF THE NEW TESTAMENT</title>
		</head>
		<link rel="stylesheet" type="text/css" href="abbott-smith.css"/>
		<body>
			<xsl:apply-templates/>
		</body>
	</html>
</xsl:template>

<xsl:template match="tei:head[@type='heading1']">
	<h1><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="tei:head[@type='heading2']">
	<h2><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="tei:head[@type='heading3']">
	<h3><xsl:apply-templates/></h3>
</xsl:template>

<xsl:template match="tei:head[@type='heading4']">
	<h4><xsl:apply-templates/></h4>
</xsl:template>

<xsl:template match="tei:p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="tei:emph">
	<i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="tei:lb">
	<br/>
</xsl:template>

<xsl:template match="tei:table">
	<table><xsl:apply-templates/></table>
</xsl:template>

<xsl:template match="tei:row">
	<tr><xsl:apply-templates/></tr>
</xsl:template>

<xsl:template match="tei:cell">
	<td><xsl:apply-templates/></td>
</xsl:template>

<xsl:template match="note[@type='occurrencesNT']"/>

<xsl:template match="tei:note">
  <xsl:choose>
    <xsl:when test="@anchored='true'">
      <xsl:element name="sup">
	<xsl:text> [</xsl:text>
	  <xsl:element name="span">
	    <xsl:value-of select="@n"/>. <xsl:value-of select="."/>
	  </xsl:element>
        <xsl:text>] </xsl:text>
      </xsl:element>
    </xsl:when>
  <xsl:otherwise>
    <xsl:element name="sup">
	<xsl:text> [</xsl:text>
	  <xsl:element name="span">
	    <xsl:value-of select="."/>
	  </xsl:element>
        <xsl:text>] </xsl:text>
      </xsl:element>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:teiHeader"/>

<xsl:template match="tei:docTitle">
    <h1>
    	<xsl:apply-templates/>
    </h1>
</xsl:template>

<xsl:template match="tei:byline">
    <h2>
    	<xsl:apply-templates/>
    </h2>
</xsl:template>

<xsl:template match="tei:docImprint">
    <h3>
    	<xsl:apply-templates/>
    </h3>
</xsl:template>

<xsl:template match="tei:div[@type='dedication']">
    <h3>
    	<xsl:apply-templates/>
    </h3>
</xsl:template>

<xsl:template match="tei:pb">
	<span class="pagenum"><sub><xsl:text>[p. </xsl:text> <xsl:value-of select="./@n"/><xsl:text>] </xsl:text></sub></span>
</xsl:template>

<xsl:template match="tei:entry">
    <p>
    	<xsl:apply-templates/>
    </p>
</xsl:template>

<xsl:template match="tei:entry/form">
    	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:pos">
    	<span class="pos"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="tei:orth">
    	<span class="orth"><xsl:value-of select="."/></span>
</xsl:template>

<xsl:template match="tei:foreign">
<xsl:choose>
  <xsl:when test="./@xml:lang='heb'">
    	<span class="hebrew"><xsl:value-of select="."/></span>
  </xsl:when>
  <xsl:when test="./@xml:lang='grc'">
    	<span class="greek"><xsl:value-of select="."/></span>
  </xsl:when>
  <xsl:otherwise>
    <span class="foreign"><xsl:value-of select="."/></span>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="tei:def">
    	<i><xsl:value-of select="."/></i>
</xsl:template>

<xsl:template match="tei:ref">
<xsl:element name="a">
<xsl:attribute name="href">http://www.crosswire.org/study/passagestudy.jsp?key=<xsl:value-of select="./@osisRef"/>&amp;mod=SBLGNT</xsl:attribute>
<xsl:attribute name="target">_blank</xsl:attribute>
<xsl:value-of select="."/>
</xsl:element>
</xsl:template>
	
</xsl:stylesheet>