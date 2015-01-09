<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Editions - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/editions_admin.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="editions">
	<!-- If we were to create a new edition, what should it be? -->
	<xsl:variable name="default_new_edition_id">
		<xsl:for-each select="edition">
			<xsl:sort select="@name"/>
			<!-- Take the last edition (as sorted by @name) and add 1 to its ID -->
			<xsl:if test="position() = last()"><xsl:value-of select="@id + 1"/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="default_new_edition">
		<xsl:for-each select="edition">
			<xsl:sort select="@name"/>
			<!-- Take the last edition (as sorted by @name) and add to it using some complicated logic -->
			<xsl:if test="position() = last()">
				<!-- Parse the edition name (YYYY.YYYY.N) into year1, year2, and sem -->
				<xsl:variable name="year1" select="substring-before(@name, '.')"/>
				<xsl:variable name="year2" select="substring-before(substring-after(@name, '.'), '.')"/>
				<xsl:variable name="sem" select="substring-after(substring-after(@name, '.'), '.')"/>
				<xsl:choose>
					<xsl:when test="$sem = 1"><xsl:value-of select="concat($year1, '.', $year2, '.', '2')"/></xsl:when>
					<xsl:when test="$sem = 2"><xsl:value-of select="concat($year1 + 1, '.', $year2 + 1, '.', '1')"/></xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<div id="content">
		<h3>Editions</h3>

		<form action="/cr.php?action=editions_admin" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<table class="editions">
				<thead>
					<tr><th>ID</th><th>Edition</th><th>Course Offered</th><th>Status</th><xsl:if test="$webmaster"><th>Actions</th></xsl:if></tr>
				</thead>
				<tbody>
					<xsl:for-each select="edition">
						<xsl:sort select="@name"/>
						<tr>
							<td class="id"><xsl:value-of select="@id"/></td>
							<td><xsl:value-of select="@name"/></td>
							<td><xsl:value-of select="."/></td>
							<td>
								<xsl:choose>
									<xsl:when test="number(@hidden)">Hidden</xsl:when>
									<xsl:when test="@id = $curr_edition/@id and @id = $next_edition/@id">Current, Next</xsl:when>
									<xsl:when test="@id = $curr_edition/@id">Current</xsl:when>
									<xsl:when test="@id = $next_edition/@id">Next</xsl:when>
									<xsl:when test="@id > $next_edition/@id">Future</xsl:when>
								</xsl:choose>
							</td>
							<xsl:if test="$webmaster">
								<td>
									<xsl:choose>
										<xsl:when test="number(@hidden)">
											<button type="submit" name="unhide_edition" value="{@id}">Unhide</button>
										</xsl:when>
										<xsl:when test="@id &lt; $curr_edition/@id">
											<button type="submit" name="hide_edition" value="{@id}">Hide</button>
										</xsl:when>
									</xsl:choose>
								</td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</form>

		<p>The "Current" edition is the latest edition visible on the website.  The "Next" edition is the edition that is currently being written by the staff.  "Future" editions will be written in future semesters.  To change the current/next editions, edit config.php in the code repository.  The "Next" edition should be incremented at the beginning of the semester prior to Packet Distribution.  The "Current" edition should be incremented at Publication time to roll out the new edition.</p>

		<xsl:if test="$webmaster">
			<fieldset>
				<legend>Create Edition</legend>
			
				<p>A new edition should be created every semester before questionnaire printing starts.  The new edition should be used to hold courses being offered THIS semester.  These courses will be reviewed NEXT semester, and then published in time for the semester AFTER that.</p>

				<p>Creating a new edition will add a row to the editions table and create the necessary data directories on the filesystem.  It will not change the current or next edition.</p>

				<p>Do not change the values below unless you know what you're doing.  The default values represent the next edition in the sequence of editions in the table above.</p>

				<form action="/cr.php?action=editions_admin" method="post">
					<xsl:copy-of select="$csrf_token_input"/>
					<p>ID: <input type="text" name="new_edition_id" value="{$default_new_edition_id}"/></p>
					<p>Edition: <input type="text" name="new_edition" value="{$default_new_edition}"/></p>
					<p><input type="submit" name="add_edition" value="Create Edition"/><input type="reset" value="Reset Form"/></p>
				</form>
			</fieldset>
		</xsl:if>
	</div>
	
</xsl:template>
</xsl:stylesheet>
