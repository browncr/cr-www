<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Remove Review - The Critical Review</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="remove_review">
	<div id="content">
		<h3>Remove Review</h3>

		<p>Please review the following information carefully to ensure you are removing the correct review.</p>

		<table>
		<tr><td><strong>Department:</strong></td><td><xsl:value-of select="dept"/></td></tr>
		<tr><td><strong>Course:</strong></td><td><xsl:value-of select="course"/></td></tr>
		<tr><td><strong>Section:</strong></td><td><xsl:value-of select="section"/></td></tr>
		</table><br />

		<form action="/cr.php?action=remove;id={@id}" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<fieldset>
				<legend>Remove Review</legend>

				<p>If you are certain you want to remove this review, click the "Remove this Review" button below.</p>

				<p><input type="submit" name="remove" value="Remove this Review" /></p>

			</fieldset>
		</form>

		<p><a href="/cr.php?action=edit">&#xAB; Go back</a></p>
	</div>
</xsl:template>

</xsl:stylesheet>
