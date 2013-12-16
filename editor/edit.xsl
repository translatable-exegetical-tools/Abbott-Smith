<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.crosswire.org/2008/TEIOSIS/namespace" 
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" />

<xsl:template match="tei:TEI">
			<xsl:apply-templates/>
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
	<em><xsl:apply-templates/></em>
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

<xsl:template match="tei:note">
  <xsl:choose>
    <xsl:when test="@type='occurrencesNT'">
      <xsl:element name="sup">
	<xsl:attribute name="class">count</xsl:attribute>
	<xsl:text> [NT: </xsl:text>
	  <xsl:element name="span">
	    <xsl:value-of select="@n"/> <xsl:apply-templates/>
	  </xsl:element>
        <xsl:text>x] </xsl:text>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@anchored='true'">
      <xsl:element name="sup">
	<xsl:text> [</xsl:text>
	  <xsl:element name="span">
	    <xsl:value-of select="@n"/>. <xsl:apply-templates/>
	  </xsl:element>
        <xsl:text>] </xsl:text>
      </xsl:element>
    </xsl:when>
  <xsl:otherwise>
    <xsl:element name="sup">
	<xsl:text> [</xsl:text>
	  <xsl:element name="span">
	    <xsl:apply-templates/>
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
    <a class="pagenum-bottom">
        <xsl:attribute name="id">p<xsl:value-of select="./@n" /></xsl:attribute>
		<xsl:attribute name="href">http://heml.mta.ca/lace/sidebysideview2/<xsl:value-of select="(./@n + 10970912)" /></xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <sub><xsl:text> [p. </xsl:text> <xsl:value-of select="(./@n - 1)"/><xsl:text>] </xsl:text></sub>
    </a>
</xsl:template>

<xsl:template match="tei:entry">
    <p class="entry">
		<xsl:attribute name="id"><xsl:value-of select="substring-before(./@n, '|')" /></xsl:attribute>
		<bdo dir="ltr">
    	<xsl:apply-templates/>
	    </bdo>
	</p>
</xsl:template>

<xsl:template match="tei:entry/form">
    	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:pos">
    	<span class="pos"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:orth">
    	<span class="orth"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="tei:foreign">
<xsl:choose>
  <xsl:when test="./@xml:lang='heb'">
    	<bdo dir="rtl"><span class="hebrew"><xsl:apply-templates/></span></bdo>
  </xsl:when>
  <xsl:when test="./@xml:lang='arc'">
    	<bdo dir="rtl"><span class="aramaic"><xsl:apply-templates/></span></bdo>
  </xsl:when>
  <xsl:when test="./@xml:lang='grc'">
    	<span class="greek"><xsl:apply-templates/></span>
  </xsl:when>
  <xsl:when test="./@xml:lang='lat'">
    	<span class="latin"><xsl:apply-templates/></span>
  </xsl:when>
  <xsl:otherwise>
    <span class="foreign"><xsl:apply-templates/></span>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="tei:hi">
<xsl:choose>
  <xsl:when test="./@rend='subscript'">
    	<sub><xsl:apply-templates/></sub>
  </xsl:when>
  <xsl:when test="./@rend='superscript'">
    	<sup><xsl:apply-templates/></sup>
  </xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="tei:sense">
		<div class="sense">
    	<strong><xsl:value-of select="./@n"/><xsl:text> </xsl:text></strong><xsl:apply-templates/>
		</div>
</xsl:template>

<xsl:template match="tei:re">
		<div class="re">
    	<xsl:apply-templates/>
		</div>
</xsl:template>


<xsl:template match="tei:gloss">
    	<em><xsl:apply-templates/></em>
</xsl:template>

<xsl:template match="tei:ref">
<xsl:element name="a">

<xsl:choose>
  <xsl:when test="./@osisRef">
	<xsl:attribute name="href">http://www.crosswire.org/study/passagestudy.jsp?key=<xsl:value-of select="./@osisRef"/>&amp;mod=SBLGNT</xsl:attribute>
	<xsl:attribute name="target">_blank</xsl:attribute>
  </xsl:when>
  <xsl:when test="./@target">
    <xsl:attribute name="href"><xsl:value-of select="./@target"/></xsl:attribute>
  </xsl:when>
  <xsl:otherwise>
    <xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute>
  </xsl:otherwise>
</xsl:choose>


<xsl:apply-templates/>
</xsl:element>
</xsl:template>
	
</xsl:stylesheet>
