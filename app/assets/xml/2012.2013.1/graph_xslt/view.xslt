<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title"><xsl:value-of select="/cr/view/review/title"/> - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/view.css" />
	<xsl:call-template name="svgweb"/>
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/view.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript">
		var initial_view_state = {
			department: '<xsl:value-of select="/cr/view/review/department"/>',
			course_num: '<xsl:value-of select="/cr/view/review/course_num"/>',
			semester: '<xsl:apply-templates select="/cr/view/review/@edition" mode="cis-semester"/>',
			section: '<xsl:value-of select="/cr/view/review/section"/>',
			tab: '<xsl:value-of select="/cr/view/@tab"/>',
			sidebar_mode: '<xsl:value-of select="/cr/view/@sidebar-mode"/>',
			more_sidebar: <xsl:value-of select="boolean(number(/cr/view/@more-sidebar))"/>
		};
		window.onpopstate = function (event) {
			view_set_state(event.state ? event.state : initial_view_state);
			view_update_dom();
		};
		view_set_state(initial_view_state);
	</script>
</xsl:variable>
<xsl:include href="view_common.xslt" />
<xsl:include href="graphs/base.xslt" />

<xsl:param name="pie-radius" select="75"/> <!-- XXX: hack - pass to templates as a with-param instead -->


<xsl:variable name="max-sidebar-reviews" select="20"/>

<xsl:template name="review-not-yet-published">
	<div class="full-message">
		<h3>Awaiting Publication</h3>

		<p>This review is still undergoing final edits and will be published shortly.  We appreciate your patience!</p>

		<p>In the meantime, you can still view the demographics for this course or read a review from a previous semester.</p>

		<xsl:choose>
			<xsl:when test="$random mod 3 = 0">
				<!-- 1/3 of time -->
				<p><strong>Did you know?</strong>  Every review undergoes two rounds of editing before publication.  The first round is conducted by an editor who checks for spelling, grammar, and structure.  The second round is conducted by two different executive editors who ensure that the review is high quality and uses a balanced and netural tone.</p>
			</xsl:when>
			<xsl:otherwise>
				<!-- 2/3 of time -->
				<p><strong>Did you know?</strong>  The Critical Review is committed to writing a review for every course which returns questionnaires.  Most reviews are published one week before preregistration, but due to understaffing not all reviews are published on time.  You can help us out by <a href="/about/write">joining the Critical Review</a>!</p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>
<xsl:template name="review-insufficient">
	<div class="full-message">
		<h3>Insufficient Information Provided</h3>

		<p>This course returned fewer than five completed surveys to the Critical Review.  Reviews based upon the statements of such a small number of respondents may present a skewed perspective of the course. Therefore, a review has not been written.  Nevertheless, the Critical Review recognizes that surveys were in fact returned.</p>

		<p>You can still view the demographics for this course or consult a review from another semester.</p>
	</div>
</xsl:template>
<xsl:template name="tally-unavailable">
	<div class="full-message">
		<h3>Graph Unavailable</h3>

		<p>The graph for this review is unavailable.  Critical Review apologizes for the inconvenience.</p>
	</div>
</xsl:template>
<xsl:template name="review-unreturned">
	<div class="full-message">
		<h3>Questionnaires Not Returned</h3>

		<p>Questionnaires for this course were not returned.  Participation in the Critical Review is voluntary and at the discretion of the instructor.  If you are a student and benefit from the Critical Review, please tell your professors and ask them to participate!</p>

		<p><strong>Instructors</strong>: Participating in the Critical Review is easy.  Several weeks before the end of each semester, questionnaires for every course are delivered to department offices.  The questionnaires come in self-addressed envelopes: no processing is required!  All it takes is 10 minutes of class time to benefit scores of students.</p>
	</div>
</xsl:template>

<!--
	*** The main review template ***
-->
<xsl:template match="review">
	<xsl:param name="current_tab"/>
	<div id="review-{generate-id()}-main" class="main">
		<div class="tab-body review">
			<xsl:choose>
				<xsl:when test="number(unreturned)">
					<!-- Not returned -->
					<xsl:call-template name="review-unreturned"/>
				</xsl:when>
				<xsl:when test="not(number(@active))">
					<!-- Not yet published -->
					<xsl:call-template name="review-not-yet-published"/>
				</xsl:when>
				<xsl:when test="number(insufficient)">
					<!-- Insufficient information provided -->
					<xsl:call-template name="review-insufficient"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="tally/profavg != 0 and tally/courseavg != 0 and tally/num_respondents &gt;= $tally-min-respondents">
						<xsl:apply-templates select="." mode="stats-sidebar"/>
					</xsl:if>
					<xsl:apply-templates select="content"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="tab-body stats">
			<xsl:choose>
				<xsl:when test="number(unreturned)">
					<!-- Not returned -->
					<xsl:call-template name="review-unreturned"/>
				</xsl:when>
				<xsl:when test="not(number(@active))">
					<!-- Not yet published -->
					<xsl:call-template name="review-not-yet-published"/>
				</xsl:when>
				<xsl:when test="not(tally) or tally/profavg = 0 or tally/courseavg = 0 or tally/num_respondents = 0">
					<!-- Tally not available -->
					<xsl:call-template name="tally-unavailable"/>
				</xsl:when>
				<xsl:when test="tally/num_respondents &lt; $tally-min-respondents">
					<!-- Insufficient information provided -->
					<xsl:call-template name="review-insufficient"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="stats-tab"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="tab-body demographics">
			<xsl:choose>
				<xsl:when test="number(unreturned)">
					<!-- Not returned -->
					<p class="notice">Questionnaires for this course were not returned, so The Critical Review was unable to compile detailed demographics.</p>
				</xsl:when>
				<xsl:when test="not(number(@active))">
					<!-- Not yet published -->
					<p class="notice">This review is not yet published.  Please check back later for more detailed demographics.</p>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="." mode="demographics-tab"/>
		</div>
	</div>
</xsl:template>

<xsl:template name="bar-graph-style" match="node()|@*" mode="bar-graph-style">
    <!-- Parameters that control how the bar graph looks -->
    <xsl:param name="image-height" select="5" />
    <xsl:param name="bar-width" select="5.5" />
    <xsl:param name="font-family" select="'sans-serif'" />
    <svg xmlns="http://www.w3.org/2000/svg" width="{$bar-width}em" height="{$image-height}em" >
        <rect x="0em" y="0em" width="{$bar-width}em"
            height="{$image-height}em" fill="transparent" stroke-width="0.1em" stroke="black"/>
        <rect x="0em" y="{$image-height - .}em" width="{$bar-width}em"
            height="{.}em" fill="#0A4B5C" stroke="black"/>
        <text x="{$bar-width div 2}em" y="{$image-height - 0.05}em" font-family="{$font-family}" fill="white" text-anchor="middle">
            <xsl:value-of select="format-number(., '#.##')"/>
        </text>
    </svg>
</xsl:template>



<xsl:template match="review" mode="stats-sidebar">
	<div class="stats-sidebar">
        <xsl:choose>
            <!-- Test if this is an edition from before 2014.2015.2, when we changed scale -->
            <xsl:when test="number(substring(@edition, 1, 4)) &lt; 2014 or (number(substring(@edition, 6,4)) = 2015 and number(substring(@edition, 11, 1)) &lt; 2)">
		        <div class="box">
		        	<div class="inner">
		        		<xsl:apply-templates select="tally/courseavg" mode="average-box-style"/>
		        		<p class="avg"><xsl:value-of select="format-number(tally/courseavg, '#.##')"/></p>
		        		<p class="desc">Course</p>
		        	</div>
		        </div>
		        <div class="box">
		        	<div class="inner">
		        		<xsl:apply-templates select="tally/profavg" mode="average-box-style"/>
		        		<p class="avg"><xsl:value-of select="format-number(tally/profavg, '#.##')"/></p>
		        		<p class="desc">Prof</p>
		        	</div>
		        </div>
		        <xsl:apply-templates select="../tally-summary/q[@id='loved']" mode="average-box">
		        	<xsl:with-param name="desc">Loved It</xsl:with-param>
		        </xsl:apply-templates>
		        <xsl:apply-templates select="../tally-summary/q[@id='learned']" mode="average-box">
		        	<xsl:with-param name="desc">Learned a Lot</xsl:with-param>
		        </xsl:apply-templates>
		        <xsl:apply-templates select="../tally-summary/q[@id='non-concs']" mode="average-box">
		        	<xsl:with-param name="desc">Good for Non- Concentrators</xsl:with-param>
		        </xsl:apply-templates>
		        <xsl:apply-templates select="../tally-summary/q[@id='difficult']" mode="average-box">
		        	<xsl:with-param name="desc">Difficult</xsl:with-param>
		        </xsl:apply-templates>

                <xsl:if test="tally/minhours_mean != '' and tally/maxhours_mean != '' and tally/minhours_mean != '0' and tally/maxhours_mean != '0'">
                    <div> <!-- Nest inside a div to ensure that these show up on the same "line" -->
                        <div class="box">
                            <div class="inner">
                                <p class="avg"><xsl:value-of select="format-number(tally/minhours_mean, '#.#')"/></p>
                                <p class="desc">Hours,<br/>typical week</p>
                            </div>
                        </div>
                        <div class="box">
                            <div class="inner">
                                <p class="avg"><xsl:value-of select="format-number(tally/maxhours_mean, '#.#')"/></p>
                                <p class="desc">Hours,<br/>maximum</p>
                            </div>
                        </div>
                    </div>
                </xsl:if>

            </xsl:when>
            <xsl:otherwise>




		        <div class="box">
		        	<div class="inner">
                            
                        <xsl:apply-templates select="tally/courseavg" mode="bar-graph-style"/>
                            <!-- <p class="newavg" style="background-color: #0a4b5c; height: {tally/courseavg}em"><xsl:value-of select="format-number(tally/courseavg, '#.##')"/></p> -->
		        		<p class="desc">Course</p>
		        	</div>
		        </div>
		        <div class="box">
		        	<div class="inner">
                        <xsl:apply-templates select="tally/profavg" mode="bar-graph-style"/>
                            <!-- <p class="newavg" style="background-color: #0a4b5c; height: {tally/profavg}em"><xsl:value-of select="format-number(tally/profavg, '#.##')"/></p> -->
		        		<p class="desc">Prof</p>
		        	</div>
		        </div>

                <xsl:if test="tally/minhours_mean != '' and tally/maxhours_mean != '' and tally/minhours_mean != '0' and tally/maxhours_mean != '0'">
                    <div> <!-- Nest inside a div to ensure that these show up on the same "line" -->
                        <div class="box">
                            <div class="inner">
                                <p class="avg"><xsl:value-of select="format-number(tally/minhours_mean, '#.#')"/></p>
                                <p class="desc">Hours,<br/>typical week</p>
                            </div>
                        </div>
                        <div class="box">
                            <div class="inner">
                                <p class="avg"><xsl:value-of select="format-number(tally/maxhours_mean, '#.#')"/></p>
                                <p class="desc">Hours,<br/>maximum</p>
                            </div>
                        </div>
                    </div>
                </xsl:if>

                <small>For your convenience, here are the professor and course
                averages converted to the old scale: </small><br />

		        <div class="box">
		        	<div class="inner">
                        <xsl:variable name="converted-courseavg">
                            <xsl:value-of select="-3 * (((tally/courseavg - 1) div 4) - 1) + 1" />
                        </xsl:variable>
		        		<xsl:apply-templates mode="average-box-style">
						  <xsl:with-param name="average" select="$converted-courseavg"/>
                        </xsl:apply-templates>
		        		<p class="avg"><xsl:value-of select="format-number($converted-courseavg, '#.##')"/></p>
		        		<p class="desc">Course</p>
		        	</div>
		        </div>
		        <div class="box">
		        	<div class="inner">
                        <xsl:variable name="converted-profavg">
                            <xsl:value-of select="-3 * (((tally/profavg - 1) div 4) - 1) + 1" />
                        </xsl:variable>
		        		<xsl:apply-templates mode="average-box-style">
						  <xsl:with-param name="average" select="$converted-profavg"/>
                        </xsl:apply-templates>
		        		<p class="avg"><xsl:value-of select="format-number($converted-profavg, '#.##')"/></p>
		        		<p class="desc">Prof</p>
		        	</div>
		        </div>

            </xsl:otherwise>
        </xsl:choose>
        <p class="scale">
			<xsl:call-template name="avg-scale"/>
			<span class="left">Agree</span>
			<span class="right">Disagree</span>
			<span class="clearer"></span>
		</p>
	</div>
</xsl:template>
<xsl:template match="review" mode="stats-tab">
	<xsl:if test="tally/@format = 'blob'">
		<p class="notice">This is an old graph.  Its scale and color scheme may differ from newer, post-2003 graphs.  Please keep this in mind when comparing with more recent reviews.</p>
	</xsl:if>
	<div class="graph">
		<xsl:choose>
			<xsl:when test="tally/@format = 'old' or tally/@format = 'blob'">
				<p>
					<img class="legend" src="/images/editions/{@edition}/legend.gif" alt="Legend Describing Graph" />
					<img class="graph" src="/old_graph.php?id={@id}" alt="Graph Summarizing Students' Responses"/>
				</p>
				<p><img class="key" src="/images/editions/{@edition}/key.gif" alt="Legend Describing Graph" /></p>
			</xsl:when>
			<xsl:when test="tally/@format = 'xml'">
				<p>
					<img class="graph" src="/graph.php?id={@id}" alt="Graph Summarizing Students' Responses"/>
				</p>
				<div class="key">
                    <xsl:choose>
                        <!-- Test if this is an edition from before 2014.2015.2, when we changed scale -->
                        <xsl:when test="number(substring(@edition, 1, 4)) &lt; 2014 or (number(substring(@edition, 6,4)) = 2015 and number(substring(@edition, 11, 1)) &lt; 2)">
                            <p><xsl:call-template name="old-tally-key"/></p>
                            <p>1s indicate strong agreement.  4s indicate strong disagreement.
                            Greens mean more agreement.  Reds mean more disagreement.
                            Blank space indicates a response of Not Applicable.</p>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:call-template name="tally-key"/></p>
                            <p>5s indicate strong agreement.  1s indicate strong disagreement.
                            Greens mean more agreement. Reds mean more disagreement.
                            Blank space indicates a response of Not Applicable.</p>
                        </xsl:otherwise>
                    </xsl:choose>
				</div>
			</xsl:when>
		</xsl:choose>
	</div>
</xsl:template>
<xsl:template match="review" mode="demographics-tab">
	<xsl:if test="enrollment/frosh + enrollment/soph + enrollment/jun + enrollment/sen + enrollment/grad">
		<div class="pie">
			<div class="inner">
				<h4>Class</h4>
				<p>
					<xsl:apply-templates select="enrollment" mode="pie-graph">
						<xsl:with-param name="pie-radius" select="75"/>
					</xsl:apply-templates>
				</p>
			</div>
		</div>
	</xsl:if>

	<xsl:if test="../tally-summary/q[@id='conc']">
		<div class="pie">
			<div class="inner">
				<h4>Concentrator in this department</h4>
				<p>
					<xsl:apply-templates select="../tally-summary" mode="conc-graph"/>
				</p>
			</div>
		</div>
	</xsl:if>

	<xsl:if test="../tally-summary/q[@id='graded']">
		<div class="pie">
			<div class="inner">
				<h4>Taking this course for a grade</h4>
				<p>
					<xsl:apply-templates select="../tally-summary" mode="graded-graph"/>
				</p>
			</div>
		</div>
	</xsl:if>

	<xsl:if test="../tally-summary/q[@id='requirement']">
		<div class="pie">
			<div class="inner">
				<h4>Taking this course to satisfy a requirement</h4>
				<p>
					<xsl:apply-templates select="../tally-summary" mode="requirement-graph"/>
				</p>
			</div>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="view/review" mode="header">
	<xsl:param name="current_tab"/>
	<xsl:variable name="cis-semester"><xsl:apply-templates select="@edition" mode="cis-semester"/></xsl:variable>
	<div class="header">
		<div class="inner">
			<h2>
				<!--
				<a href="/{department}" title="See more reviews for this department"><xsl:value-of select="$departments/dept[@banner = current()/department]"/></a>
				&#8594;
				-->
				<!--
				<span class="arrow">&#9656;</span>
				-->
				<span class="course_code"><a href="/{department}" title="{$departments/dept[@banner = current()/department]}"><xsl:value-of select="department"/></a><xsl:text> </xsl:text><xsl:value-of select="course_num"/></span>
				<!--
				from the <a href="/{department}" title="See more reviews for this department"><xsl:value-of select="$departments/dept[@banner = current()/department]"/></a> department
				-->
			</h2>
			<p class="title"><xsl:value-of select="title"/></p>
			<p class="instructor">
				<xsl:for-each select="professors/p">
					<a href="/professor/{.}" title="See more reviews for this professor"><xsl:value-of select="."/></a>
					<xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
				</xsl:for-each>
			</p>
		</div>
		<ul class="tabs">
			<xsl:variable name="content_uri">
				<xsl:apply-templates select="ancestor::view[1]" mode="uri">
					<xsl:with-param name="tab">content</xsl:with-param>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="stats_uri">
				<xsl:apply-templates select="ancestor::view[1]" mode="uri">
					<xsl:with-param name="tab">stats</xsl:with-param>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="demographics_uri">
				<xsl:apply-templates select="ancestor::view[1]" mode="uri">
					<xsl:with-param name="tab">demographics</xsl:with-param>
				</xsl:apply-templates>
			</xsl:variable>
			<li class="content">
				<a onclick="return view_set_tab(this, 'content');" href="{$content_uri}">Review</a>
			</li>
			<li class="stats">
				<a onclick="return view_set_tab(this, 'stats');" href="{$stats_uri}">Graph</a>
			</li>
			<li class="demographics">
				<a onclick="return view_set_tab(this, 'demographics');" href="{$demographics_uri}">Demographics</a>
			</li>
		</ul>
		<ul class="links">
			<xsl:variable name="catalog-uri"><xsl:apply-templates select="." mode="banner-catalog-uri"/></xsl:variable>
			<xsl:variable name="schedule-uri"><xsl:apply-templates select="." mode="banner-schedule-uri"/></xsl:variable>
			<li><a href="http://brown.mochacourses.com/mocha/search.action?q={department}{course_num}">Mocha</a></li>
			<li><a href="{$catalog-uri}">Catalog</a></li>
			<li><a href="{$schedule-uri}">Schedule</a></li>
		</ul>
		<table class="vital-stats">
			<!--
			<xsl:if test="tally/num_respondents &gt;= $tally-min-respondents">
				<xsl:if test="number(tally/profavg)">
					<tr><th>Prof Avg:</th><td><xsl:value-of select="format-number(tally/profavg, '#.##')"/></td></tr>
				</xsl:if>
				<xsl:if test="number(tally/profavg)">
					<tr><th>Course Avg:</th><td><xsl:value-of select="format-number(tally/courseavg, '#.##')"/></td></tr>
				</xsl:if>
			</xsl:if>
			-->
			<xsl:if test="courseformat != ''">
				<tr><th>Format:</th><td><xsl:value-of select="courseformat"/></td></tr>
			</xsl:if>
			<xsl:if test="number(enrollment/total)">
				<tr><th>Class Size:</th><td><xsl:value-of select="enrollment/total"/></td></tr>
			</xsl:if>
			<xsl:if test="number(tally/num_respondents)">
				<tr><th>Respondents:</th><td><xsl:value-of select="tally/num_respondents"/></td></tr>
			</xsl:if>
		</table>
	</div>
</xsl:template>

<xsl:template match="view/other-reviews">
	<xsl:param name="current" select="/.."/>
	<xsl:param name="sidebar_mode"/>
	<div class="sidebar">
		<p class="mode">
			<xsl:variable name="sections_uri">
				<xsl:apply-templates select="ancestor::view[1]" mode="uri">
					<xsl:with-param name="sidebar_mode">sections</xsl:with-param>
					<xsl:with-param name="more_sidebar" select="false()"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:variable name="instructors_uri">
				<xsl:apply-templates select="ancestor::view[1]" mode="uri">
					<xsl:with-param name="sidebar_mode">instructors</xsl:with-param>
					<xsl:with-param name="more_sidebar" select="false()"/>
				</xsl:apply-templates>
			</xsl:variable>
			<a class="if-sidebar if-sidebar-instructors" onclick="return view_set_sidebar_mode(this, 'sections');" href="{$sections_uri}">Show Sections</a>
			<a class="if-sidebar if-sidebar-sections" onclick="return view_set_sidebar_mode(this, 'instructors');" href="{$instructors_uri}">Show Profs</a>
		</p>
		<ul class="if-sidebar if-sidebar-instructors">
			<xsl:apply-templates select="review-header" mode="by-instructor">
				<xsl:sort select="instructor/last" order="ascending"/>
				<xsl:with-param name="current" select="$current"/>
			</xsl:apply-templates>
		</ul>
		<ul class="if-sidebar if-sidebar-sections">
			<xsl:apply-templates select="review-header" mode="by-section">
				<xsl:sort select="@edition" order="descending"/>
				<xsl:with-param name="current" select="$current"/>
			</xsl:apply-templates>
		</ul>
		<xsl:if test="count(review-header) &gt; $max-sidebar-reviews">
			<p class="more">
				<a onclick="return view_show_more_sidebar(this);">
					<xsl:attribute name="href">
						<xsl:apply-templates select="ancestor::view[1]" mode="uri">
							<xsl:with-param name="more_sidebar" select="true()"/>
						</xsl:apply-templates>
					</xsl:attribute>
					<xsl:value-of select="count(review-header) - $max-sidebar-reviews"/> More...
				</a>
			</p>
		</xsl:if>
	</div>
</xsl:template>
<xsl:template match="view/other-reviews/review-header" mode="link">
	<xsl:param name="current" select="/.."/>
	<xsl:param name="title"/>
	<xsl:param name="content" select="/.."/>
	<xsl:variable name="cis-semester"><xsl:apply-templates select="@edition" mode="cis-semester"/></xsl:variable>
	<a onclick="return view_select_review(this, '{$cis-semester}', '{section}');" title="{$title}">
		<xsl:attribute name="class">
			<xsl:if test="not(number(@active)) or number(insufficient) or number(unreturned)">
				<!-- Not yet published, insufficient information, or unreturned -->
				incomplete
			</xsl:if>
			<xsl:if test="@edition = $current/@edition and section = $current/section">
				current
			</xsl:if>
		</xsl:attribute>
		<xsl:attribute name="href">
			<xsl:apply-templates select="ancestor::view[1]" mode="uri">
				<xsl:with-param name="review" select="current()"/>
			</xsl:apply-templates>
		</xsl:attribute>
		<xsl:copy-of select="$content"/>
	</a>
</xsl:template>
<xsl:template match="view/other-reviews/review-header" mode="section-subitem">
	<xsl:param name="current" select="/.."/>
	<li>
		<xsl:if test="count(preceding-sibling::review-header) &gt; $max-sidebar-reviews">
			<xsl:attribute name="class">overflow</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="." mode="link">
			<xsl:with-param name="current" select="$current"/>
			<xsl:with-param name="title" select="professor"/>
			<xsl:with-param name="content">
				<span class="section">Section <xsl:value-of select="section"/></span>
			</xsl:with-param>
		</xsl:apply-templates>
	</li>
</xsl:template>
<xsl:template match="view/other-reviews/review-header" mode="by-section">
	<xsl:param name="current" select="/.."/>
	<!-- $same-semester: All of the other reviews in this same semester -->
	<xsl:variable name="same-semester" select="../review-header[@edition = current()/@edition]"/>
	<li>
		<xsl:if test="count(preceding-sibling::review-header) &gt; $max-sidebar-reviews">
			<xsl:attribute name="class">overflow</xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count($same-semester) = 1">
				<!-- Simple case: only one review this semester -->
				<xsl:apply-templates select="." mode="link">
					<xsl:with-param name="current" select="$current"/>
					<xsl:with-param name="title" select="professor"/>
					<xsl:with-param name="content">
						<span class="semester"><xsl:apply-templates select="@edition" mode="semester-string"/></span>
						<xsl:if test="../review-header[generate-id() != generate-id(current()) and @edition = current()/@edition]">
							<xsl:text> </xsl:text>
							<span class="section">Section <xsl:value-of select="section"/></span>
						</xsl:if>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="generate-id($same-semester[1]) = generate-id()">
				<span class="multi semester"><xsl:apply-templates select="@edition" mode="semester-string"/></span>
				<ul>
					<xsl:apply-templates select="$same-semester" mode="section-subitem">
						<xsl:with-param name="current" select="$current"/>
						<xsl:sort select="section" data-type="number"/>
					</xsl:apply-templates>
				</ul>
			</xsl:when>
		</xsl:choose>
	</li>
</xsl:template>

<xsl:template match="view/other-reviews/review-header" mode="instructor-subitem">
	<xsl:param name="current" select="/.."/>
	<li>
		<xsl:if test="count(preceding-sibling::review-header) &gt; $max-sidebar-reviews">
			<xsl:attribute name="class">overflow</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="." mode="link">
			<xsl:with-param name="current" select="$current"/>
			<xsl:with-param name="title" select="concat('Section ', section)"/>
			<xsl:with-param name="content">
				<span class="semester"><xsl:apply-templates select="@edition" mode="semester-string"/></span>
			</xsl:with-param>
		</xsl:apply-templates>
	</li>
</xsl:template>
<xsl:template match="view/other-reviews/review-header" mode="by-instructor">
	<xsl:param name="current" select="/.."/>
	<!-- $same-instructor: All of the other reviews with the same instructor -->
	<xsl:variable name="same-instructor" select="../review-header[instructor/last = current()/instructor/last]"/>
	<xsl:variable name="semester-string"><xsl:apply-templates select="@edition" mode="semester-string"/></xsl:variable>
	<li>
		<xsl:if test="count(preceding-sibling::review-header) &gt; $max-sidebar-reviews">
			<xsl:attribute name="class">overflow</xsl:attribute>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="count($same-instructor) = 1">
				<!-- Simple case: only one review for this instructor -->
				<xsl:apply-templates select="." mode="link">
					<xsl:with-param name="current" select="$current"/>
					<xsl:with-param name="title" select="$semester-string"/>
					<xsl:with-param name="content">
						<span class="instructor"><xsl:value-of select="instructor/last"/></span>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="generate-id($same-instructor[1]) = generate-id()">
				<span class="multi instructor"><xsl:value-of select="instructor/last"/></span>
				<ul>
					<xsl:apply-templates select="$same-instructor" mode="instructor-subitem">
						<xsl:with-param name="current" select="$current"/>
						<xsl:sort select="@edition" order="descending"/>
					</xsl:apply-templates>
				</ul>
			</xsl:when>
		</xsl:choose>
	</li>
</xsl:template>

<xsl:template name="multiple_prof_message">
	<p class="prof-name-notice">This course was taught by more than one instructor.  Due to current technical limitations, the instructor name may not display properly.  <a href="/help/instructor_names">Learn More...</a></p>
</xsl:template>
<xsl:template name="incomplete_prof_name_message">
	<p class="prof-name-notice">Due to gaps in our records, the Critical Review does not have the full and accurate name of this course's instructor.  If you know this instructor's full name, please contact <a href="mailto:webmaster@thecriticalreview.org">webmaster@thecriticalreview.org</a>.  <a href="/help/instructor_names">Learn More...</a></p>
</xsl:template>

<xsl:template match="view">
	<div id="content">
		<xsl:attribute name="class">
			<xsl:text>view</xsl:text>
			<xsl:text> tab-</xsl:text><xsl:value-of select="@tab"/>
			<xsl:text> sidebar-</xsl:text><xsl:value-of select="@sidebar-mode"/>
			<xsl:if test="not(number(@more-sidebar))"> truncated-sidebar</xsl:if>
		</xsl:attribute>
        <xsl:if test="review/@edition = '2014.2015.2'">
			<xsl:call-template name="new_scale_message"/>
        </xsl:if>
        <xsl:for-each select="review/messages/message">
            <div class="dept_message">
                <p><xsl:value-of select="." /></p>
            </div>
		</xsl:for-each>
		<xsl:if test="review/department = 'CLPS' or review/department = 'PSYC' or review/department = 'COGS'">
			<xsl:call-template name="clps_dept_message"/>
		</xsl:if>
		<!-- <xsl:if test="review/department = 'ENGL'">
			<xsl:call-template name="english_dept_message"/>
		</xsl:if> -->
		<xsl:if test="review/prof_name_status = -2">
			<xsl:call-template name="multiple_prof_message"/>
		</xsl:if>
		<xsl:if test="review/prof_name_status = -1 or review/prof_name_status = 0">
			<xsl:call-template name="incomplete_prof_name_message"/>
		</xsl:if>
		<xsl:apply-templates select="review" mode="header">
			<xsl:with-param name="current_tab" select="@tab"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="other-reviews[review-header]">
			<xsl:with-param name="current" select="review"/>
			<xsl:with-param name="sidebar_mode" select="@sidebar-mode"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="review">
			<xsl:with-param name="current_tab" select="@tab"/>
		</xsl:apply-templates>
	</div>
</xsl:template>
<xsl:template match="view" mode="uri">
	<xsl:param name="tab" select="@tab"/>
	<xsl:param name="sidebar_mode" select="@sidebar-mode"/>
	<xsl:param name="more_sidebar" select="boolean(number(@more-sidebar))"/>
	<xsl:param name="review" select="review"/>
	<xsl:apply-templates select="$review" mode="view-uri">
		<xsl:with-param name="tab" select="$tab"/>
		<xsl:with-param name="sidebar_mode" select="$sidebar_mode"/>
		<xsl:with-param name="more_sidebar" select="$more_sidebar"/>
	</xsl:apply-templates>
</xsl:template>



</xsl:stylesheet>

