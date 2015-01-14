<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:cr="http://www.thecriticalreview.org/xmlns">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Frequently Asked Questions - The Critical Review</xsl:variable>

<xsl:template match="cr:faq/cr:q" mode="toc">
	<li><a href="#q{position()}"><xsl:value-of select="." /></a></li>
</xsl:template>

<xsl:template match="cr:faq/cr:q">
	<h4 id="q{position()}"><xsl:value-of select="." /></h4>

	<xsl:apply-templates select="following-sibling::cr:a[position()=1]" />
</xsl:template>

<xsl:template match="cr:faq/cr:a">
	<div class="faq-answer">
		<xsl:choose>
			<xsl:when test="*">
				<xsl:copy-of select="*" />
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:value-of select="." /></p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="cr:faq">
	<xsl:call-template name="about-nav"><xsl:with-param name="current">faq</xsl:with-param></xsl:call-template>
	<div id="content">
		<h3>Frequently Asked Questions</h3>

		<div class="faq">
			<ol>
				<xsl:apply-templates select="cr:q" mode="toc" />
			</ol>

			<xsl:apply-templates select="cr:q" />
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>
