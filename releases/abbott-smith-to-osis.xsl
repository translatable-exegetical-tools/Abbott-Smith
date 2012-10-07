<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.crosswire.org/2008/TEIOSIS/namespace" 
  xmlns="http://www.bibletechnologies.net/2003/OSIS/namespace">
<xsl:output method="xml" />

<xsl:template match="tei:TEI">
	<osis xsi:schemaLocation="http://www.bibletechnologies.net/2003/OSIS/namespace 
      http://www.bibletechnologies.net/osisCore.2.1.1.xsd" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xmlns="http://www.bibletechnologies.net/2003/OSIS/namespace">
		<osisText osisRefWork="book" xml:lang="en" osisIDWork="AbbottSmith">
			<header>
				<work osisWork="AbbottSmith">
					<title>A Manual Greek Lexicon of the New Testament</title>
					<creator role="aut">G. Abbott-Smith</creator>
				</work>
				<work osisWork="Bible">
					<refSystem>Bible</refSystem>
				</work>
			</header>
			<xsl:apply-templates/>
		</osisText>
	</osis>
</xsl:template>

<xsl:template match="tei:text">
	<div type="book"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="tei:front">
	<div type="majorSection" osisID="Front Matter"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="tei:div[@type='letter']">
    <div type="chapter">
    	<xsl:apply-templates/>
    </div>
</xsl:template>

<xsl:template match="tei:body">
	<div type="majorSection" osisID="Lexicon"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="tei:head[@type='heading1']">
	<title><xsl:apply-templates/></title>
</xsl:template>

<xsl:template match="tei:head[@type='heading2']">
	<title><xsl:apply-templates/></title>
</xsl:template>

<xsl:template match="tei:head[@type='heading3']">
	<title><xsl:apply-templates/></title>
</xsl:template>

<xsl:template match="tei:head[@type='heading4']">
	<title><xsl:apply-templates/></title>
</xsl:template>

<xsl:template match="tei:p">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="tei:emph">
	<hi type="italic"><xsl:apply-templates/></hi>
</xsl:template>

<xsl:template match="tei:lb">
	<lb/>
</xsl:template>

<xsl:template match="tei:table">
	<table><xsl:apply-templates/></table>
</xsl:template>

<xsl:template match="tei:row">
	<row><xsl:apply-templates/></row>
</xsl:template>

<xsl:template match="tei:cell">
	<cell><xsl:apply-templates/></cell>
</xsl:template>

<xsl:template match="tei:note">
  <xsl:choose>
    <xsl:when test="@type='occurrencesNT'">
      <xsl:element name="hi">
	<xsl:attribute name="type">super</xsl:attribute>
	<xsl:text> [NT: </xsl:text>
	  <xsl:value-of select="@n"/> <xsl:value-of select="."/>
        <xsl:text>x] </xsl:text>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@anchored='true'">
      <xsl:element name="hi">
	<xsl:attribute name="type">super</xsl:attribute>
	<xsl:text> [</xsl:text>
	  <xsl:value-of select="@n"/>. <xsl:value-of select="."/>
        <xsl:text>] </xsl:text>
      </xsl:element>
    </xsl:when>
  <xsl:otherwise>
    <xsl:element name="hi">
      <xsl:attribute name="type">super</xsl:attribute>
	<xsl:text> [</xsl:text>
	  <xsl:value-of select="."/>
        <xsl:text>] </xsl:text>
      </xsl:element>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="tei:teiHeader"/>

<xsl:template match="tei:docTitle">
    <title>
    	<xsl:apply-templates/>
    </title>
</xsl:template>

<xsl:template match="tei:byline">
    <title>
    	<xsl:apply-templates/>
    </title>
</xsl:template>

<xsl:template match="tei:docImprint">
    <title>
    	<xsl:apply-templates/>
    </title>
</xsl:template>

<xsl:template match="tei:div[@type='dedication']">
    	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:pb">
    <hi>
        <xsl:attribute name="type">sub</xsl:attribute>
        <xsl:text> [p. </xsl:text> <xsl:value-of select="./@n"/><xsl:text>] </xsl:text>
    </hi>
</xsl:template>

<xsl:template match="tei:entry">
  <div type="x-entry">
    <p>
    	<xsl:apply-templates/>
    </p>
  </div>
</xsl:template>

<xsl:template match="tei:entry/form">
    	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:pos">
    	<hi><xsl:attribute name="type">bold</xsl:attribute><xsl:value-of select="."/></hi>
</xsl:template>

<xsl:template match="tei:orth">
    	<foreign xml:lang="grc"><xsl:value-of select="."/></foreign>
</xsl:template>

<xsl:template match="tei:foreign">
<xsl:choose>
  <xsl:when test="./@xml:lang='heb'">
    	<foreign xml:lang="heb"><xsl:value-of select="."/></foreign>
  </xsl:when>
  <xsl:when test="./@xml:lang='arc'">
    	<foreign xml:lang="arc"><xsl:value-of select="."/></foreign>
  </xsl:when>
  <xsl:when test="./@xml:lang='grc'">
    	<foreign xml:lang="grc"><xsl:value-of select="."/></foreign>
  </xsl:when>
  <xsl:when test="./@xml:lang='lat'">
    <hi>
        <xsl:attribute name="type">italic</xsl:attribute>
        <xsl:text> [p. </xsl:text> <xsl:value-of select="."/><xsl:text>] </xsl:text>
    </hi>
  </xsl:when>
  <xsl:otherwise>
    <foreign>
      <xsl:attribute name="xml:lang"><xsl:value-of select="./@xml:lang"/></xsl:attribute>
      <xsl:value-of select="."/>
    </foreign>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="tei:hi">
<xsl:choose>
  <xsl:when test="./@rend='subscript'">
    	<hi type="sub"><xsl:value-of select="."/></hi>
  </xsl:when>
  <xsl:when test="./@rend='superscript'">
    	<hi type="super"><xsl:value-of select="."/></hi>
  </xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="tei:sense">
    	<hi type="bold"><xsl:value-of select="./@n"/><xsl:text> </xsl:text></hi><xsl:apply-templates/>
</xsl:template>

<xsl:template match="tei:gloss">
    	<hi type="italic"><xsl:apply-templates/></hi>
</xsl:template>

<xsl:template match="tei:ref">
  <xsl:element name="reference">
    <xsl:attribute name="osisRef"><xsl:value-of select="./@osisRef"/></xsl:attribute>
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>
	
</xsl:stylesheet>
