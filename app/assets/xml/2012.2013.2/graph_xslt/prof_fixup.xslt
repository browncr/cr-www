<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />

<xsl:variable name="title">Professor Name Fixup</xsl:variable>
<xsl:variable name="scripts">
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/prof_fixup.js"><xsl:text> </xsl:text></script>
</xsl:variable>

<xsl:key name="profs" match="/cr/prof_fixup/prof" use="name"/>
<xsl:key name="profs-by-id" match="/cr/prof_fixup/prof" use="@id"/>

<xsl:template match="*" mode="search-links" name="search-links">
	<xsl:param name="name" select="string()"/>
	<span class="search-links">
		<a target="_blank" href="http://www.google.com/custom?cx=001311030293454891064%3Alwlrsw9qt3o&amp;cof=AH%3Aleft%3BCX%3ABrown%2520University%3BDIV%3A%23cccccc%3BFORID%3A0%3BGFNT%3A%23666666%3BL%3Ahttp%3A%2F%2Fwww.brown.edu%2Fweb%2Fimages%2Flogo-google.png%3BLH%3A62%3BLP%3A1%3BS%3Ahttp%3A%2F%2Fwww.brown.edu%3B&amp;sa=Search&amp;adkw=AELymgV98XGptaxgQz8QMzbrsTkr9Q6zD79XkedFx89TIEigtoPIm-SZElXD7gsdgtpEBQq-bwMyCpalm86scS4R9yuc_wY9sc6W4sr9REp_ia7QNwmYXBD_z_XiGM-1ighiFJjX99MH&amp;hl=en&amp;client=google-coop-np&amp;query={$name}"><img src="/images/prof_fixup/google.png" alt="Google" title="Search for '{$name}' on Google"/></a>
		<xsl:text> </xsl:text>
		<a target="_blank" href="http://directory.brown.edu/search?search_string={$name}"><img src="/images/prof_fixup/brown.png" alt="Brown" title="Search for '{$name}' in the Brown Directory"/></a>
		<xsl:text> </xsl:text>
		<a target="_blank" href="http://www.thecriticalreview.org/cr_xml.php?action=browse;quicksearch={$name}"><img src="/images/prof_fixup/cr.png" alt="CR" title="Search for '{$name}' in Critical Review"/></a>
	</span>
</xsl:template>

<xsl:template match="prof_fixup//prof" mode="course-label">
	<xsl:param name="prof" />
	<xsl:param name="choices" />
	<xsl:choose>
		<xsl:when test="preceding-sibling::prof[name = current()/name and department = current()/department and course_num = current()/course_num]"/>
		<xsl:otherwise>
			<span class="course-label">
				<span>
					<xsl:if test="department = $prof/department"><xsl:attribute name="class">match</xsl:attribute></xsl:if>
					<xsl:value-of select="department"/>
				</span>
				<span>
					<xsl:if test="department = $prof/department and course_num = $prof/course_num"><xsl:attribute name="class">match</xsl:attribute></xsl:if>
					<xsl:value-of select="course_num"/>
				</span>
				<span> (<xsl:value-of select="sum($choices[name = current()/name and department = current()/department and course_num = current()/course_num]/count)"/>)</span>
			</span>
			<xsl:text> </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="prof_fixup//prof" mode="choice">
	<xsl:param name="mode" />
	<xsl:param name="prof" />
	<xsl:param name="choices" />
	<xsl:choose>
		<xsl:when test="$mode = 'fixed' and preceding-sibling::prof[@status > 0 and name=current()/name and department=current()/department]"/>
		<xsl:when test="$mode = 'not-fixed' and preceding-sibling::prof[@status &lt;= 0 and @id != $prof/@id and name=current()/name and department=current()/department]"/>
		<xsl:otherwise>
			<xsl:variable name="input-id" select="concat(generate-id($prof), '-', $mode, '-', generate-id())"/>
			<xsl:variable name="group-members" select="$choices[name=current()/name and department=current()/department]"/>
			<tr>
				<td>
					<xsl:choose>
						<xsl:when test="$mode = 'fixed'">
							<input id="{$input-id}" type="radio" name="rename[{number($prof/@id)}]" value="{name}" onclick="$('{generate-id($prof)}-manual').disabled = true" />
						</xsl:when>
						<xsl:when test="$mode = 'not-fixed'">
							<input id="{$input-id}" type="checkbox" name="samename-{number($prof/@id)}[]">
								<xsl:attribute name="value">
									<xsl:for-each select="$group-members">
										<xsl:value-of select="number(@id)"/>
										<xsl:if test="position() != last()">,</xsl:if>
									</xsl:for-each>
								</xsl:attribute>
								<xsl:attribute name="onclick">
									<xsl:for-each select="key('profs-by-id', $group-members/@id)">
										toggle_prof_block($('<xsl:value-of select="generate-id()"/>-block'), !this.checked);
									</xsl:for-each>
								</xsl:attribute>
							</input>
						</xsl:when>
					</xsl:choose>
				</td>
				<td>
					<xsl:apply-templates select="name" mode="search-links"/>
				</td>
				<td>
					<xsl:attribute name="class">
						<xsl:if test="@status >= 2">verified</xsl:if>
						<xsl:text> </xsl:text>
						<xsl:if test="parent::similar">similar</xsl:if>
					</xsl:attribute>
					<label for="{$input-id}">
						<xsl:value-of select="name"/>
					</label>
				</td>
				<td>
					<xsl:apply-templates select="$group-members" mode="course-label">
						<xsl:with-param name="prof" select="$prof"/>
						<xsl:with-param name="choices" select="$choices"/>

						<xsl:sort select="department = $prof/department and course_num = $prof/course_num" data-type="number" order="descending"/>
						<xsl:sort select="count" data-type="number" order="descending"/>
					</xsl:apply-templates>
				</td>
			</tr>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="choices">
	<xsl:param name="choices"/>
	<xsl:param name="mode"/>
	<xsl:param name="prof"/>

	<xsl:apply-templates select="$choices" mode="choice">
		<!--
			First, we want profs with similar names and who have taught this course
			before.  Sort in decending order of number of times taught this course
		-->
		<xsl:sort select="$choices[parent::similar and current()/parent::similar and name = current()/name and department = $prof/department and course_num = $prof/course_num]/count" data-type="number" order="descending"/>
		<!--
			Next, we want profs with similar names who have NOT taught the course
			before, but are in the same department.  Sort in descending order of
			number of times taught in this department
		-->
		<xsl:sort select="sum(self::*[parent::similar and department = $prof/department]/../prof[name = current()/name and department = $prof/department]/count)" data-type="number" order="descending"/>

		<!--
			Next, we want profs with non-similar names who have taught this course
			before.  Sort in descending order of # of times taught this course
		-->
		<xsl:sort select="self::*[parent::same_course]/count" data-type="number" order="descending"/>

		<!--
			To break ties, sort by status
		-->
		<xsl:sort select="@status" data-type="number" order="descending"/>

		<xsl:with-param name="mode" select="$mode"/>
		<xsl:with-param name="prof" select="$prof"/>
		<xsl:with-param name="choices" select="$choices"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="prof_fixup/prof">
	<xsl:variable name="choices" select="similar/prof[@status > 0]|same_course/prof[@status > 0]"/>
	<xsl:variable name="same-name" select="similar/prof[@status &lt;= 0 and @id != current()/@id]"/>
	<!--
	<xsl:variable name="same-name" select="similar/prof[@status &lt;= 0 and not(name = current()/name and department=current()/department)]"/>
	-->
	<div class="course" id="{generate-id()}-block">
		<h5>
			<strong><xsl:value-of select="concat(department,course_num)"/></strong>
			<xsl:text> </xsl:text>
			<span class="count">
				Taught <xsl:value-of select="count"/> times:
				<xsl:for-each select="title">
					<a href="http://www.thecriticalreview.org/cr_xml.php?action=view;id={@id}">
						<xsl:value-of select="/cr/editions/edition[@name=current()/@edition]"/>
					</a>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
			</span>
			<br/>
			<xsl:value-of select="title[1]"/>
		</h5>

		<p>Rename to:</p>

		<table class="choices">
			<xsl:call-template name="choices">
				<xsl:with-param name="choices" select="$choices"/>
				<xsl:with-param name="prof" select="."/>
				<xsl:with-param name="mode">fixed</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="proposal and not($choices[name = current()/proposal])">
				<tr>
					<td>
						<input id="{generate-id()}-proposal" type="radio" name="rename[{number(@id)}]" value="{proposal}" onclick="$('{generate-id()}-manual').disabled = true"/>
					</td>
					<td>
						<xsl:apply-templates select="proposal" mode="search-links"/>
					</td>
					<td>
						<xsl:if test="proposal/@verified = 'yes'">
							<xsl:attribute name="class">verified</xsl:attribute>
						</xsl:if>
						<label for="{generate-id()}-proposal">
							<xsl:value-of select="proposal" />
						</label>
					</td>
					<td>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td>
					<input type="radio" name="rename[{number(@id)}]" value="_MANUAL" onclick="$('{generate-id()}-manual').disabled = false"/>
				</td>
				<td colspan="3">
					<input disabled="disabled" id="{generate-id()}-manual" type="text" name="manual_rename-{number(@id)}" size="40" value="{name}"/>
				</td>
			</tr>
			<tr>
				<td>
					<input id="{generate-id()}-multiple" type="radio" name="rename[{number(@id)}]" value="_MULTIPLE" onclick="$('{generate-id()}-manual').disabled = true"/>
				</td>
				<td colspan="3">
					<label for="{generate-id()}-multiple">
						Multiple Professors
					</label>
				</td>
			</tr>
			<tr>
				<td>
					<input id="{generate-id()}-cantfix" type="radio" name="rename[{number(@id)}]" value="_CANTFIX" onclick="$('{generate-id()}-manual').disabled = true"/>
				</td>
				<td colspan="3">
					<label for="{generate-id()}-cantfix">
						Can't Fix
					</label>
				</td>
			</tr>
			<tr>
				<td>
					<input id="{generate-id()}-defer" checked="checked" type="radio" name="rename[{number(@id)}]" value="_DEFER" onclick="$('{generate-id()}-manual').disabled = true"/>
				</td>
				<td colspan="3">
					<label for="{generate-id()}-defer">
						Defer
					</label>
				</td>
			</tr>
		</table>

		<xsl:if test="$same-name">
			<p>Same Name:</p>

			<table class="same-name">
				<xsl:call-template name="choices">
					<xsl:with-param name="choices" select="$same-name"/>
					<xsl:with-param name="prof" select="."/>
					<xsl:with-param name="mode">not-fixed</xsl:with-param>
				</xsl:call-template>
			</table>
		</xsl:if>
	</div>
</xsl:template>
<xsl:template match="prof_fixup/prof" mode="group">
	<div class="prof">
		<h4>
			<xsl:value-of select="name" />
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="name" mode="search-links"/>
		</h4>

		<xsl:apply-templates select="../prof[name = current()/name]">
			<xsl:sort select="department"/>
			<xsl:sort select="count" data-type="number"/>
		</xsl:apply-templates>
	</div>
</xsl:template>

<xsl:template match="prof_fixup">
	<div id="content" class="prof-fixup">
		<h3><xsl:value-of select="$title"/></h3>

		<form action="#" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<xsl:apply-templates select="prof[generate-id(.) = generate-id(key('profs', name)[1])]" mode="group">
				<xsl:sort select="name"/>
			</xsl:apply-templates>

			<p class="buttons"><input type="submit" name="submitbtn" value="Submit"/></p>
		</form>
	</div>
</xsl:template>

</xsl:stylesheet>
