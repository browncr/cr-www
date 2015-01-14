<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Critical Review Documents</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="files/file">
	<li><a href="/{@path}"><xsl:value-of select="."/></a></li>
</xsl:template>

<xsl:template match="files">
	<div id="content">
		<h3>Documents</h3>

		<ul>
			<xsl:apply-templates select="file"/>
		</ul>
	</div>
</xsl:template>

</xsl:stylesheet>
