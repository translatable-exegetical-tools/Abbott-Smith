<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.crosswire.org/2013/TEIOSIS/namespace"
                exclude-result-prefixes="tei">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:entry">
    <xsl:variable name="lemma-attr" select="(@*[matches(., '\p{IsGreek}')])[1]"/>
    <xsl:variable name="other-attrs" select="@*[not(. is $lemma-attr)]"/>
    <xsl:variable name="corresp-value"
                  select="normalize-space(string-join(for $a in $other-attrs return string($a), ' '))"/>

    <xsl:copy>
      <xsl:if test="$lemma-attr">
        <xsl:attribute name="n" select="$lemma-attr"/>
      </xsl:if>
      <xsl:if test="$corresp-value">
        <xsl:attribute name="corresp" select="$corresp-value"/>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
