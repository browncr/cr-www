<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link rel="stylesheet" type="text/css" href="/images/common.css" />
</xsl:variable>

<xsl:output method="html" encoding="UTF-8" indent="no" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />

<xsl:template match="html-content">
<xsl:value-of select="." disable-output-escaping="yes" />
</xsl:template>
</xsl:stylesheet>
