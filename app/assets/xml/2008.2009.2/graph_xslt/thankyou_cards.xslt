<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Staff Thank You Cards - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>


<xsl:template match="extended_staff">
	<div id="content">
		<h3>Generate Staff Thank You Cards</h3>

		<p>Consult the documentation on the wiki for help: <a href="https://secure.thecriticalreview.org/trac/wiki/ThankyouCards">https://secure.thecriticalreview.org/trac/wiki/ThankyouCards</a></p>

		<form action="/cr.php?action=thankyou_cards" method="post">
			<xsl:copy-of select="$csrf_token_input"/>

			<p>
				<xsl:for-each select="user">
					<label class="soft">
						<input checked="checked" type="checkbox" name="bio_ids[]" value="{@bio_id}"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="name"/>
					</label>
					<xsl:text> </xsl:text>
					<input type="text" name="short_name[{@bio_id}]">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="contains(name, ' ')"><xsl:value-of select="substring-before(name, ' ')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
					<br/>
				</xsl:for-each>
			</p>

			<p>
				Print address labels for checked people to: 
				<select name="printer">
					<option value="">PDF Download</option>
					<option>click</option>
					<option>clack</option>
				</select>
				<xsl:text> </xsl:text>
				<input type="submit" name="generate_address_labels" value="Go" />
			</p>

			<p>
				Generate cards for checked people, signed:
				<input type="text" name="signature" value="Andrew, Lu, and Dingyi" size="40"/>
				<xsl:text> </xsl:text>
				<input type="submit" name="generate_cards" value="Go" />
			</p>
		</form>
	</div>
</xsl:template>

</xsl:stylesheet>
