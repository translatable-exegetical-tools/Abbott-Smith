<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:tei="http://www.crosswire.org/2008/TEIOSIS/namespace" 
  xmlns="http://www.bibletechnologies.net/2003/OSIS/namespace">
<xsl:output method="xml" encoding="UTF-8"/>

<xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>  
    </xsl:template>

<!--
<xsl:template match="TEI">
			<xsl:apply-templates/>
</xsl:template>

<xsl:template match="teiHeader">
			<xsl:apply-templates/>
</xsl:template>

<xsl:template match="text">
	<xsl:apply-templates/>
</xsl:template>
-->
<xsl:template match="tei:front" />

<xsl:template match="tei:pb" />

<xsl:template match="tei:div">
        <xsl:copy-of select="child::node()"/>
    </xsl:template>

<xsl:template match="tei:head" />
	
</xsl:stylesheet>
