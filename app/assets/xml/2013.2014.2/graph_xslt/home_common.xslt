<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">

<!--
  ** Today's featured course **
  -->
<xsl:template match="featured_course" mode="full">
	<xsl:variable name="uri"><xsl:apply-templates select="review-header" mode="view-uri"/></xsl:variable>
	<h4>Course of the Day</h4>
	<h5><xsl:value-of select="review-header/title"/></h5>
	<p class="info"><span class="coursecode"><xsl:apply-templates select="review-header" mode="course-code"/></span>,
	Professor: <a href="/professor/{substring-before(review-header/professor, ',')}"><xsl:value-of select="review-header/professor"/></a>,
	Course avg: <xsl:value-of select="format-number(review-header/courseavg, '#.##')"/>,
	Prof avg: <xsl:value-of select="format-number(review-header/profavg, '#.##')"/></p>
	<p class="blurb"><xsl:value-of select="blurb"/><xsl:text> </xsl:text><a class="readall" href="{$uri}">Read Complete Review...</a></p>
</xsl:template>

<!--
  ** Previous featured courses **
  -->
<xsl:template match="past_featured_courses">
	<div class="prev">
		<h4>Featured Courses this Semester</h4>
		<ul>
			<xsl:apply-templates select="featured_course"/>
		</ul>
	</div>
</xsl:template>
<xsl:template match="past_featured_courses/featured_course">
	<xsl:variable name="uri"><xsl:apply-templates select="review-header" mode="view-uri"/></xsl:variable>
	<li><a href="{$uri}"><span class="coursecode"><xsl:apply-templates select="review-header" mode="course-code"/></span>: <xsl:value-of select="review-header/title"/></a></li>
</xsl:template>

<!--
  ** New courses **
  -->
<xsl:template match="new_courses">
	<div class="group">
		<h4>New courses this semester</h4>
		<p>The following courses are being offered this semester for the first time, or for the first time in several years.  Click for more info.</p>

		<ul>
			<xsl:apply-templates select="course" mode="li">
				<xsl:sort select="department"/>
				<xsl:sort select="course_num"/>
			</xsl:apply-templates>
		</ul>
	</div>
</xsl:template>

<!--
  ** Message of the day (MOTD) **
  TODO: use mode="content" templates
  -->
<xsl:template match="motd">
	<div class="group motd autowidth"><xsl:apply-templates/></div>
</xsl:template>
<xsl:template match="motd//title">
	<h4><xsl:apply-templates/></h4>
</xsl:template>
<xsl:template match="motd//p">
	<p><xsl:apply-templates/></p>
</xsl:template>
<xsl:template match="motd//xhtml:*">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
