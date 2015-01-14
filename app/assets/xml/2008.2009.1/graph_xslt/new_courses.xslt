<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:cr="http://www.thecriticalreview.org/xmlns">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">New Courses this Semester - The Critical Review</xsl:variable>

<xsl:template match="new_courses/course">
	<div class="newcourse">
		<xsl:attribute name="id"><xsl:apply-templates select="." mode="course-code"/></xsl:attribute>
		<h4><xsl:value-of select="title"/></h4>
		<p class="info"><span class="coursecode"><xsl:apply-templates select="." mode="course-code"/></span>
		<xsl:if test="professor">
			<xsl:text>, Instructor</xsl:text><xsl:if test="count(professor) > 1">s</xsl:if><xsl:text>: </xsl:text>
			<xsl:for-each select="professor">
				<a class="prof" href="/professor/{substring-before(., ',')}"><xsl:value-of select="."/></a>,
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="time">
			Meeting at <span class="time"><xsl:value-of select="time"/></span>
			<xsl:if test="place"> in <span class="place"><xsl:value-of select="place"/></span></xsl:if>
		</xsl:if>
		</p>

		<div class="desc">
			<xsl:apply-templates select="desc/*" mode="content"/>
		</div>
		
		<p class="moreinfo"><a href="http://brown.mochacourses.com/mocha/search.action?q={department}{course_num}">Mocha</a> | <a href="/{department}">More <xsl:value-of select="/cr/departments/dept[@banner=current()/department]"/> Courses</a></p>
	</div>
</xsl:template>

<xsl:template match="new_courses">
	<div id="content">
		<h3>New Courses this Semester</h3>

		<p class="info">The following courses are being offered this semester for the first time ever or for the first time in several years.</p>
		<p>Teaching a new course?  Want to see it here?  Email the <a href="mailto:Critical_Review+newcourses@brown.edu">Critical Review</a> for inclusion!</p>

		<ul>
			<xsl:apply-templates select="course" mode="li">
				<xsl:sort select="department"/>
				<xsl:sort select="course_num"/>
			</xsl:apply-templates>
		</ul>

		<xsl:apply-templates select="course">
			<xsl:sort select="department"/>
			<xsl:sort select="course_num"/>
		</xsl:apply-templates>
	</div>
</xsl:template>

</xsl:stylesheet>
