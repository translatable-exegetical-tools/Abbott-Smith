<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:TEI="http://www.crosswire.org/2013/TEIOSIS/namespace">
<xsl:output method="xml" encoding="UTF-8"/>

  <!--identity template copies everything forward by default-->     
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!--Remove these elements-->  
  <xsl:template match="TEI:front"/>
  <xsl:template match="TEI:back"/>
  <xsl:template match="TEI:pb"/>
  <xsl:template match="TEI:head"/>
  <xsl:template match="comment()"/>
  <xsl:template match="TEI:note"/>  

<xsl:template match="TEI:emph">
	<hi rend="italic"><xsl:apply-templates/></hi>
</xsl:template>

<xsl:template match="TEI:gloss">
	<hi rend="italic"><xsl:apply-templates/></hi>
</xsl:template>

<xsl:template match="TEI:orth">
	<foreign xml:lang="grc"><hi rend="bold"><xsl:apply-templates/></hi></foreign>
</xsl:template>

  
</xsl:stylesheet>
