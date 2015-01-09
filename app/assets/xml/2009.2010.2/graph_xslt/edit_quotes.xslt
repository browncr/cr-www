<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Edit Funny Quotes - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/quotes.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/quotes.js"><xsl:text> </xsl:text></script>
</xsl:variable>

<xsl:variable name="questions" select="document(concat('/xml/', /cr/quotes/@edition, '/long_questions.xml'))/questions" />

<xsl:template match="quote">
	<tr>
		<xsl:if test="/cr/user/level >= 2">
			<td><xsl:value-of select="@username" /></td>
		</xsl:if>
		<td title="{$questions/question[@nbr=current()/@question]}"><xsl:value-of select="@question" /></td>
		<td class="quote"><xsl:value-of select="." /></td>
		<xsl:if test="/cr/user/level >= 2">
			<td class="edit">
				<xsl:if test="@uid = /cr/user/uid and not(number(@published)) or $executive">
					<a href="javascript:void(0);" onclick="edit_quote({@id}, this.parentNode.previousSibling);" title="Edit Quote">Edit</a>
				</xsl:if>
			</td>
		</xsl:if>
		<xsl:if test="$chief">
			<td class="published">
				<input type="checkbox" name="published[]" value="{@id}">
					<xsl:if test="number(@published)">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</td>
		</xsl:if>
	</tr>
</xsl:template>

<xsl:template name="input_quote">
	<xsl:param name="count" select="1"/>

	<xsl:if test="$count > 0">
		<p>
		<label>Question #: <input type="text" name="new_quote_question{$count}" size="5" /></label>
		<xsl:text> </xsl:text>
		<label>Quote: <textarea rows="2" cols="40" name="new_quote_text{$count}"></textarea></label>
		</p>
		<xsl:call-template name="input_quote">
			<xsl:with-param name="count" select="$count - 1"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template match="quotes">
	<div id="content" class="edit_quotes">
		<h3>Funny Quotes for <xsl:value-of select="@edition" /></h3>

		<!-- Link to submit quote -->
		<xsl:if test="/cr/user/level >= 2">
			<p>
				<a href="#submit" class="button">Submit Quote(s)</a>
				<xsl:text> </xsl:text>
				<a href="/quotes" class="button">View Quotes</a>
			</p>
		</xsl:if>

		<!-- Quotes -->
		<form action="/quotes?edit=edit" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<table class="quotes">
				<thead><tr>
					<xsl:if test="/cr/user/level >= 2">
						<th>Submitter</th>
					</xsl:if>
					<th>Question #</th>
					<th>Quote</th>
					<xsl:if test="/cr/user/level >= 2">
						<th>Edit</th>
					</xsl:if>
					<xsl:if test="$chief">
						<th>Published?</th>
					</xsl:if>
				</tr></thead>
				<tbody>
					<xsl:apply-templates select="quote" />
				</tbody>
			</table>
			<xsl:if test="$chief">
				<p class="publish">
					<input type="submit" name="publish" value="Publish" />
				</p>
			</xsl:if>
		</form>

		<br />

		<!-- Form to submit quote -->
		<xsl:if test="/cr/user/level >= 2">
			<form action="/quotes?edit=edit" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<fieldset id="submit">
				<legend>Submit Quote(s)</legend>

				<input type="hidden" name="submit_quotes" value="1" />

				<p class="instructions">You may submit up to 10 quotes at once.</p>
				
				<div class="quote_inputs">
					<xsl:call-template name="input_quote">
						<xsl:with-param name="count" select="10"/>
					</xsl:call-template>
				</div>

				<xsl:apply-templates select="advisory" />

				<br />
				<input type="submit" name="submit" value="Submit" />
			</fieldset>
			</form>
		</xsl:if>
	</div>
</xsl:template>
</xsl:stylesheet>
