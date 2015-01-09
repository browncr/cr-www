<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Announce Mailing List - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/editions_admin.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="announce-list">
	<div id="content">
		<h3>Announce Mailing List</h3>

		<p>The Critical Review announce mailing list (<a href="mailto:announce@thecriticalreview.org">announce@thecriticalreview.org</a>) is used for recruiting and announcing important events like the publication of a new edition.  Prospective writers subscribe to this mailing list, so use it to announce info sessions.</p>

		<h4>Sending to the List</h4>

		<p>Send your announcement to <a href="mailto:announce@thecriticalreview.org">announce@thecriticalreview.org</a>.  You <strong>must</strong> send the message from the <a href="http://www.thecriticalreview.org/gmail">Critical Review email account</a> or it will not go through.</p>

		<h4>Subscribing People</h4>

		<p>To add people to the list, enter their email addresses, one per line, in the box below. Do this after the Activities Fair.</p>

		<form action="/cr.php?action=announce_list" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<p>
				<textarea name="subscribe" cols="40" rows="30">
				</textarea>
			</p>
			<p><input type="submit" name="submit_btn" value="Subscribe"/></p>
		</form>
	</div>
	
</xsl:template>
</xsl:stylesheet>
