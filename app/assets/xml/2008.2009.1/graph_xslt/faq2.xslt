<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:cr="http://www.thecriticalreview.org/xmlns">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Frequently Asked Questions - The Critical Review</xsl:variable>

<xsl:template match="cr:faq/cr:q">
	<h4 id="q{position()}"><xsl:value-of select="." /></h4>

	<xsl:apply-templates select="following-sibling::cr:a[position()=1]" />
</xsl:template>

<xsl:template match="cr:faq/cr:a[@content='xhtml']">
	<p>XH</p>
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="cr:faq/cr:a[not(@content)]">
	<p>TX</p>
	<p><xsl:copy-of select="*" /></p>
</xsl:template>

<xsl:template match="cr:faq/cr:a[@content='xhtml']//*">
<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
<xsl:copy-of select="@*"/>
<xsl:apply-templates/>
</xsl:element>
</xsl:template>

<xsl:template match="cr:faq">
	<h3>Frequently Asked Questions</h3>

	<ol>
		<xsl:for-each select="cr:q">
			<li><a href="#q{position()}"><xsl:value-of select="." /></a></li>
		</xsl:for-each>
	</ol>

	<xsl:apply-templates select="cr:q" />
</xsl:template>

</xsl:stylesheet>
