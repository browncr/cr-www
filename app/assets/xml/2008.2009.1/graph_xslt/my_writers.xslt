<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">The Critical Review - My Writers</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>
<xsl:variable name="ulevels" select="document(concat('/xml/', $next_edition, '/ulevels.xml'))/ulevels"/>

<xsl:template match="my_writers">
	<div id="content">
		<h3>My Writers</h3>

		<p>
			<a>
				<xsl:attribute name="href">
					<xsl:text>mailto:</xsl:text>
					<xsl:for-each select="writer">
						<xsl:value-of select="email"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				Email all my writers
			</a>
		</p>

		<table border="1">
			<thead>
				<tr><th>Name</th><th>Email Address</th><th>Message</th><th>Reviews</th></tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="writer">
					<xsl:sort select="name"/>
				</xsl:apply-templates>
			</tbody>
		</table>
	</div>
</xsl:template>

<xsl:template match="my_writers/writer">
	<tr>
		<td><xsl:value-of select="name"/></td>
		<td><a href="mailto:{email}"><xsl:value-of select="email"/></a></td>
		<td><a href="/cr.php?action=mailing;to_writer={@uid}">Send</a></td>
		<td><a href="/cr.php?action=edit;show=all;filter_writer={@uid}">Show</a></td>
	</tr>
</xsl:template>

</xsl:stylesheet>
