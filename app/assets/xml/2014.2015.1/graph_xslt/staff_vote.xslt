<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">
	Staff Voting
	<xsl:if test="/cr/staff_vote[@mode='admin']"> Admin</xsl:if>
	- The Critical Review
</xsl:variable>
<xsl:variable name="scripts">
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_voting_mode" select="/cr/staff_vote/@mode"/>
<xsl:variable name="staff_voting_nbr_votes" select="number(/cr/staff_vote/@nbr_votes)"/>

<xsl:include href="view_common.xslt" />

<xsl:template match="staff_vote/choice">
	<xsl:param name="ballot" select="0"/>
	<div class="choice collapsed">
		<h5>
			<xsl:if test="$staff_voting_mode = 'admin'">
				<xsl:value-of select="concat(review/department,review/course_num,'-S',review/section)"/>:
			</xsl:if>
			<strong><xsl:value-of select="review/title"/></strong>
			(Course avg: <xsl:value-of select="format-number(review/tally/courseavg, '0.00')"/>,
			 Respondents: <xsl:value-of select="number(review/tally/num_respondents)"/>
			 <xsl:if test="$staff_voting_mode = 'admin'">
				 <xsl:text>, </xsl:text>Format: <xsl:value-of select="review/courseformat"/>
				 <xsl:text>, </xsl:text>Size: <xsl:value-of select="review/enrollment/total"/>
			 </xsl:if>
			 <xsl:if test="@nbr_votes">
			 	<xsl:text>, </xsl:text>Votes: <xsl:value-of select="number(@nbr_votes)"/>
			</xsl:if>)
		</h5>
		<p class="detailscommand"><a href="javascript:void(0);" onclick="toggle_class(this.parentNode.parentNode, 'collapsed');">Show/Hide Details</a></p>
		<xsl:for-each select="review[1]">
			<div class="review">
				<xsl:call-template name="review_details"/>
				<xsl:call-template name="review_text"/>
			</div>
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test="$staff_voting_mode = 'admin'">
				<p class="votecommand">
					<label>
						<input type="radio" name="is_on_staff_ballot[{review/@id}]" value="0" class="is_on_staff_ballot">
							<xsl:if test="review/is_on_staff_ballot = 0">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="onchange">
								$('nbr_courses_on_ballot1').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 1);
								$('nbr_courses_on_ballot2').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 2);
							</xsl:attribute>
						</input>
						Not on Ballot
					</label>
					<label>
						<input type="radio" name="is_on_staff_ballot[{review/@id}]" value="1" class="is_on_staff_ballot">
							<xsl:if test="review/is_on_staff_ballot = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="onchange">
								$('nbr_courses_on_ballot1').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 1);
								$('nbr_courses_on_ballot2').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 2);
							</xsl:attribute>
						</input>
						Lecture Ballot
					</label>
					<label>
						<input type="radio" name="is_on_staff_ballot[{review/@id}]" value="2" class="is_on_staff_ballot">
							<xsl:if test="review/is_on_staff_ballot = 2">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
							<xsl:attribute name="onchange">
								$('nbr_courses_on_ballot1').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 1);
								$('nbr_courses_on_ballot2').firstChild.data = count_checked_boxes_by_value(this.form, this.className, 2);
							</xsl:attribute>
						</input>
						Seminar Ballot
					</label>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="votecommand">
					<label>
						<input type="checkbox" name="vote_for_course_ballot{$ballot}[]" value="{review/@id}">
							<xsl:attribute name="onchange">
								if (count_checked_boxes(this.form, this.name) > <xsl:value-of select="$staff_voting_nbr_votes"/>) {
									this.checked = false;
									alert("You have already voted for <xsl:value-of select="$staff_voting_nbr_votes"/> courses in this division.  Please uncheck other courses if you would like to vote for this one.");
								}
								$('nbr_courses_checked_ballot<xsl:value-of select="$ballot"/>').firstChild.data = count_checked_boxes(this.form, this.name);
							</xsl:attribute>
							<xsl:if test="number(@vote_id)">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						Vote for this course!
					</label>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="staff_vote[@mode='admin']">
	<xsl:variable name="voting_user" select="voting_user"/>
	<div id="content" class="staff_vote admin">
		<h3>Staff Voting Admin</h3>

		<p><a href="/cr.php?action=staff_vote;mode=ballot">Back to ballot</a></p>

		<form action="/cr.php?action=staff_vote;mode=admin" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<xsl:apply-templates select="choice">
				<xsl:sort select="number(review/is_on_staff_ballot)" order="descending" data-type="number"/>
				<xsl:sort select="@nbr_votes" order="descending" data-type="number"/>
			</xsl:apply-templates>

			<p>
				<span id="nbr_courses_on_ballot1"><xsl:value-of select="count(choice[review/is_on_staff_ballot = 1])"/></span> courses on Lecture Ballot.<br/>
				<span id="nbr_courses_on_ballot2"><xsl:value-of select="count(choice[review/is_on_staff_ballot = 2])"/></span> courses on Seminar Ballot.
			</p>

			<p><input type="submit" name="submitbtn" value="Submit"/></p>
		</form>

		<h4>Voting Writers</h4>

		<ul>
			<xsl:for-each select="voting_user">
				<li><xsl:apply-templates select="/cr/staff/user[@uid = current()]"/></li>
			</xsl:for-each>
		</ul>

		<h4>Non-voting Writers</h4>

		<ul>
			<xsl:for-each select="/cr/staff/user">
				<xsl:if test="not($voting_user[. = current()/@uid])">
					<li><xsl:apply-templates select="."/></li>
				</xsl:if>
			</xsl:for-each>
		</ul>
	</div>
</xsl:template>

<xsl:template match="staff_vote[@mode='ballot']">
	<div id="content" class="staff_vote">
		<h3>Vote for the Best Course!</h3>

		<xsl:if test="$executive"><p><a href="/cr.php?action=staff_vote;mode=admin">Admin</a></p></xsl:if>

		<xsl:choose>

		<xsl:when test="choice">
			<p class="instructions">These are the highest rated courses this semester.  Read the reviews below and choose the <xsl:value-of select="@nbr_votes"/> classes that you feel are the best.  The five courses that receive the most votes will be featured prominently during pre-registration period.  Choose wisely!</p>

			<form action="/cr.php?action=staff_vote;mode=ballot" method="post">
				<xsl:copy-of select="$csrf_token_input"/>
				<h4>Division One: Lecture Courses</h4>
				<xsl:apply-templates select="choice[@ballot = 1]">
					<xsl:sort select="review/department_code"/>
					<xsl:sort select="review/course_num"/>
					<xsl:sort select="review/section"/>
					<xsl:with-param name="ballot" select="1"/>
				</xsl:apply-templates>

				<p>You have voted for <span id="nbr_courses_checked_ballot1"><xsl:value-of select="count(choice[boolean(number(@vote_id)) and @ballot = 1])"/></span> course(s) in this division.  You may vote for up to <xsl:value-of select="@nbr_votes"/> courses per division.</p>

				<h4>Division Two: Seminar Courses</h4>
				<xsl:apply-templates select="choice[@ballot = 2]">
					<xsl:sort select="review/department_code"/>
					<xsl:sort select="review/course_num"/>
					<xsl:sort select="review/section"/>
					<xsl:with-param name="ballot" select="2"/>
				</xsl:apply-templates>

				<p>You have voted for <span id="nbr_courses_checked_ballot2"><xsl:value-of select="count(choice[boolean(number(@vote_id)) and @ballot = 2])"/></span> course(s) in this division.  You may vote for up to <xsl:value-of select="@nbr_votes"/> courses per division.</p>

				<p><input type="submit" name="submitbtn" value="Cast my votes!"/></p>
			</form>
		</xsl:when>
		<xsl:otherwise>
			<p><strong>Voting not yet open - check back soon!</strong></p>
		</xsl:otherwise>
		</xsl:choose>
	</div>
</xsl:template>

</xsl:stylesheet>
