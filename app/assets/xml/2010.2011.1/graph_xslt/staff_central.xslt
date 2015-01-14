<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Critical Review Staff Central</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/staff.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/searchplugin/add.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>
<xsl:include href="home_common.xslt" />

<xsl:template match="my_published_reviews/review">
	<xsl:variable name="uri"><xsl:apply-templates select="." mode="view-uri"/></xsl:variable>
	<tr>
		<td><xsl:value-of select="/cr/editions/edition[@name=current()/@edition]"/></td>
		<td><a href="{$uri}" title="{title}"><xsl:apply-templates select="." mode="course-code"/></a></td>
		<td><xsl:value-of select="views"/> views</td>
	</tr>
</xsl:template>

<xsl:template match="my_assigned_reviews/review">
	<tr>
		<td><a href="/cr.php?action=edit;edition={@edition};dept={department};course={course_num};section={section}" title="{title}"><xsl:apply-templates select="." mode="course-code"/></a></td>
		<td>
			<xsl:if test="content-source/@word-count &lt; 250">
				<xsl:attribute name="class">deficient</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="content-source/@word-count"/> words
		</td>
	</tr>
</xsl:template>

<xsl:template match="staff_central">
	<div id="content" class="staff_central">
		<h3>Critical Review Staff Central</h3>

		<xsl:apply-templates select="motd"/>

		<table class="columns">
			<tr>
				<td>
					<h4>My Top Reviews</h4>
					<table class="reviews">
						<xsl:apply-templates select="my_published_reviews/review"/>
					</table>
				</td>
				<td>
					<h4>Staff Tools</h4>

					<ul>
						<li><a href="/cr.php?action=edit">Edit Your Reviews</a></li>
						<li><a href="/quotes?edit=edit#submit">Submit Funny Quotes</a></li>
						<li><a href="/about/bios?edit=edit">Edit your Staff Bio</a></li>
						<li><a href="/cr.php?action=writer_files">Documents</a> (Writer's Guide, flow charts, etc.)</li>
						<li><a href="/cr.php?action=calendar">Calendar</a> (Deadlines, parties, etc.)</li>
					</ul>
				</td>
			</tr>
		</table>

		<div class="group feedback autowidth">
			<h4>Staff Feedback</h4>

			<form action="/cr.php?action=staff_feedback" method="post">
				<xsl:copy-of select="$csrf_token_input"/>
				<p><textarea name="feedback" cols="60" rows="3"></textarea></p>
				<p><label><input type="checkbox" name="anonymous" value="1"/> Submit anonymously</label></p>
				<p><input type="submit" name="btn" value="Submit your Feedback"/></p>
			</form>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>
