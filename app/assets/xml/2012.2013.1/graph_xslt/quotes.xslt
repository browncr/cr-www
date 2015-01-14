<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Funny Quotes - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/quotes.css" />
</xsl:variable>

<xsl:template match="quotes">
	<xsl:variable name="questions" select="document(concat('/xml/', @edition, '/long_questions.xml'))/questions" />
	<xsl:variable name="quotes" select="." />

	<div id="content">
		<h3>Funny Quotes</h3>

		<xsl:if test="/cr/user/level >= 2">
			<p>
				<a href="/quotes?edit=edit#submit" class="button">Submit Quote(s)</a>
				<xsl:text> </xsl:text>
				<a href="/quotes?edit=edit" class="button">Edit Quotes</a>
			</p>
		</xsl:if>

		<p class="info">Our staff combs through more than 10,000 surveys every semester and the vast majority of the student comments are serious, honest, and constructive, written with the best of intentions, and of course we treat them as such. Occasionally, however, we come across some particularly amusing comments, and here we present them. In accordance with our long-standing policy, we have deleted any specific references and names. Enjoy!</p>


		<xsl:for-each select="$questions/question">
			<xsl:if test="$quotes/quote[@question=current()/@nbr]">
				<h4><xsl:value-of select="." /></h4>

				<xsl:for-each select="$quotes/quote[@question=current()/@nbr]">
					<xsl:value-of select="."/><br/>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>

	</div>
</xsl:template>
</xsl:stylesheet>
