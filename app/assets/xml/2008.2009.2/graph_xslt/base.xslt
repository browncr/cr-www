<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:cr="http://www.thecriticalreview.org/xmlns"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xhtml">

<!-- Output settings -->
<!-- Note: using UTF-8 and omitting the XML declaration is necessary to make it work right in IE -->
<xsl:output
	method="xml"
	encoding="UTF-8"
	indent="no"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	omit-xml-declaration="yes" />

<xsl:param name="is_microsoft" select="system-property('xsl:vendor') = 'Microsoft'"/>
<xsl:param name="use_svgweb" select="$is_microsoft"/>

<!--
  ** Assets version number **
  Set in config.php and sent back by cr.php
  This number is used when constructing URLs to "assets" (XSLT, CSS, Javascript, images, and included XML files).
  Increment every time you change an asset so that the URL changes and browsers re-fetch the asset
  instead of using a cached copy.
-->
<xsl:variable name="assets_version" select="/cr/@assets-version"/>

<!--
  ** CSRF token **
  This is a secret key sent back by the server (if we're logged in) which we should include in all
  form requests to the server (see session.php).  This token proves that the form was submitted from
  a real user and not an attacker trying to do a cross-site request forgery (CSRF) attack.
-->
<xsl:variable name="csrf_token" select="/cr/@csrf-token"/>
<!--
  For convenience, you can include $csrf_token_input at the beginning of a form like this:
    <form method="post" action="...">
      <xsl:copy-of select="$csrf_token_input"/>
      ...
    </form>
  This will automatically add the hidden form input containing the CSRF token.
-->
<xsl:variable name="csrf_token_input">
	<input type="hidden" name="csrf_token" value="{$csrf_token}"/>
</xsl:variable>

<!-- Variables set by the XSLT for specific pages -->
<xsl:variable name="title">The Critical Review</xsl:variable>
<xsl:variable name="scripts"/> <!-- TODO: rename to 'resources' or something because it's now used to specify CSS as well -->
<xsl:variable name="staff_sidebar" select="false()"/>

<!-- Useful variables -->
<xsl:variable name="curr_edition" select="/cr/edition/current"/>
<xsl:variable name="next_edition" select="/cr/edition/next"/>
<xsl:variable name="executive" select="/cr/user/level >= 4"/> <!-- Is this user an executive editor or above? -->
<xsl:variable name="chief" select="/cr/user/level >= 5"/> <!-- Is this user an editor-in-chief or above? -->
<xsl:variable name="webmaster" select="/cr/user/level >= 6"/> <!-- Is this user a webmaster? -->
<xsl:variable name="cr_subdomain" select="/cr/@subdomain"/>
<xsl:variable name="is_dev" select="starts-with($cr_subdomain, 'dev')"/>
<xsl:variable name="random" select="/cr/random"/>
<xsl:variable name="time" select="/cr/time"/>
<xsl:variable name="editions" select="document(concat('/assets/', $assets_version, '/xml/editions.php'))/editions"/>
<xsl:variable name="departments" select="document(concat('/assets/', $assets_version, '/xml/departments.php'))/departments"/>
<xsl:variable name="tally-min-respondents" select="5"/>

<!-- Ignore various elements that contain auxillary information -->
<xsl:template match="/cr/user" />
<xsl:template match="/cr/edition" />
<xsl:template match="/cr/editions" />
<xsl:template match="/cr/departments" />
<xsl:template match="/cr/staff" />
<xsl:template match="/cr/request" />
<xsl:template match="/cr/random" />
<xsl:template match="/cr/time" />

<!-- Head of the page -->
<xsl:template name="head">
	<head>
		<!-- NOTE: due to IE bug, meta tags must come BEFORE script tags -->
		<!-- (see http://stackoverflow.com/questions/83132/what-causes-the-error-cant-execute-code-from-a-freed-script) -->
		<xsl:comment><![CDATA[[if IE]>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<![endif]]]></xsl:comment>

		<title><xsl:value-of select="$title"/></title>
		<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/core.css" />
		<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/common.css" />

		<!-- /css/ie6fix.css is included only on IE6 -->
		<xsl:comment><![CDATA[[if lt IE 7]>
			<link type="text/css" rel="stylesheet" href="/css/ie6fix.css" />
		<![endif]]]></xsl:comment>

		<!-- /css/iefix.css is included on all versions of IE -->
		<xsl:comment><![CDATA[[if IE]>
			<link type="text/css" rel="stylesheet" href="/css/iefix.css" />
		<![endif]]]></xsl:comment>

		<!-- (experimentation)
		<script type="text/javascript" src="/js/scroll.js"></script>
		-->
		<link rel="search" type="application/opensearchdescription+xml" href="/searchplugin/criticalreview.xml" title="Critical Review" /> <!-- This enables searching from the Firefox search box -->

		<xsl:if test="$csrf_token">
			<!--
			Make the CSRF token (see extensive comments above) available to Javascript
			so it can be used in AJAX requests.
			-->
			<script type="text/javascript">var csrf_token = '<xsl:value-of select="$csrf_token"/>';</script>
		</xsl:if>
		<xsl:copy-of select="$scripts" />
		<xsl:if test="/cr/login-form">
			<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
			<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
			<script type="text/javascript">
				<xsl:choose>
					<xsl:when test="/cr/login-form/username">
						register_onload_event(function() { $('login_form').password.focus(); });
					</xsl:when>
					<xsl:otherwise>
						register_onload_event(function() { $('login_form').username.focus(); });
					</xsl:otherwise>
				</xsl:choose>
			</script>
		</xsl:if>

		<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/print.css">
			<!--
			Normally, we set the attribute media="print" so that this stylesheet is only used when printing.
			However, since not all browsers support the media="print" attribute (*cough* IE *cough*), we also have a special "print mode" of the website in which the /cr/@print attribute is present (see cr.php).  Then, we leave off the media="print" attribute, so this print stylesheet is *always* used.
			-->
			<xsl:if test="not(/cr/@print)">
				<xsl:attribute name="media">print</xsl:attribute>
			</xsl:if>
		</link>
	</head>
</xsl:template>

<!-- Header of the page -->
<xsl:template name="header">
	<div id="header">
		<h1>
			<a href="/">
				The Critical Review
			</a>
		</h1>
		<p class="user_info">
			<xsl:choose>
				<xsl:when test="/cr/user/level >= 1">
					Logged in as <span class="username"><xsl:value-of select="/cr/user/name" /></span>.
					<a href="/cr.php?logout=1">Logout</a>
					<xsl:text> </xsl:text>
					<a href="/cr.php?action=change_password">Password</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="/cr/@subdomain != 'beta'"> <!-- Temporary, until HTTPS is figured out -->
						<a href="https://{/cr/@https-server}/cr.php?login_form=yes;{/cr/@request}">Staff Login</a>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<ul class="nav">
			<li><a href="/search">Search</a></li>
			<!--
			<li><a href="/quotes">Quotes</a></li>
			-->
			<li><a href="/about">About</a></li>
			<li><a href="/help">Help</a></li>
			<xsl:choose>
				<xsl:when test="/cr/user/level >= 2">
					<li><a href="/cr.php?action=staff_central">Staff</a></li>
				</xsl:when>
				<xsl:otherwise>
					<li><a href="/about/write">Write for CR</a></li>
				</xsl:otherwise>
			</xsl:choose>
		</ul>

	</div>
</xsl:template>

<!-- Sidebar -->
<xsl:template name="sidebar">
	<xsl:variable name="search" select="/cr/search/params"/>
	<div id="sidebar">
		<xsl:if test="$staff_sidebar and /cr/user/level >= 2">
			<div class="staff">
				<h2>Staff</h2>
				<ul>
					<li><a href="/staff">Staff Central</a></li>
					<li><a href="/cr.php?action=edit">Edit Reviews</a></li>
					<xsl:if test="/cr/user/level &gt;= 3">
						<li><a href="/staff/my_writers">My Writers</a></li>
						<li><a href="/staff/mailing">Send a Mailing</a></li>
					</xsl:if>
					<li><a href="/staff/documents">Documents</a></li>
					<li><a href="/staff/calendar">Calendar</a></li>
					<xsl:if test="$executive">
						<li><a href="/cr.php?action=adminusers;subpage=staffonly">User Admin</a></li>
						<li><a href="/cr.php?action=editions_admin">Editions Admin</a></li>
						<li><a href="/cr.php?action=thankyou_cards">Thank You Cards</a></li>
						<li><a href="/cr.php?action=announce_list">Announce List</a></li>
						<xsl:if test="$webmaster">
							<li><a href="/cr.php?action=import">Import</a></li>
						</xsl:if>
						<li><a href="https://secure.thecriticalreview.org/trac/wiki">Wiki</a></li>
					</xsl:if>
				</ul>
			</div>
		</xsl:if>

		<h2>Search</h2>

		<form action="/search" method="get">
			<div class="semester group">
				<p>
					<label><input type="checkbox" name="fall" value="1"><xsl:if test="not($search/semesters) or $search/semesters/fall"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Fall</label>
					<xsl:text> </xsl:text>
					<label><input type="checkbox" name="spring" value="1"><xsl:if test="not($search/semesters) or $search/semesters/spring"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Spring</label>
				</p>
			</div>

			<div class="group">
				<h3>Course Code</h3>
				<p><input type="text" name="course_code" value="{$search/course_code}"/></p>
			</div>

			<div class="group">
				<h3>Instructor</h3>
				<p><input type="text" name="professor" value="{$search/professor}"/></p>
			</div>

			<div class="group">
				<h3>Title</h3>
				<p><input type="text" name="title" value="{$search/title}"/></p>
			</div>

			<div class="group">
				<h3>Departments</h3>
				<div class="deptselector">
					<div class="inner">
						<xsl:for-each select="$departments/dept">
							<xsl:sort select="boolean($search/department[. = current()/@banner])" data-type="number" order="descending"/>
							<xsl:sort select="@banner"/>
							<label title="{.}">
								<input type="checkbox" name="department[]" value="{@banner}">
									<xsl:if test="$search/department[. = current()/@banner]">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<span><xsl:value-of select="@banner"/></span>
							</label>
						</xsl:for-each>
					</div>
				</div>
			</div>

			<div class="group">
				<!--
				<h3>Attributes</h3>
				-->
				<table class="attributes">
					<tr>
						<td><input type="checkbox" name="attribute_recent" value="1" id="sidebar_search_attribute_recent"><xsl:if test="$search/attributes/recent"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
						<td><label for="sidebar_search_attribute_recent">Recently reviewed</label></td>
					</tr>
					<!--
					<tr>
						<td><input type="checkbox" id="sidebar_search_attribute_small" /></td>
						<td><label for="sidebar_search_attribute_small"> Small course</label></td>
					</tr>
					<tr>
						<td><input type="checkbox" id="sidebar_search_attribute_nonconc" /></td>
						<td><label for="sidebar_search_attribute_nonconc"> Good for non-concentrators</label></td>
					</tr>
					<tr>
						<td><input type="checkbox" id="sidebar_search_attribute_excellent" /></td>
						<td><label for="sidebar_search_attribute_excellent"> Excellent rating</label></td>
					</tr>
					-->
				</table>
			</div>
			<div class="group submit">
				<p><input type="submit" value="Search"/></p>
			</div>
			<div class="group">
				<p><a href="/help/search">Search Help</a></p>
			</div>
		</form>
	</div>
</xsl:template>

<!-- Footer -->
<xsl:template name="footer">
	<div id="footer">
		<div class="columns">
			<div class="col">
				<h3>About</h3>

				<ul>
					<li><a href="/about">About</a></li>
					<li><a href="/about/bios">Staff Bios</a></li>
					<li><a href="/about/faq">FAQ</a></li>
					<li><a href="/about/history">History</a></li>
					<li><a href="/about/contact">Contact</a></li>
					<li><a href="/about/write">Write for CR</a></li>
				</ul>
			</div>
			<div class="col">
				<h3>Help</h3>

				<ul>
					<li><a href="/help">Help</a></li>
					<li><a href="/help/review">Reading a Review</a></li>
					<li><a href="/help/search">Searching</a></li>
					<li><a href="/help/instructor_names">Instructor Names</a></li>
				</ul>
			</div>
			<div class="col">
				<h3>Useful Sites</h3>

				<ul>
					<li><a rel="external" href="http://selfservice.brown.edu/menu">Banner</a></li>
					<li><a rel="external" href="http://mycourses.brown.edu/">MyCourses</a></li>
					<li><a rel="external" href="http://brown.mochacourses.com/">Mocha</a></li>
					<li><a rel="external" href="http://www.brown.edu/Administration/Dean_of_the_College/advising/">Advising</a></li>
					<li><a rel="external" href="http://www.brown.edu/web/directory/academics">Departments</a></li>
					<li><a rel="external" href="http://www.brown.edu/Administration/Registrar/calendar.html">Academic Calendar</a></li>
				</ul>
			</div>
		</div>
		<!--
		<div class="quote">
			<xsl:variable name="quote" select="document('/random_quote.php')/quote"/>
			<span class="answer">&#8220;<xsl:value-of select="$quote"/>&#8221;</span>
			<xsl:text> </xsl:text>
			<span class="tail"><a href="/quotes">More Quotes...</a></span>
		</div>
		-->
		<div class="clearer"></div>
		<xsl:if test="/cr/@https != 'yes'">
			<!-- Only show the Facebook stuff on non-HTTPS site, to avoid leaking cookies to Facebook -->
			<div class="facebook-footer">
                <iframe src="//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2FTheCriticalReview%2F&amp;width&amp;height=258&amp;colorscheme=light&amp;show_faces=true&amp;header=false&amp;stream=false&amp;show_border=true" scrolling="no" frameborder="0" style="border:none; overflow:hidden; height:258px;" allowTransparency="true"></iframe>
			</div>
		</xsl:if>
	</div>
</xsl:template>

<!-- Advisories -->
<xsl:template match="advisory">
	<p class="advisory {@type}"><xsl:value-of select="." /></p>
</xsl:template>

<xsl:template name="chrome_message">
	<div class="dept_message">
	<p>The latest version of Chrome contains a bug that prevents it from being able to display our reviews. We hope that this will fixed before the start of next semester, but until further notice, please use other browsers such as Firefox to access our website.</p>
	</div>
</xsl:template>

<xsl:template name="online_pilot_message">
	<div class="dept_message">
        <p>This course was reviewed using online questionnaires. For more information, <a href="">click here</a>.</p>
	</div>
</xsl:template>


<xsl:template name="new_scale_message">
	<div class="dept_message">
		<p>Our scoring system changed in the spring of 2014. Five now corresponds to the most positive response, and one corresponds to the most negative response.</p>
	</div>
</xsl:template>

<xsl:template name="english_dept_message">
	<div class="dept_message english">
		<p>Since Spring 2010, the English department has not accepted Critical Review questionnaires.  As a result, we are unable to review recent English courses unless the instructor explicitly requests questionnaires from us.  If you benefit from our reviews of English courses, <a href="http://www.brown.edu/Departments/English/directory/index.html">please contact the English department administration</a>.</p>
	</div>
</xsl:template>

<xsl:template name="clps_dept_message">
	<div class="dept_message clps">
		<p>In Fall 2010, the Cognitive Science (COGS) and Psychology (PSYC) departments merged to form the CLPS department.  At this time, Critical Review does not associate old COGS and PSYC reviews with newer CLPS reviews.  For reviews prior to Fall 2010, please see <a href="/PSYC">PSYC</a> and <a href="/COGS">COGS</a>. For later reviews, please see <a href="/CLPS">CLPS</a>.  Thank you for your patience and understanding as we work on merging these reviews.</p>
	</div>
</xsl:template>




<!-- Full page login form -->
<xsl:template match="login-form">
	<div id="content" class="loginform">
		<h3>CR Staff Login</h3>
		<p class="instructions">Please enter your Critical Review account credentials below.</p>
		<form action="/cr.php?{/cr/@request}" method="post" id="login_form">
			<table>
				<tr>
					<td><label>Username:</label></td>
					<td><input type="text" name="username" size="30" value="{username}"/></td>
				</tr>
				<tr>
					<td><label>Password:</label></td>
					<td><input type="password" name="password" size="30"/></td>
				</tr>
			</table>
			<p>
				<input type="submit" value="Login" /></p>
				
			<p><a href="/?action=register">Create an Account / Reset your Password</a></p>
		</form>
	</div>
</xsl:template>

<!--
	** Format a course code **
	Matches:	any element with department, course_num, and section children
	Mode:		course-code
	Params:		none
	If you have an element with department, course_num, and section children, you can apply-templates on it with mode="course-code" to get a nicely formatted course code.
-->
<xsl:template match="*" mode="course-code">
	<xsl:value-of select="concat(department, course_num, '-', section)"/>
</xsl:template>
<xsl:template match="review|review-header" mode="view-uri">
	<xsl:param name="tab"/>
	<xsl:param name="sidebar_mode"/>
	<xsl:param name="more_sidebar" select="false()"/>
	<xsl:variable name="cis-semester"><xsl:apply-templates select="@edition" mode="cis-semester"/></xsl:variable>
	<xsl:variable name="query-string">
		<xsl:if test="$tab and $tab != 'content'">
			<xsl:text>;tab=</xsl:text><xsl:value-of select="$tab"/>
		</xsl:if>
		<xsl:if test="$sidebar_mode and $sidebar_mode != 'sections'">
			<xsl:text>;sidebar=</xsl:text><xsl:value-of select="$sidebar_mode"/>
		</xsl:if>
		<xsl:if test="$more_sidebar">
			<xsl:text>;more_sidebar=yes</xsl:text>
		</xsl:if>
	</xsl:variable>
	<xsl:text>/</xsl:text><xsl:value-of select="department"/>
	<xsl:text>/</xsl:text><xsl:value-of select="course_num"/>
	<xsl:text>/</xsl:text><xsl:value-of select="$cis-semester"/>
	<xsl:text>/</xsl:text><xsl:value-of select="section"/>
	<xsl:if test="$query-string != ''">
		<xsl:text>?</xsl:text><xsl:value-of select="substring($query-string, 2)"/>
	</xsl:if>
</xsl:template>

<xsl:template match="*|@*" mode="semester-string">
	<xsl:variable name="year1" select="substring-before(string(), '.')"/>
	<xsl:variable name="year2" select="substring-before(substring-after(string(), '.'), '.')"/>
	<xsl:variable name="sem" select="substring-after(substring-after(string(), '.'), '.')"/>
	<xsl:choose>
		<xsl:when test="$sem = 1">Fall <xsl:value-of select="$year1 - 1"/></xsl:when>
		<xsl:when test="$sem = 2">Spring <xsl:value-of select="$year2 - 1"/></xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="*|@*" mode="cis-semester">
	<xsl:variable name="year1" select="substring-before(string(), '.')"/>
	<xsl:variable name="year2" select="substring-before(substring-after(string(), '.'), '.')"/>
	<xsl:variable name="sem" select="substring-after(substring-after(string(), '.'), '.')"/>
	<xsl:choose>
		<xsl:when test="$sem = 1"><xsl:value-of select="$year1 - 1"/>-Fall</xsl:when>
		<xsl:when test="$sem = 2"><xsl:value-of select="$year2 - 1"/>-Spring</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template match="*|@*" mode="banner-term">
	<xsl:variable name="year1" select="substring-before(string(), '.')"/>
	<xsl:variable name="year2" select="substring-before(substring-after(string(), '.'), '.')"/>
	<xsl:variable name="sem" select="substring-after(substring-after(string(), '.'), '.')"/>
	<xsl:value-of select="concat($year1, $sem, '0')"/>
</xsl:template>

<xsl:template match="node()" mode="instructor-last-name">
	<xsl:variable name="before-comma" select="substring-before(string(), ',')"/>
	<xsl:variable name="before-space" select="substring-before(string(), ' ')"/>
	<xsl:choose>
		<xsl:when test="$before-comma != ''"><xsl:value-of select="$before-comma"/></xsl:when>
		<xsl:when test="$before-space != ''"><xsl:value-of select="$before-space"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="string()"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	** Create an <option> element for an edition **
	Matches:	editions/edition elements
	Mode:		option
	Params:
		$selected - if present, and equal to the context edition, the <option> is selected
-->
<xsl:template match="editions/edition" mode="option">
	<xsl:param name="selected" />
	<option id="{@name}">
		<xsl:if test="$selected = @name">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:if test="@name = $next_edition">
			<xsl:attribute name="class">next</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@name"/>
	</option>
</xsl:template>

<!--
	** Create an <option> element for a department **
	Matches:	departments/dept elements
	Mode:		option
	Params:
		$selected - if present, and equal to the context department, the <option> is selected
		$full (boolean; default true) - show full department name
-->
<xsl:template match="departments/dept" mode="option">
	<xsl:param name="selected" />
	<xsl:param name="full" select="true()" />
	<option value="{@banner}" title="{.}">
		<xsl:if test="$selected = @banner">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@banner"/>
		<xsl:if test="$full">
			<xsl:text> - </xsl:text>
			<xsl:value-of select="."/>
		</xsl:if>
	</option>
</xsl:template>

<!--
	** Format a staff member's name **
	Matches:	staff/user
	Mode:		(default)
	Params:		none
	If the staff member has a real name, show that.  Otherwise, show the username.
-->
<xsl:template match="staff/user">
	<xsl:choose>
		<xsl:when test="normalize-space() != ''"> <!-- Real name specified -->
			<!--
			<xsl:value-of select="normalize-space()"/> (<xsl:value-of select="@username"/>)
			-->
			<xsl:value-of select="normalize-space()"/>
		</xsl:when>
		<xsl:otherwise> <!-- No real name specified -->
			<xsl:value-of select="@username"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
	** New course list item **
	Matches:	new_courses/course
	Mode:		li
	Params:		none
	
	Outputs a list item with a link to the given new course.
-->
<xsl:template match="new_courses/course" mode="li">
	<xsl:variable name="course_code"><xsl:apply-templates select="." mode="course-code"/></xsl:variable>
	<li>
		<xsl:value-of select="$course_code"/>: <a href="/cr.php?action=new_courses#{$course_code}"><xsl:value-of select="title"/></a><xsl:if test="professor"> (<xsl:value-of select="professor[1]"/><xsl:if test="count(professor) > 1"> et al</xsl:if>)</xsl:if>
	</li>
</xsl:template>

<xsl:template match="personal_appeal">
	<a href="/cr.php?action=personal_appeal" class="personal_appeal" style="background-image: url(/images/personal_appeal/{@img}); color: {@color};">
		<div>
			<p>Please Read:</p>
			<p><xsl:value-of select="."/></p>
		</div>
		<img src="/images/invisible.gif"/>
	</a>
</xsl:template>

<xsl:template name="facebook-big">
	<div class="facebook-big">
		<iframe src="http://www.facebook.com/plugins/likebox.php?href=http%3A%2F%2Fwww.facebook.com%2Fpages%2FThe-Critical-Review%2F131669616845036&amp;width=292&amp;colorscheme=light&amp;show_faces=true&amp;stream=true&amp;header=true&amp;height=427" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:292px; height:427px;" allowTransparency="true"></iframe>
	</div>
</xsl:template>

<xsl:template name="svgweb">
	<xsl:if test="$use_svgweb">
		<script src="/js/svgweb/svg.js" data-path="/js/svgweb/"><xsl:text> </xsl:text></script>
	</xsl:if>
</xsl:template>
<xsl:template name="svg">
	<xsl:param name="svg" select="/.."/>
	<xsl:param name="fallback" select="/.."/>
	<xsl:choose>
		<xsl:when test="$use_svgweb and $fallback">
			<xsl:copy-of select="$fallback"/>
		</xsl:when>
		<xsl:when test="$use_svgweb">
			<script type="image/svg+xml">
				<xsl:copy-of select="$svg"/>
			</script>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$svg"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Static content -->
<xsl:template match="p" mode="content">
	<p><xsl:apply-templates mode="content"/></p>
</xsl:template>
<xsl:template match="xhtml:*" mode="content">
	<xsl:element name="{local-name()}" namespace="{namespace-uri()}">
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates mode="content"/>
	</xsl:element>
</xsl:template>

<!-- XHTML content -->
<xsl:template match="xhtml-content[@src]">
	<xsl:copy-of select="document(@src)" />
</xsl:template>
<xsl:template match="xhtml-content">
	<xsl:copy-of select="xhtml:*" />
</xsl:template>
<xsl:template match="about-content">
	<xsl:call-template name="about-nav"><xsl:with-param name="current" select="@id"/></xsl:call-template>
	<xsl:copy-of select="xhtml:*" />
</xsl:template>
<xsl:template match="help-content">
	<xsl:call-template name="help-nav"><xsl:with-param name="current" select="@id"/></xsl:call-template>
	<xsl:copy-of select="xhtml:*" />
</xsl:template>

<cr:about-nav>
	<cr:page id="about" href="/about">About</cr:page>
	<cr:page id="bios" href="/about/bios">Staff Bios</cr:page>
	<cr:page id="faq" href="/about/faq">FAQ</cr:page>
	<cr:page id="history" href="/about/history">History</cr:page>
	<cr:page id="contact" href="/about/contact">Contact</cr:page>
	<cr:page id="write" href="/about/write">Write for CR</cr:page>
</cr:about-nav>

<cr:help-nav>
	<cr:page id="help" href="/help">Help</cr:page>
	<cr:page id="review" href="/help/review">Reading a Review</cr:page>
	<cr:page id="search" href="/help/search">Searching</cr:page>
	<cr:page id="instructor_names" href="/help/instructor_names">Instructor Names</cr:page>
</cr:help-nav>

<xsl:template match="cr:about-nav|cr:help-nav">
	<xsl:param name="current"/>
	<p class="content-nav">
		<xsl:for-each select="cr:page">
			<a href="{@href}">
				<xsl:if test="@id = $current"><xsl:attribute name="class">current</xsl:attribute></xsl:if>
				<xsl:value-of select="."/>
			</a>
			<xsl:if test="position() != last()"> | </xsl:if>
		</xsl:for-each>
	</p>
</xsl:template>

<xsl:template name="about-nav">
	<xsl:param name="current"/>
	<xsl:apply-templates select="document('')/xsl:stylesheet/cr:about-nav">
		<xsl:with-param name="current" select="$current"/>
	</xsl:apply-templates>
</xsl:template>
<xsl:template name="help-nav">
	<xsl:param name="current"/>
	<xsl:apply-templates select="document('')/xsl:stylesheet/cr:help-nav">
		<xsl:with-param name="current" select="$current"/>
	</xsl:apply-templates>
</xsl:template>

<!-- The page itself -->
<xsl:template match="/cr">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:call-template name="head" />
		<body>
			<!--
			<div class="downtime">
				<p>The Critical Review website will be down on Friday, April 22 between 11:50PM and 6:50AM EDT for maintenance.  We apologize for the inconvenience.</p>
			</div>
			-->
			<!--
			<div class="beta">
				<p>Welcome to the new Critical Review website.  <a href="/about/new_site">About the new site</a><xsl:text> </xsl:text><a href="/feedback">Leave feedback</a></p>
			</div>
			-->
			<xsl:if test="@guest">
				<div class="guestheader">
					<p>You are browsing the Critical Review using guest access.  Please note that guest access is intended for prospective Brown students and their families.  All other access is prohibited.</p>
				</div>
			</xsl:if>
			<div id="root">
				<xsl:call-template name="header" />
				<xsl:call-template name="sidebar" />
				<div id="main">
					<xsl:apply-templates />
				</div>
				<p class="clearer"></p>
			</div>
			<xsl:call-template name="footer" />

            <!-- Piwik -->
            <script type="text/javascript">
              var _paq = _paq || [];
              _paq.push(['trackPageView']);
              _paq.push(['enableLinkTracking']);
              (function() {
                var u="https://secure.thecriticalreview.org/cr_piwik/";
                _paq.push(['setTrackerUrl', u+'piwik.php']);
                _paq.push(['setSiteId', 1]);
                var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
                g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
              })();
            </script>
            <noscript><p><img src="https://secure.thecriticalreview.org/cr_piwik/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript>
            <!-- End Piwik Code -->

		</body>
	</html>
</xsl:template>

</xsl:stylesheet>
