<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Staff Calendar - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/staff.css" />
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="google-calendar">
	<iframe src="{@src}" width="750" height="550" frameborder="0" scrolling="no"></iframe>

	<xsl:if test="/cr/user/level >= 5">
		<p class="instructions">Click the "Google Calendar" button above to make changes to the calendar using Google Calendar.  Please email <a href="mailto:andrew_ayer@brown.edu">Andrew</a> if you need access.</p>
	</xsl:if>

	<p><a href="{@ics}">Subscribe to the Calendar (e.g. with iCal)</a></p>
</xsl:template>

<xsl:template match="schedule">
	<table class="staff-schedule">
		<thead>
			<tr><th colspan="2">Date</th><th>Time</th><th>Location</th><th>Event</th></tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="event"/>
		</tbody>
	</table>
</xsl:template>

<xsl:template match="schedule/event">
	<tr>
		<xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">odd</xsl:attribute></xsl:if>
		<td class="day"><xsl:value-of select="day"/></td>
		<td class="date"><xsl:value-of select="date"/></td>
		<td><xsl:value-of select="time"/></td>
		<td><xsl:value-of select="location"/></td>
		<td class="name"><xsl:value-of select="name"/></td>
	</tr>
</xsl:template>

<xsl:template match="staff-calendar">
	<div id="content">
		<h3>Staff Calendar</h3>

		<xsl:apply-templates/>
	</div>
</xsl:template>

</xsl:stylesheet>
