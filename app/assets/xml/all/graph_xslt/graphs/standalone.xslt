<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="base.xslt"/>

	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<xsl:param name="graph-layout" select="/.." />

	<xsl:template match="/tally">
		<xsl:apply-templates select="." mode="graph">
			<xsl:with-param name="graph-layout" select="$graph-layout"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
