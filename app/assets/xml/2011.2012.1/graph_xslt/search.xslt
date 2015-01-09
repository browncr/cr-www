<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Search Results - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/search.css" />
</xsl:variable>

<xsl:variable name="params" select="/cr/search/params"/>

<!-- A key to easily access reviews that were returned as search results -->
<xsl:key name="reviews-by-department" match="/cr/search/results/review-header" use="department" />
<xsl:key name="reviews-by-professor" match="/cr/search/results/review-header" use="professor" />

<xsl:template name="search-uri">
	<xsl:param name="course_code" select="$params/course_code"/>
	<xsl:param name="professor" select="$params/professor"/>
	<xsl:param name="title" select="$params/title"/>
	<xsl:param name="department" select="$params/department"/>
	<xsl:param name="sort" select="$params/sort"/>
	<xsl:param name="fall" select="boolean($params/semesters/fall)"/>
	<xsl:param name="spring" select="boolean($params/semesters/spring)"/>
	<xsl:param name="attribute-recent" select="boolean($params/attributes/recent)"/>
	<xsl:variable name="query">
		<xsl:if test="$course_code != ''">;course_code=<xsl:value-of select="$course_code"/></xsl:if>
		<xsl:if test="$professor != ''">;professor=<xsl:value-of select="$professor"/></xsl:if>
		<xsl:if test="$title != ''">;title=<xsl:value-of select="$title"/></xsl:if>
		<xsl:for-each select="$department">
			<xsl:text>;department=</xsl:text><xsl:value-of select="."/>
		</xsl:for-each>
		<xsl:if test="$sort != ''">;sort=<xsl:value-of select="$sort"/></xsl:if>
		<xsl:if test="$fall">;fall=1</xsl:if>
		<xsl:if test="$spring">;spring=1</xsl:if>
		<xsl:if test="$attribute-recent">;attribute_recent=1</xsl:if>
	</xsl:variable>
	<xsl:text>/search</xsl:text>
	<xsl:if test="$query != ''">
		<xsl:text>?</xsl:text><xsl:value-of select="substring($query, 2)"/>
	</xsl:if>
</xsl:template>

<xsl:variable name="search" select="/cr/search/params"/>
<xsl:template match="search[not(results)]">
    <div id="content">
        <h3>Search by course or department code</h3>

		<form action="/search" method="get" id="full-search">

            <p>You can search by entering the code of the department(s) or the specific course you are interested in.</p>
            <p class="search-example">For example: "CSCI", "CSCI, MATH, APMA", "CS31"</p>
            <p><input type="text" name="course_code" placeholder="Course code" value="{$search/course_code}"/></p>
            <p><input type="submit" value="Search" /></p>

            <h3>Search by instructor name, course title, and/or department</h3>
            <p>You can use any combination of the below fields to search.</p>

            <h4>Semester offered</h4>
            <p>
                <label><input type="checkbox" name="fall" value="1"><xsl:if test="not($search/semesters) or $search/semesters/fall"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Include Fall courses</label>
                <xsl:text> </xsl:text>
                <label><input type="checkbox" name="spring" value="1"><xsl:if test="not($search/semesters) or $search/semesters/spring"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Include Spring courses</label>
            </p>
            <h4>Instructor</h4>
            <p>You can search by the last name, or the last and first name, of the professor.</p>
            <p class="search-example">For example: "Carberry", "Carberry, Josiah"</p>
            <p><input type="text" name="professor" placeholder="Instructor" value="{$search/professor}"/></p>

            <h4>Title</h4>
            <p>You can search by entering the full or partial title of the course.</p>
            <p class="search-example">For example: "Introduction to Psychoceramics", "psychoceramics"</p>
            <p><input type="text" name="title" placeholder="Title" value="{$search/title}"/></p>

            <h4>Departments</h4>
            <p>You can limit your search by choosing one or multiple departments.</p>
            <ul class="departments">
                <xsl:for-each select="$departments/dept">
                    <xsl:sort select="boolean($search/department[. = current()/@banner])" data-type="number" order="descending"/>
                    <xsl:sort select="@banner"/>
                    <li>
                        <label title="{.}">
                            <input type="checkbox" name="department[]" value="{@banner}">
                                <xsl:if test="$search/department[. = current()/@banner]">
                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                </xsl:if>
                            </input>
                            <span><xsl:value-of select="."/> (<xsl:value-of select="@banner"/>)</span>
                        </label>
                    </li>
                    </xsl:for-each>
            </ul>
            <p class="clearer"></p>

            <h4>Attributes</h4>
            <p>You can limit your search to courses that have been reviewed in the past 4 years.</p>
            <input type="checkbox" name="attribute_recent" value="1" id="sidebar_search_attribute_recent"><xsl:if test="$search/attributes/recent"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input>
            <xsl:text> </xsl:text>
            <label for="sidebar_search_attribute_recent">Recently reviewed</label>


            <div class="group submit">
                <p><input type="submit" value="Search"/></p>
            </div>
        </form>
    </div>
</xsl:template>

<xsl:template match="search[results]">
	<!-- <xsl:if test="params/department[. = 'ENGL']">
		<xsl:call-template name="english_dept_message"/>
	</xsl:if> -->
	<xsl:if test="params/department[. = 'CLPS' or . = 'PSYC' or . = 'COGS']">
		<xsl:call-template name="clps_dept_message"/>
	</xsl:if>
	<xsl:apply-templates select="professor-similar-names"/>
	<xsl:apply-templates select="results"/>
</xsl:template>

<xsl:template match="search/professor-similar-names/name">
	<a>
		<xsl:attribute name="href">
			<xsl:call-template name="search-uri">
				<xsl:with-param name="professor" select="."/>
			</xsl:call-template>
		</xsl:attribute>
		<xsl:value-of select="."/>
	</a>
</xsl:template>

<xsl:template match="search/professor-similar-names">
	<xsl:variable name="names" select="name[key('reviews-by-professor', string())]"/>
	<xsl:choose>
		<xsl:when test="count($names) = 1">
			<div class="professor-similar-names">
				<p>Did you mean <xsl:apply-templates select="$names[1]"/>?</p>
			</div>
		</xsl:when>
		<xsl:when test="count($names) &gt; 1">
			<div class="professor-similar-names">
				<p>Found <xsl:value-of select="count($names)"/> professors with similar names:</p>
				<ul>
					<xsl:for-each select="$names">
						<xsl:sort select="."/>
						<li><xsl:apply-templates select="."/></li>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="search-result-th">
	<xsl:param name="sort"/>
	<xsl:param name="title"/>
	<th>
		<a>
			<xsl:attribute name="href">
				<xsl:call-template name="search-uri">
					<xsl:with-param name="sort" select="$sort"/>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:copy-of select="$title"/>
		</a>
	</th>
</xsl:template>

<xsl:template match="search/results">
	<div id="content" class="search">
		<h3>Search Results</h3>

		<table class="results">
			<thead>
				<tr>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">coursecode</xsl:with-param>
						<xsl:with-param name="title">Course Code</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">title</xsl:with-param>
						<xsl:with-param name="title">Title</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">professor</xsl:with-param>
						<xsl:with-param name="title">Professor</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">enrollment</xsl:with-param>
						<xsl:with-param name="title">Size</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">profavg</xsl:with-param>
						<xsl:with-param name="title"><abbr title="Professor Average">P. Avg</abbr></xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">courseavg</xsl:with-param>
						<xsl:with-param name="title"><abbr title="Course Average">C. Avg</abbr></xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="search-result-th">
						<xsl:with-param name="sort">edition</xsl:with-param>
						<xsl:with-param name="title">Last Review</xsl:with-param>
					</xsl:call-template>
					<!--
					<th>CRN</th>
					-->
				</tr>
			</thead>

			<tbody>
				<xsl:choose>
					<xsl:when test="$params/sort = 'title'">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="title"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$params/sort = 'professor'">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="professor"/>
							<xsl:sort order="ascending" select="department"/>
							<xsl:sort order="ascending" select="course_num"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$params/sort = 'enrollment'">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="descending" select="enrollment != 0" data-type="number"/>
							<xsl:sort order="ascending" select="enrollment" data-type="number"/>
							<xsl:sort order="ascending" select="department"/>
							<xsl:sort order="ascending" select="course_num"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$params/sort = 'profavg'">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="not(number(@active)) or number(insufficient) or number(unreturned)" data-type="number"/> <!-- Sort incomplete reviews to the bottom -->
							<xsl:sort order="ascending" select="profavg" data-type="number"/>
							<xsl:sort order="ascending" select="department"/>
							<xsl:sort order="ascending" select="course_num"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$params/sort = 'courseavg'">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="not(number(@active)) or number(insufficient) or number(unreturned)" data-type="number"/> <!-- Sort incomplete reviews to the bottom -->
							<xsl:sort order="ascending" select="courseavg" data-type="number"/>
							<xsl:sort order="ascending" select="department"/>
							<xsl:sort order="ascending" select="course_num"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="$params/sort = 'edition' or (not($params/sort) and number(@all-reviews))">
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="not(number(@active)) or number(insufficient) or number(unreturned)" data-type="number"/> <!-- Sort incomplete reviews to the bottom -->
							<xsl:sort order="descending" select="@edition"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="review-header" mode="tabular">
							<xsl:sort order="ascending" select="department"/>
							<xsl:sort order="ascending" select="course_num"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</div>
</xsl:template>

<xsl:template match="profavg[number() = 0]|courseavg[number() = 0]" priority="10"></xsl:template>
<xsl:template match="profavg|courseavg" priority="9"><xsl:value-of select="format-number(number(), '#.##')"/></xsl:template>
<xsl:template match="review-header" mode="tabular">
	<xsl:variable name="view-uri"><xsl:apply-templates select="." mode="view-uri"/></xsl:variable>
	<tr>
		<xsl:attribute name="class">
			<xsl:if test="position() mod 2 = 0">odd</xsl:if>
			<xsl:if test="not(number(@active)) or number(insufficient) or number(unreturned)">
				<!-- Not yet published, insufficient information, or unreturned -->
				incomplete
			</xsl:if>
		</xsl:attribute>

		<td><a href="{$view-uri}"><xsl:value-of select="concat(department,course_num)"/></a></td>
		<td>
			<xsl:if test="featured_date != ''">
				<span title="Featured Course" class="featured">&#9733;</span> <!-- 9733 = star symbol -->
			</xsl:if>
			<a href="{$view-uri}"><xsl:value-of select="title"/></a>
		</td>
		<td><xsl:value-of select="professor"/></td>
		<td class="num"><xsl:if test="number(enrollment)"><xsl:value-of select="enrollment"/></xsl:if></td>
		<xsl:choose>
			<xsl:when test="num_respondents &gt;= $tally-min-respondents">
				<td class="num"><xsl:apply-templates select="profavg"/></td>
				<td class="num"><xsl:apply-templates select="courseavg"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td></td>
				<td></td>
			</xsl:otherwise>
		</xsl:choose>
		<td class="edition"><xsl:value-of select="$editions/edition[@name=current()/@edition]"/></td>
		<!--
 		<td><xsl:if test="number(crn)"><xsl:value-of select="crn"/></xsl:if></td>
		-->
	</tr>
</xsl:template>

</xsl:stylesheet>
