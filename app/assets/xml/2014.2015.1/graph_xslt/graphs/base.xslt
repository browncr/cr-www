<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- <xsl:import href="tally.xslt"/> -->
	<xsl:import href="tally.xslt"/>
	<xsl:import href="pie.xslt"/>

	<xsl:template match="tally" mode="graph">
		<xsl:param name="graph-layout" select="/.." />
		<xsl:apply-templates select="$graph-layout/*">
			<xsl:with-param name="answers" select="answers"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="tally-summary" mode="graph">
		<xsl:param name="graph-layout" select="/.." />
		<xsl:apply-templates select="$graph-layout/*">
			<xsl:with-param name="answers" select="."/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
