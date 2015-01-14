<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/home.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/searchplugin/add.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:include href="home_common.xslt" />
<xsl:include href="feedback_common.xslt" />

<xsl:template match="home/bios/person">
	<xsl:param name="min-position" select="1"/>
	<xsl:param name="max-position" select="last()+1"/>
	<xsl:if test="position() &gt;= $min-position and position() &lt; $max-position">
		<li>
			<xsl:choose>
				<xsl:when test="@has-photo or @has-bio">
					<a href="/about/bios#bio-{@uid}"><xsl:value-of select="name"/></a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name"/>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:if>
</xsl:template>
<xsl:template match="home/bios">
	<div class="staff">
		<ul>
			<xsl:apply-templates select="person">
				<xsl:sort select="name"/>
				<xsl:with-param name="max-position" select="count(person) div 3 + 1"/>
			</xsl:apply-templates>
		</ul>
		<ul>
			<xsl:apply-templates select="person">
				<xsl:sort select="name"/>
				<xsl:with-param name="min-position" select="count(person) div 3 + 1"/>
				<xsl:with-param name="max-position" select="count(person) div 3 * 2 + 1"/>
			</xsl:apply-templates>
		</ul>
		<ul>
			<xsl:apply-templates select="person">
				<xsl:sort select="name"/>
				<xsl:with-param name="min-position" select="count(person) div 3 * 2 + 1"/>
			</xsl:apply-templates>
		</ul>
		<p class="clearer"></p>
	</div>
</xsl:template>
<xsl:template match="home">
	<xsl:call-template name="chrome_message"/>
	<div id="content" class="home">
		<!-- <h3>Introducing the New Critical Review</h3> 

		<p>The Critical Review is pleased to unveil a brand new website.  The new site is faster, easier to use, and more useful than ever.  <a href="/about/new_site">Read more about the new site</a>, or <a href="/feedback">leave feedback</a>.</p>

		<p>Check out the easier-to-use <a href="/GEOL/0220/2010-Fall">review page</a>, streamlined <a href="/GEOL?attribute_recent=1">search results</a>, and <a href="/GEOL/0220/2010-Fall?tab=demographics">rich demographics</a>.</p>
-->
		        <!-- <h3>New Student Pre-registration</h3>

        <p>New students can pre-register for Fall courses on <strong>Tuesday, September 4</strong> from <strong>5PM to midnight</strong>.  Registration opens for all students on Wednesday at 8AM.</p> -->

        <!-- <h3>Welcome Back!</h3>

        <p>Welcome back from The Critical Review! Check out our Fall 2013 reviews and make the most of shopping period.</p>
            
        <p>We are now recruiting for writing and technology positions. If you want to learn how to craft the perfect review or write code for a website used by thousands of Brown community members, leave us a note at <a href="Critical_Review@brown.edu">Critical_Review@brown.edu</a> before September 13.</p>
            
        <p>Based on our pilot program last semester, we are continuing a gradual roll out of online surveys. Stay tuned for details!</p>
        
            &#8212; Critical Review Executive Board <br /><br />

            <small style="font-style: italic">September 5, 2014</small> -->

        <h3>Pre-registration for Spring 2015 </h3>

        <p>We have published reviews for courses offered in the spring of 2014!  This was the first 
            semester in which we 1) used our new student survey and 2) experimented with having students
            fill out online surveys for certain classes. We will be continuing and expanding our experiment
            with online surveys next semester.</p>
        
        <p>The use of a new survey has reversed our old numbering system.  Five now corresponds to the 
            most positive score and one to the most negative score.  We have not modified old reviews, but 
            new reviews show both our old and new numbering systems.</p>
        
        <p>We hope that you find our latest publication useful. Please email us with feedback or 
            concerns at <a href="Critical_Review@brown.edu">Critical_Review@brown.edu</a>.  We'd love to
            hear from you.</p>
        
        &#8212; Critical Review Executive Board <br /><br />
        
            <small style="font-style: italic">October 31, 2014</small>


        <br /><br />

        <hr style="border: 2px solid #000;" />

        <h3>Course averages fixed</h3>

        <p>It was brought to our attention that the calculations for the fall 2014 semester
        course averages may have been computed incorrectly. We investigated the problem, and
        the averages have all been corrected. Thank you to those who pointed out our mistake. If
        you have any more concerns or suggestions, please let us know 
        (<a href="Critical_Review@brown.edu">Critical_Review@brown.edu</a>).</p>


        <!-- <p>Pre-registration opens on <strong>Tuesday, November 4 at 8AM</strong>.</p>

		<table class="prereg">
			<tr><th>Seniors</th><td>Tuesday</td><td>November 4, 8 AM</td></tr>
			<tr><th>Juniors</th><td>Wednesday</td><td>November 5, 8 AM</td></tr>
			<tr><th>Sophomores</th><td>Thursday</td><td>November 6, 8 AM</td></tr>
			<tr><th>Freshmen</th><td>Friday</td><td>November 7, 8 AM</td></tr>
			<tr class="closes"><th>CLOSES</th><td>Tuesday</td><td>November 11, 5 PM</td></tr> 
        </table> -->

        <hr style="border: 2px solid #000;" />

        <h3>What is the Critical Review?</h3>

            <p>The Critical Review is a Brown University student organization that publishes course reviews based on surveys distributed to all students in every class.  All reviews are held to the highest editorial standards and are based on the consensus of class members.</p>
            <p>We respect instructors' privacy: you must be a member of the Brown community to read reviews.</p>
            <p>The Critical Review is an invaluable resource for the Brown community. We rely on the continued participation of both instructors and students to bring it to you.</p>
            
            <p><a href="/about">Learn more about the Critical Review</a> or <a href="/help">get help for using this website</a>.</p>




		<!--
		<div class="group feedback autowidth">
			<h4>We Want Your Feedback</h4>

			<xsl:call-template name="feedback-form"/>
		</div>
		-->

		<div class="group">
			<h4>Brought To You By Students Like You</h4>

			<xsl:apply-templates select="bios"/>

			<p>Want to see your name here?  <a href="/about/write">Write for us!</a></p>
		</div>
		<!--
		<div class="group">
			<h4>Meet the Staff - Or Join Us!</h4>
			<p>Read about the people who make the Critical Review possible on our <a href="/about/bios">staff bios</a> page.  If you want to see <em>your</em> name there, <a href="/about/write">write for us</a>!</p>
		</div>
		-->

		<!--
		<div class="group">
			<h4>Search the Critical Review from Firefox</h4>
			<p>Click <a href="javascript:add_cr_search_plugin();">here</a> to add Critical Review to your Firefox search bar.</p>
		</div>
		-->
	</div>
</xsl:template>
</xsl:stylesheet>
