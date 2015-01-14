<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:import href="view_common.xslt" />

<xsl:variable name="edit_mode" select="/cr/edit_reviews/@show"/>
<xsl:variable name="edit_query">
	<xsl:apply-templates select="/cr/edit_reviews" mode="query"/>
</xsl:variable>
<xsl:variable name="title">
	<xsl:choose>
		<xsl:when test="/cr/edit_reviews/edit/@new">New Review</xsl:when>
		<xsl:when test="/cr/edit_reviews/edit">Edit Review: <xsl:apply-templates select="/cr/edit_reviews/edit/review" mode="course-code"/></xsl:when>
		<xsl:when test="/cr/edit_reviews/list">Edit Reviews</xsl:when>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/edit.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/edit.js"><xsl:text> </xsl:text></script>

	<xsl:if test="$edit_mode = 'barcode'">
		<script type="text/javascript" src="/assets/{$assets_version}/js/barcode.js"><xsl:text> </xsl:text></script>
	</xsl:if>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:variable name="sufficient_word_count" select="250"/>

<xsl:attribute-set name="section_head">
	<xsl:attribute name="class">section_head</xsl:attribute>
	<xsl:attribute name="onclick">
		toggle_class(this.parentNode, "collapsed");
	</xsl:attribute>
	<xsl:attribute name="title">Click to expand/collapse</xsl:attribute>
</xsl:attribute-set>


<xsl:template name="instruct">
	<!--
	<p class="instructions">This is the new editor's interface.  Please direct all questions, problems, and suggestions to <a href="mailto:andrew_ayer@brown.edu">Andrew</a> or <a href="mailto:criticalreview@abclee.com">Brian</a>.  Thanks, Andrew+Brian.</p>
	-->
</xsl:template>


<xsl:template match="staff/user" mode="option">
	<xsl:param name="selected"/>
	<xsl:param name="show_stats"/>
	<option value="{@uid}">
		<xsl:if test="$selected = @uid">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:if test="$show_stats = 'writing' and number(@needs_editor)">
			<xsl:attribute name="class">needs_editor</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates select="."/>
		<xsl:choose>
			<xsl:when test="$show_stats = 'writing'"> (<xsl:value-of select="@writing_count"/>)</xsl:when>
			<xsl:when test="$show_stats = 'editing'"> (<xsl:value-of select="@editing_count"/> / <xsl:value-of select="@writer_count"/>)</xsl:when>
		</xsl:choose>
	</option>
</xsl:template>

<xsl:template match="*" mode="staff_username">
	<xsl:variable name="username" select="normalize-space(.)"/>
	<xsl:variable name="user_info" select="/cr/staff/user[@username = $username]"/>
	<xsl:choose>
		<xsl:when test="$user_info">
			<!-- There was a node for this user in the staff XML - use it -->
			<xsl:apply-templates select="$user_info"/>
		</xsl:when>
		<xsl:otherwise>
			<!-- No node present for this user in the staff XML - just show the username -->
			<xsl:value-of select="$username"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="active[number()]">Yes</xsl:template>
<xsl:template match="active[not(number())]">No</xsl:template>

<xsl:template match="review-header">
	<xsl:variable name="assigned" select="writer_id >= 0"/>
	<tr>
		<xsl:if test="number(barcode_id)">
			<xsl:attribute name="id">review_barcode_id_<xsl:value-of select="number(barcode_id)"/></xsl:attribute>
		</xsl:if>
		<!--________________ CSS classes __________________-->
		<xsl:if test="not(number(active))">
			<!-- Inactive (unpublished) review -->
			<xsl:attribute name="class">inactive</xsl:attribute>
		</xsl:if>
		<xsl:if test="not(number(insufficient)) and number(word-count) &lt; $sufficient_word_count">
			<!-- Deficient (fewer than $sufficient_word_count words) review -->
			<xsl:attribute name="class">deficient</xsl:attribute>
		</xsl:if>
		<xsl:if test="not(number(insufficient)) and not(number(active)) and not($assigned)">
			<!-- Unassigned review -->
			<xsl:attribute name="class">unassigned</xsl:attribute>
		</xsl:if>
		<xsl:if test="boolean(number(flagged))">
			<!-- Flagged review -->
			<xsl:attribute name="class">flagged</xsl:attribute>
		</xsl:if>
		<!--______________ End CSS classes ________________-->

		<td> <!-- Writer -->
			<xsl:if test="writer_id = /cr/user/uid">
				<!-- My review -->
				<xsl:attribute name="class">me</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="writer_username" mode="staff_username"/>
		</td>
		<td> <!-- Editor -->
			<xsl:if test="$assigned or editor_id >= 0">
				<xsl:if test="editor_id = /cr/user/uid">
					<!-- My review -->
					<xsl:attribute name="class">me</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(number(insufficient)) and editor_id = -1">
					<xsl:attribute name="class">deficient</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="editor_username" mode="staff_username"/>
			</xsl:if>
		</td>
		<xsl:if test="$executive">
			<td> <!-- Executive editors -->
				<xsl:if test="exec_id1 = /cr/user/uid or exec_id2 = /cr/user/uid">
					<!-- My review -->
					<xsl:attribute name="class">me</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="exec_username1" />
				<xsl:text>, </xsl:text>
				<xsl:value-of select="exec_username2" />
			</td>
		</xsl:if>
		<td><a href="/cr.php?{$edit_query};dept={department};course={course_num};section={section}"><xsl:apply-templates select="." mode="course-code"/></a></td>
		<td>
			<xsl:if test="$assigned">
				<xsl:if test="not(number(insufficient)) and number(num_respondents) = 0">
					<xsl:attribute name="class">deficient</xsl:attribute>
				</xsl:if>
				<a href="/cr.php?action=tally;id={@id}" onclick="window.open(this.href, '_blank', 'menubar=no,resizable=yes,toolbar=no,location=no,status=no,scrollbars=yes,resizable=yes,fullscreen=yes'); return false;">Tally</a>
			</xsl:if>
		</td>
		<td><xsl:value-of select="modified"/> by <xsl:apply-templates select="modifier" mode="staff_username"/></td>
		<td>
			<xsl:if test="not(number(insufficient)) and number(word-count) &gt;= $sufficient_word_count and normalize-space(editors) = ''">
				<xsl:attribute name="class">deficient</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="editors"/>
		</td>
		<xsl:if test="$executive">
			<td><xsl:value-of select="edit_distance"/></td>
		</xsl:if>
		<td><xsl:apply-templates select="active"/></td>
		<xsl:if test="$executive">
			<td class="batch"><input type="checkbox" name="review_id[]" value="{@id}" onclick="edit_list_checkbox_clicked(this, {enrollment});"/></td>
		</xsl:if>
	</tr>
</xsl:template>

<xsl:template match="barcode_id[number() = 0]" mode="serial">None</xsl:template>
<xsl:template match="review-header" mode="print_mode">
	<tr>
		<xsl:if test="number(barcode_id)">
			<xsl:attribute name="id">review_barcode_id_<xsl:value-of select="number(barcode_id)"/></xsl:attribute>
		</xsl:if>
		<td><xsl:apply-templates select="barcode_id" mode="serial"/></td>
		<td><a href="/cr.php?{$edit_query};dept={department};course={course_num};section={section}"><xsl:apply-templates select="." mode="course-code"/></a></td>
		<td><xsl:value-of select="title"/></td>
		<td><xsl:value-of select="professor"/></td>
		<td><xsl:value-of select="enrollment"/></td>
		<td><xsl:value-of select="survey_printer"/></td>
		<td>
			<xsl:choose>
				<xsl:when test="survey_spooled = 1">Yes</xsl:when>
				<xsl:when test="survey_spooled = 0">No</xsl:when>
			</xsl:choose>
		</td>
		<td class="batch"><input type="checkbox" name="review_id[]" value="{@id}" onclick="edit_list_checkbox_clicked(this, {enrollment});"/></td>
	</tr>
</xsl:template>

<xsl:template match="edit_reviews" mode="query">
	<xsl:text>action=edit</xsl:text>
	<xsl:text>;show=</xsl:text><xsl:value-of select="@show"/>
	<xsl:text>;edition=</xsl:text><xsl:value-of select="@edition"/>
	<xsl:if test="@show = 'mine'">
		<xsl:text>;mine_writing=</xsl:text><xsl:value-of select="number(@mine_writing)"/>
		<xsl:text>;mine_editing=</xsl:text><xsl:value-of select="number(@mine_editing)"/>
		<xsl:text>;mine_deficient=</xsl:text><xsl:value-of select="number(@mine_deficient)"/>
	</xsl:if>
	<xsl:if test="@show = 'all'">
		<xsl:text>;filter_writer=</xsl:text><xsl:value-of select="@filter_writer"/>
		<xsl:text>;filter_editor=</xsl:text><xsl:value-of select="@filter_editor"/>
		<xsl:text>;filter_department=</xsl:text><xsl:value-of select="@filter_department"/>
		<xsl:text>;filter_status=</xsl:text><xsl:value-of select="@filter_status"/>
	</xsl:if>
</xsl:template>
	
<xsl:template match="edit_reviews/list">
	<xsl:variable name="deficient_only" select="../@show = 'all' and ../@filter_status = 'deficient' or ../@show = 'mine' and ../@mine_deficient = 1"/>
	<xsl:variable name="reviews" select="review-header[
			not($deficient_only) or (not(number(insufficient)) and (word-count &lt; $sufficient_word_count or num_respondents = 0))
		]"/>
	<div id="content" class="edit_reviews_list {$edit_mode}">
		<h3>Edit Reviews</h3>

		<xsl:call-template name="instruct"/>

        <!-- <xsl:if test="$chief"> -->
			<form method="get" action="/cr.php">
				<p>
					<!-- TODO: preserve all the filter settings when switching editions -->
					<input type="hidden" name="action" value="edit"/>
					<input type="hidden" name="show" value="{../@show}"/>
					Edition:
					<select name="edition" class="edition" size="1" onchange="this.form.submit();">
						<xsl:apply-templates select="/cr/editions/edition" mode="option">
							<xsl:sort select="@name" order="descending"/>
							<xsl:with-param name="selected" select="../@edition"/>
						</xsl:apply-templates>
					</select>

					<input type="submit" name="select_edition" value="Go"/>
				</p>
			</form>
        <!-- </xsl:if> -->

		<xsl:if test="/cr/user/level &gt;= 3">
			<p>
				<a href="/cr.php?action=edit;edition={../@edition};show=mine">
					<xsl:if test="../@show = 'mine'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
					<xsl:text>My Reviews</xsl:text>
				</a>
				| 
				<a href="/cr.php?action=edit;edition={../@edition};show=all;filter_status=assigned">
					<xsl:if test="../@show = 'all'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
					<xsl:text>All Reviews</xsl:text>
				</a>
				<xsl:if test="$executive">
					| 
					<a href="/cr.php?action=edit;edition={../@edition};show=barcode">
						<xsl:if test="../@show = 'barcode'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
						<xsl:text>Barcode Mode</xsl:text>
					</a>
				</xsl:if>
				<xsl:if test="$executive">
					| 
					<a href="/cr.php?action=edit;edition={../@edition};show=print">
						<xsl:if test="../@show = 'print'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
						<xsl:text>Print Mode</xsl:text>
					</a>
				</xsl:if>
			</p>
		</xsl:if>

		<form method="get" action="/cr.php">
			<input type="hidden" name="action" value="edit"/>
			<input type="hidden" name="show" value="{../@show}"/>
			<input type="hidden" name="edition" value="{../@edition}"/>

			<xsl:if test="$edit_mode = 'mine'">
				<fieldset class="filter">
					<legend>Filter Reviews</legend>

					<p>
						Show:
						<label class="soft">
							<input type="checkbox" name="mine_writing" value="1">
								<xsl:if test="number(../@mine_writing)">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							Reviews I'm Writing
						</label>
						<xsl:text> </xsl:text>
						<label class="soft">
							<input type="checkbox" name="mine_editing" value="1">
								<xsl:if test="number(../@mine_editing)">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							Reviews I'm Editing
						</label>
						<xsl:text> </xsl:text>
						<label class="soft">
							<input type="checkbox" name="mine_deficient" value="1">
								<xsl:if test="number(../@mine_deficient)">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							Deficient Reviews Only
						</label>
						<xsl:text> </xsl:text>
						<input type="submit" name="mine_apply_filter" value="Apply"/>
					</p>
				</fieldset>
			</xsl:if>
			<xsl:if test="$edit_mode = 'all'">
				<fieldset class="filter">
					<legend>Filter Reviews</legend>

					<p>
						<label class="soft">
							Writer:
							<select name="filter_writer">
								<option value="-1"></option>
								<xsl:apply-templates select="/cr/staff/user" mode="option">
									<xsl:with-param name="selected" select="../@filter_writer"/>
								</xsl:apply-templates>
							</select>
						</label>
						<xsl:text> </xsl:text>
						<label class="soft">
							Editor:
							<select name="filter_editor">
								<option value="-1"></option>
								<xsl:apply-templates select="/cr/staff/user[@level >= 3]" mode="option">
									<xsl:with-param name="selected" select="../@filter_editor"/>
								</xsl:apply-templates>
							</select>
						</label>
						<xsl:text> </xsl:text>
						<label class="soft">
							Department:
							<select name="filter_department">
								<option value=""></option>
								<xsl:apply-templates select="/cr/departments/dept" mode="option">
									<xsl:with-param name="selected" select="../@filter_department"/>
									<xsl:with-param name="full" select="false()"/>
									<xsl:sort select="@banner"/>
								</xsl:apply-templates>
							</select>
						</label>
						<xsl:text> </xsl:text>
						<label class="soft">
							Status:
							<select name="filter_status">
								<option value="any"></option>
								<option value="deficient">
									<xsl:if test="../@filter_status = 'deficient'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Deficient
								</option>
								<option value="assigned">
									<xsl:if test="../@filter_status = 'assigned'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Assigned
								</option>
								<option value="published">
									<xsl:if test="../@filter_status = 'published'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Published
								</option>
								<option value="unpublished">
									<xsl:if test="../@filter_status = 'unpublished'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Unpublished
								</option>
								<option value="unassigned">
									<xsl:if test="../@filter_status = 'unassigned'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Unassigned
								</option>
								<option value="unreturned">
									<xsl:if test="../@filter_status = 'unreturned'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Unreturned
								</option>
								<option value="returned">
									<xsl:if test="../@filter_status = 'returned'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Returned
								</option>
								<option value="insufficient">
									<xsl:if test="../@filter_status = 'insufficient'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Insufficient
								</option>
								<option value="flagged">
									<xsl:if test="../@filter_status = 'flagged'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Flagged
								</option>
								<option value="unarchived">
									<xsl:if test="../@filter_status = 'unarchived'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									Unarchived
								</option>
							</select>
						</label>
						<xsl:text> </xsl:text>
						<input type="submit" name="apply_filter" value="Apply"/>
					</p>
				</fieldset>
			</xsl:if>
		</form>

		<xsl:if test="$edit_mode = 'print'">
			<form onsubmit="select_by_barcode_id_range(parseInt(this.barcode_review_id1.value), parseInt(this.barcode_review_id2.value)); return false;">
				<fieldset class="batch">
					<legend>Select by Barcode ID</legend>

					<p>
						First Barcode ID:
						<input type="text" name="barcode_review_id1" size="10"/>

						Last Barcode ID:
						<input type="text" name="barcode_review_id2" size="10"/>

						<input type="submit" value="Select"/>
					</p>
				</fieldset>
			</form>
		</xsl:if>

		<form method="post" action="/cr.php?{/cr/@request}">
			<xsl:copy-of select="$csrf_token_input"/>
			<input type="hidden" name="action" value="edit"/>

			<xsl:if test="$edit_mode = 'barcode'">
				<fieldset class="batch">
					<legend>Barcode Operations</legend>

					<p>
						Writer/Archive Box: 
						<input type="text" id="barcode_assignment_input" />

						Review Barcode:
						<input type="text" id="barcode_review_id"/>
					</p>
				</fieldset>
			</xsl:if>

			<table class="infotable">
				<tr>
					<td>
						<xsl:if test="$edit_mode != 'print'">
							<p class="instructions">Red = &lt;<xsl:value-of select="$sufficient_word_count"/> words; Yellow = unassigned; Blue = unpublished; Orange = flagged</p>
						</xsl:if>
					</td>
					<td>
						<p class="batch_select">
							<xsl:if test="$edit_mode != 'barcode'">
								Displaying <xsl:value-of select="count($reviews)"/> reviews.
							</xsl:if>
							<xsl:if test="$executive">
								<span id="nbr_reviews_selected">0</span> reviews selected.
								<xsl:if test="$edit_mode = 'print'">
									<span id="total_enrollment_selected">0</span> out of <xsl:value-of select="sum(review-header/enrollment)"/> questionnaires selected.
								</xsl:if>
								<xsl:if test="$edit_mode != 'barcode'">
									<a href="javascript:void(0);" onclick="batch_check_all(this.parentNode.parentNode.parentNode.parentNode.parentNode, 'review_id[]', true);">Select All</a> | <a href="javascript:void(0);" onclick="batch_check_all(this.parentNode.parentNode.parentNode.parentNode.parentNode, 'review_id[]', false);">Select None</a>
								</xsl:if>
							</xsl:if>
						</p>
					</td>
				</tr>
			</table>

			<table border="1" class="edit_reviews_list">
				<xsl:choose>
					<xsl:when test="$edit_mode = 'print'">
						<thead>
							<tr>
								<th>Barcode ID</th>
								<th>Course Code</th>
								<th>Title</th>
								<th>Professor</th>
								<th>Enrollment</th>
								<th>Printer</th>
								<th>Spooled?</th>
								<th>[]</th>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="$reviews" mode="print_mode"/>
						</tbody>
					</xsl:when>
					<xsl:otherwise>
						<thead>
							<tr>
								<th>Writer</th>
								<th>Editor</th>
								<xsl:if test="$executive">
									<th>Execs</th>
								</xsl:if>
								<th>Edit Review</th>
								<th>Tally</th>
								<th>Last Modified</th>
								<th>Editors</th>
								<xsl:if test="$executive">
									<th>Edits</th>
								</xsl:if>
								<th>Pub?</th>
								<xsl:if test="$executive">
									<th>[]</th>
								</xsl:if>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="$reviews"/>
						</tbody>
					</xsl:otherwise>
				</xsl:choose>
			</table>

			<xsl:if test="$executive and $edit_mode != 'print'">
				<fieldset class="batch">
					<legend>Batch Operations</legend>

					<xsl:if test="$edit_mode != 'barcode'">
						<p class="instructions">Check off any number of reviews above, and choose an action below.  The action will be applied to <strong>all</strong> checked reviews.</p>
					</xsl:if>

					<p>
						Writer: 
						<select class="writer_id" name="writer_id">
							<option value=""></option>
							<option class="special" value="-1">Unassigned</option>
							<option class="special" value="-2">Unreturned</option>
							<xsl:apply-templates select="/cr/staff/user" mode="option">
								<xsl:with-param name="show_stats">writing</xsl:with-param>
							</xsl:apply-templates>
						</select>
						<input type="submit" name="batch_assign_writer" value="Assign Writer"/>
					</p>

					<p>
						Editor: 
						<select class="editor_id" name="editor_id">
							<option value=""></option>
							<option class="special" value="-1">Unassigned</option>
							<xsl:apply-templates select="/cr/staff/user[@level >= 3]" mode="option">
								<xsl:with-param name="show_stats">editing</xsl:with-param>
							</xsl:apply-templates>
						</select>
						<input type="submit" name="batch_assign_editor" value="Assign Editor"/>
					</p>

					<xsl:if test="$chief">
						<p>
							<input type="submit" name="batch_publish" value="Publish"/>
							<input type="submit" name="batch_unpublish" value="Unpublish"/>
						</p>
					</xsl:if>	

					<p>
						<input type="submit" name="batch_flag" value="Flag"/>
						<input type="submit" name="batch_unflag" value="Unflag"/>
					</p>

					<p>
						<input type="submit" name="batch_insufficient" value="Mark Insufficient"/>
					</p>

					<p>
						Auto-assign executive editors (select participating editors by pressing Ctrl and clicking):<br/>
						<select multiple="multiple" name="batch_assign_execs_ids[]" size="{count(/cr/staff/user[@level >= 4])}">
							<xsl:apply-templates select="/cr/staff/user[@level >= 4]" mode="option"/>
						</select><br/>
						<input type="submit" name="batch_assign_execs" value="Auto-Assign Executive Editors"/>
						<input type="submit" name="batch_unassign_execs" value="Clear Executive Editors"/>
					</p>

					<p>Archive box: <input type="text" name="archive_box" size="10"/> <input type="submit" name="batch_archive" value="Archive Packets"/></p>
				</fieldset>
			</xsl:if>	

			<xsl:if test="$edit_mode = 'print'">
				<xsl:if test="$webmaster">
					<fieldset class="batch">
						<legend>(Re-)Assign Barcode IDs</legend>

						<p class="instructions">Click the button below to assign sequential Barcode IDs to the courses in this edition.</p>

						<p><label class="soft"><input type="radio" name="assign_barcode_ids_all" value="0" checked="checked"/> Only assign to courses without a barcode ID</label></p>
						<p><label class="soft"><input type="radio" name="assign_barcode_ids_all" value="1"/> Re-assign barcode IDs to all courses in this edition (requires reprinting labels and re-mailmerging the questionnaires)</label></p>
						<p><input type="submit" name="assign_barcode_ids" value="Assign Barcode IDs"/></p>
					</fieldset>
				</xsl:if>
				<fieldset class="batch">
					<legend>Print Labels</legend>

					<p class="instructions"><strong>Check off the courses</strong> for which you would like to print labels and submit the form below.</p>

					<p>
						Print
						<select name="print_labels_type">
							<option value="">Course Labels</option>
							<option value="backup">Backup Course Labels</option>
						</select>
						to
						<select name="print_labels_printer">
							<option value="">PDF Download</option>
							<option>click</option>
							<option>clack</option>
						</select>
						offset by
						<input type="text" size="4" name="print_labels_offset" value="0"/>
						labels:
						<input type="submit" name="batch_print_labels" value="Go"/>
					</p>
				</fieldset>
				<fieldset class="batch">
					<legend>Assign Printer</legend>

					<p>
						Assign the <strong>checked courses</strong> to:
						<select name="assign_printer_printer">
							<option class="unassigned" value="">Unassigned</option>
							<option>click</option>
							<option>clack</option>
						</select>
						<xsl:text> </xsl:text>
						<input type="submit" name="batch_assign_printer" value="Assign"/>
					</p>

					<p>
						Clear the "Spooled" flag of <strong>checked courses</strong>:
						<input type="submit" name="batch_clear_spooled" value="Clear Spooled Flag"/>
					</p>
				</fieldset>
				<xsl:if test="$webmaster">
					<fieldset class="batch">
						<legend>Generate Mailmerge Spreadsheet</legend>

						<p class="instructions">Click the button below to generate a spreadsheet that you can use to mailmerge the questionnaires.</p>

						<p>
							<input type="submit" name="generate_mailmerge_csv" value="Generate"/>
						</p>
					</fieldset>
				</xsl:if>
				<fieldset class="batch">
					<legend>Print Manifest</legend>

					<p class="instructions">This will print a manifest for each printer listing all courses being printed to that printer.  Editors will mark up this manifest with courses needing reprints.</p>

					<p>
						Print manifest for all printers to
						<select name="print_manifest_printer">
							<option value="">PDF Download</option>
							<option>click</option>
							<option>clack</option>
						</select>
						<xsl:text> </xsl:text>
						<input type="submit" name="print_manifest" value="Print"/>
					</p>
				</fieldset>
				<fieldset class="batch">
					<legend>Print Questionnaires</legend>

					<p class="instructions"><strong>Check off the courses</strong> for which you would like to print questionnaires and submit this form.  Each course will be spooled to its assigned printer only if it has not already been spooled.</p>

					<p>
						<input type="submit" name="batch_print_surveys" value="Print"/>
					</p>
				</fieldset>
				<fieldset class="batch">
					<legend>Reprint Questionnaires</legend>

					<p class="instructions"><strong>Check off the courses</strong> for which you would like to print questionnaires and submit the form below.</p>

					<p>
						Print <input type="text" name="reprint_surveys_copies" size="5"/>
						copies per course to
						<select name="reprint_surveys_printer">
							<option></option>
							<option>click</option>
							<option>clack</option>
						</select>
					</p>
					<p>
						<input type="submit" name="batch_reprint_surveys" value="Print"/>
					</p>
				</fieldset>
				<fieldset class="batch">
					<legend>Print Delivery List</legend>

					<p class="instructions">This will print a list of departments to help deliver packets after the Stuffing Party.</p>

					<p>
						Print delivery list to:
						<select name="print_delivery_list_printer">
							<option value="">PDF Download</option>
							<option>click</option>
							<option>clack</option>
						</select>
						<xsl:text> </xsl:text>
						<input type="submit" name="print_delivery_list" value="Print"/>
					</p>
				</fieldset>
				<xsl:if test="$webmaster">
					<fieldset class="batch">
						<legend>Delete Courses</legend>

						<p>
							<label class="soft"><input type="checkbox" name="batch_delete_confirm" value="1"/> I confirm this irreversible operation</label>
						</p>

						<p>
							<input type="submit" name="batch_delete" value="Delete Selected Courses"/>
						</p>
					</fieldset>
				</xsl:if>	
			</xsl:if>	
		</form>

		<xsl:if test="../@edition = /cr/edition/next and $executive and $edit_mode = 'all'">
			<form method="post" action="/cr.php?{/cr/@request}">
				<xsl:copy-of select="$csrf_token_input"/>
				<input type="hidden" name="action" value="edit"/>
				<fieldset class="batch">
					<legend>Assign Writer to Single Editor</legend>

					<p>
						Writer: 
						<select class="writer_id" name="writer_id">
							<option value=""></option>
							<xsl:apply-templates select="/cr/staff/user" mode="option">
								<xsl:with-param name="show_stats">writing</xsl:with-param>
							</xsl:apply-templates>
						</select>

						Editor: 
						<select class="editor_id" name="editor_id">
							<option value=""></option>
							<option class="special" value="-1">Unassigned</option>
							<xsl:apply-templates select="/cr/staff/user[@level >= 3]" mode="option">
								<xsl:with-param name="show_stats">editing</xsl:with-param>
								<xsl:sort select="@editing_count" data-type="number" order="ascending"/>
							</xsl:apply-templates>
						</select>
						<input type="submit" name="assign_editor_for_writer" value="Assign Editor"/>
					</p>
				</fieldset>
			</form>
		</xsl:if>

		<xsl:if test="$executive">
			<form method="post" action="/cr.php?{/cr/@request}">
				<xsl:copy-of select="$csrf_token_input"/>
				<input type="hidden" name="action" value="edit"/>
				<fieldset class="batch">
					<legend>Print Archive Box Slip</legend>

					<p>
						Box letter: <input type="text" name="print_archive_box_letter" size="5"/>
						
						Printer:
						<select name="print_archive_box_printer">
							<option value="">PDF download</option>
							<option>click</option>
							<option>clack</option>
						</select>
						<xsl:text> </xsl:text>
						<input type="submit" name="print_archive_box_slip" value="Print"/>
					</p>
				</fieldset>
			</form>
		</xsl:if>

		<xsl:if test="$webmaster">
			<p><a href="/cr.php?{$edit_query};change=new">Create a New Review...</a></p>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template name="course_info_form">
	<tr>
		<td class="first">Department:</td>
		<td>
			<select name="department_code" size="1">
				<option></option>
				<xsl:apply-templates select="/cr/departments/dept" mode="option">
					<xsl:with-param name="selected" select="department"/>
					<xsl:sort select="@banner"/>
				</xsl:apply-templates>
				<xsl:if test="not(/cr/departments/dept[@banner = current()/department])">
					<option selected="selected" value="{department}"><xsl:value-of select="department"/></option>
				</xsl:if>
			</select>
		</td>
	</tr>
	<tr><td class="first">Course Number:</td><td><input type="text" name="course_num" size="6" value="{course_num}" /><xsl:text> </xsl:text><span class="instructions">Enter 4-digit Banner number (plus optional letter) (leave off department code and section number) (Example: HIST1971H-S01 becomes 1971H)</span></td></tr>
	<tr><td class="first">Section:</td><td><input type="text" name="section" size="6" value="{section}" /><xsl:text> </xsl:text><span class="instructions">(HIST1971H-S01 becomes 1)</span></td></tr>
	<tr><td class="first">Professor:</td><td><input type="text" name="professor" size="30" value="{professor}" /><xsl:text> </xsl:text><span class="instructions">Enter like Last, First (Example: Gordon S. Wood becomes Wood, Gordon S.)</span></td></tr>
	<tr><td class="first">Title:</td><td><input type="text" name="title" size="30" value="{title}" /></td></tr>
</xsl:template>
<xsl:template name="course_info_form_readonly">
	<tr>
		<td class="first">Department:</td>
		<td>
			<select name="department_code" size="1">
				<xsl:apply-templates select="/cr/departments/dept[@banner = current()/department]" mode="option"/>
			</select>
		</td>
	</tr>
	<tr><td class="first">Course Number:</td><td><input type="text" readonly="readonly" name="course_num" size="6" value="{course_num}" /><xsl:text> </xsl:text><span class="instructions">Enter 4-digit Banner number (plus optional letter) (leave off department code and section number) (Example: HIST1971H-S01 becomes 1971H)</span></td></tr>
	<tr><td class="first">Section:</td><td><input type="text" readonly="readonly" name="section" size="6" value="{section}" /><xsl:text> </xsl:text><span class="instructions">(HIST1971H-S01 becomes 1)</span></td></tr>
	<tr><td class="first">Professor:</td><td><input type="text" name="professor" size="30" value="{professor}"></input><xsl:text> </xsl:text><span class="instructions">Enter like Last, First (Example: Gordon S. Wood becomes Wood, Gordon S.)</span></td></tr>
	<tr><td class="first">Title:</td><td><input type="text" name="title" size="30" value="{title}"><xsl:if test="not($executive)"><xsl:attribute name="readonly">readonly</xsl:attribute></xsl:if></input></td></tr>
</xsl:template>

<xsl:template match="enrollment" mode="edit_form">
	<tr><td class="first">Frosh:</td><td><input type="text" name="frosh" size="10" value="{frosh}"/></td></tr>
	<tr><td class="first">Soph:</td><td><input type="text" name="soph" size="10" value="{soph}"/></td></tr>
	<tr><td class="first">Jun:</td><td><input type="text" name="jun" size="10" value="{jun}"/></td></tr>
	<tr><td class="first">Sen:</td><td><input type="text" name="sen" size="10" value="{sen}"/></td></tr>
	<tr><td class="first">Grad:</td><td><input type="text" name="grad" size="10" value="{grad}"/></td></tr>
	<tr><td class="first">Total:</td><td><input type="text" name="total" size="10" value="{total}"/></td></tr>
</xsl:template>

<xsl:template match="enrollment" mode="edit_form_readonly">
	<tr><td class="first">Frosh:</td><td><input type="text" readonly="readonly" name="frosh" size="10" value="{frosh}"/></td></tr>
	<tr><td class="first">Soph:</td><td><input type="text" readonly="readonly" name="soph" size="10" value="{soph}"/></td></tr>
	<tr><td class="first">Jun:</td><td><input type="text" readonly="readonly" name="jun" size="10" value="{jun}"/></td></tr>
	<tr><td class="first">Sen:</td><td><input type="text" readonly="readonly" name="sen" size="10" value="{sen}"/></td></tr>
	<tr><td class="first">Grad:</td><td><input type="text" readonly="readonly" name="grad" size="10" value="{grad}"/></td></tr>
	<tr><td class="first">Total:</td><td><input type="text" readonly="readonly" name="total" size="10" value="{total}"/></td></tr>
</xsl:template>

<xsl:template match="tally" mode="edit_form">
	<tr><td class="first"># Respondents:</td><td><input type="text" readonly="readonly" name="num_respondents" size="10" value="{num_respondents}"/></td></tr>
	<tr><td class="first">Concs:</td><td><input type="text" readonly="readonly" name="concs" size="10" value="{concs}"/></td></tr>
	<tr><td class="first">Non-concs:</td><td><input type="text" readonly="readonly" name="nonconcs" size="10" value="{nonconcs}"/></td></tr>
	<tr><td class="first">Dunno:</td><td><input type="text" readonly="readonly" name="dunno" size="10" value="{dunno}"/></td></tr>
	<tr><td class="first">Prof Avg:</td><td><input type="text" readonly="readonly" name="profavg" size="10" value="{profavg}"/></td></tr>
	<tr><td class="first">Course Avg:</td><td><input type="text" readonly="readonly" name="courseavg" size="10" value="{courseavg}"/></td></tr>
	<tr><td class="first">Mean Typical Hours:</td><td><input type="text" readonly="readonly" name="minhours_mean" size="10" value="{minhours_mean}"/></td></tr>
	<tr><td class="first">Median Typical Hours:</td><td><input type="text" readonly="readonly" name="minhours_median" size="10" value="{minhours_median}"/></td></tr>
	<tr><td class="first">Mean Max Hours:</td><td><input type="text" readonly="readonly" name="maxhours_mean" size="10" value="{maxhours_mean}"/></td></tr>
	<tr><td class="first">Median Max Hours:</td><td><input type="text" readonly="readonly" name="maxhours_median" size="10" value="{maxhours_median}"/></td></tr>
</xsl:template>

<xsl:template match="content-source" mode="edit_form">
	<tr><td colspan="2"><span class="instructions">Separate each paragraph by a blank line, OR indent each line, but please not both.  Use the preview button to make sure your review looks OK before saving.</span><textarea name="review_contents" rows="30" cols="60" onkeyup="recalculate_word_count('edit_review_word_count', this.value);"><xsl:value-of select="."/></textarea></td></tr>
	<tr><td class="first">Word Count:</td><td><span id="edit_review_word_count"><xsl:value-of select="@word-count"/></span></td></tr>
</xsl:template>

<xsl:template name="edit_revision">
	<xsl:choose>
		<xsl:when test="../@new">New</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="modified"/> by <xsl:apply-templates select="modifier" mode="staff_username"/>
			<xsl:choose>
				<xsl:when test="revision = 0">
					<xsl:text> (Latest)</xsl:text><br/>
					<span class="fake_link">&#x2190; Newer Revision</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> (Revision </xsl:text><xsl:value-of select="revision"/>)<br/>
					<a href="/cr.php?{$edit_query};dept={department};course={course_num};section={section};revision={revision - 1}">&#x2190; Newer Revision</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<xsl:choose>
				<xsl:when test="../has_older_revision">
					<a href="/cr.php?{$edit_query};dept={department};course={course_num};section={section};revision={revision + 1}">Older Revision &#x2192;</a>
				</xsl:when>
				<xsl:otherwise>
					<span class="fake_link">Older Revision &#x2192;</span>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="writer/user[email = '']|editor/user[email = '']" mode="edit_form">
	<xsl:apply-templates mode="staff_username" select="username"/>
</xsl:template>
<xsl:template match="writer/user[email != '']|editor/user[email != '']" mode="edit_form">
	<a href="mailto:{email}"><xsl:apply-templates mode="staff_username" select="username"/></a>
	<xsl:text> </xsl:text>
	<span class="instructions">(Click to email)</span>
</xsl:template>

<xsl:template match="diff">
	<tbody class="collapsed">
		<tr xsl:use-attribute-sets="section_head"><td colspan="2">Review Differences:</td></tr>
		<tr><td colspan="2">
			<table class="diff">
				<thead><tr><th>Previous Revision</th><th>Current Revision</th></tr></thead>
				<tbody>
					<tr>
						<td>
							<xsl:apply-templates select="prev/content"/>
						</td>
						<td>
							<xsl:apply-templates select="curr/content"/>
						</td>
					</tr>
				</tbody>
			</table>
		</td></tr>
	</tbody>

</xsl:template>

<xsl:template match="review" mode="edit_form">
	<xsl:param name="is_new" select="false()"/>
	<xsl:variable name="is_modifiable" select="($is_new or revision = 0) and (not(number(active)) or $chief)"/>

	<form>
		<xsl:choose>
			<xsl:when test="$is_modifiable">
				<xsl:attribute name="action">/cr.php?<xsl:value-of select="$edit_query"/></xsl:attribute>
				<xsl:attribute name="method">POST</xsl:attribute>
				<xsl:copy-of select="$csrf_token_input"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="onsubmit">
					alert('This review cannot be edited.');
					return false;
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>

		<input type="hidden" name="action" value="edit" />
		<input type="hidden" name="change" value="change">
			<xsl:if test="$is_new">
				<xsl:attribute name="value">new</xsl:attribute>
			</xsl:if>
		</input>

		<xsl:if test="not($is_new)">
			<input type="hidden" name="writer_id" value="{writer_id}"/>
			<input type="hidden" name="review_id" value="{@id}"/>
		</xsl:if>
		
		<table class="edit_review_form">
			<tbody>
				<tr xsl:use-attribute-sets="section_head"><td colspan="2">Review Information:</td></tr>
				<tr>
					<td class="first">Edition:</td>
					<td><xsl:value-of select="@edition"/></td>
				</tr>
				<tr>
					<td class="first">Writer:</td>
					<td title="{writer/user/username} - {writer/user/@id}"><xsl:apply-templates select="writer/user" mode="edit_form"/></td>
				</tr>
				<tr>
					<td class="first">Editor:</td>
					<td title="{editor/user/username} - {editor/user/@id}"><xsl:apply-templates select="editor/user" mode="edit_form"/></td>
				</tr>
				<tr>
					<td class="first">Revision:</td>
					<td>
						<xsl:call-template name="edit_revision"/>
					</td>
				</tr>
				<tr>
					<td class="first">Published?</td>
					<td>
						<xsl:choose>
							<xsl:when test="not(@is_new) and revision = 0 and number(active)">Yes</xsl:when>
							<xsl:otherwise>No</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:if test="not(@is_new)">
					<tr>
						<td class="first">Views:</td>
						<td><xsl:value-of select="views"/></td>
					</tr>
					<xsl:if test="$executive">
						<tr>
							<td class="first">Featured on this Date:</td>
							<td><input type="text" name="featured_date" value="{featured_date}"/><xsl:text> </xsl:text><span class="instructions">(YYYY-MM-DD)</span></td>
						</tr>
					</xsl:if>
				</xsl:if>
			</tbody>
			<xsl:apply-templates select="../diff"/>
			<tbody>
				<xsl:if test="not($is_new)">
					<xsl:attribute name="class">collapsed</xsl:attribute>
				</xsl:if>
				<tr xsl:use-attribute-sets="section_head"><td colspan="2">Course Information:</td></tr>
				<xsl:choose>
					<xsl:when test="$is_new or $chief"><xsl:call-template name="course_info_form"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="course_info_form_readonly"/></xsl:otherwise>
				</xsl:choose>
				<tr class="always_expanded"><td class="first">Course Format:</td><td><input type="text" name="courseformat" size="30" value="{courseformat}"/></td></tr>
				<tr class="always_expanded">
					<td class="first">Observed Reading Period?</td>
					<td>
						<label class="soft"><input type="radio" name="observed_reading" value="1"><xsl:if test="observed_reading = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Yes</label>
						<xsl:text> </xsl:text>
						<label class="soft"><input type="radio" name="observed_reading" value="0"><xsl:if test="observed_reading = 0"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> No</label>
					</td>
				</tr>
			</tbody>

			<tbody>
				<tr xsl:use-attribute-sets="section_head"><td colspan="2">Recommended Courses:</td></tr>
				<tr>
					<td colspan="2"><span class="instructions">Enter one course code per line.  Use <a href="http://brown.mochacourses.com/mocha/search.action?semesters={/cr/edition/next/@mocha}" target="_blank">Mocha</a> to lookup course codes.</span></td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea name="other_courses" style="width: auto;" rows="6" cols="20">
							<xsl:if test="revision > 0">
								<xsl:attribute name="readonly">readonly</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="other_courses"/>
						</textarea>
					</td>
				</tr>
			</tbody>
			<tbody>
				<xsl:if test="not($is_new)">
					<xsl:attribute name="class">collapsed</xsl:attribute>
				</xsl:if>
				<tr xsl:use-attribute-sets="section_head"><td colspan="2">Enrollment:</td></tr>
				<xsl:choose>
					<xsl:when test="$is_new or $webmaster"><xsl:apply-templates select="enrollment" mode="edit_form"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="enrollment" mode="edit_form_readonly"/></xsl:otherwise>
				</xsl:choose>
			</tbody>
			<xsl:if test="not($is_new)">
				<tbody class="collapsed">
					<tr xsl:use-attribute-sets="section_head"><td colspan="2">Tally:</td></tr>
					<tr><td colspan="2"><a href="/cr.php?action=tally;id={@id}" onclick="window.open(this.href, '_blank', 'menubar=no,resizable=yes,toolbar=no,location=no,status=no,scrollbars=yes,resizable=yes,fullscreen=yes'); return false;">Open Tally Editor...</a></td></tr>
					<xsl:apply-templates select="tally" mode="edit_form"/>
					<!-- Commented out until new graph is devised
					<tr class="tally_image"><td colspan="2"><img src="/images/editions/{@edition}/legend.gif"/><img src="/getimage.php?newreviewid={@id}" /></td></tr>
					-->
				</tbody>

				<tbody>
					<tr xsl:use-attribute-sets="section_head"><td colspan="2">Preview:</td></tr>
					<tr>
						<td colspan="2">
							<div class="preview">
								<xsl:apply-templates select="content"/>
							</div>
						</td>
					</tr>
				</tbody>
			</xsl:if>
			<xsl:if test="$is_modifiable">
				<tbody>
					<xsl:if test="number(insufficient)">
						<xsl:attribute name="class">inapplicable</xsl:attribute>
					</xsl:if>
					<tr xsl:use-attribute-sets="section_head"><td colspan="2">Review:</td></tr>
					<tr class="always_applicable"><td colspan="2">
						<label class="soft">
							<input type="checkbox" name="insufficient" value="1">
								<xsl:if test="number(insufficient)">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
								<xsl:attribute name="onclick">
									set_class_if(this.parentNode.parentNode.parentNode.parentNode, "inapplicable", this.checked);
								</xsl:attribute>
							</input>
							Insufficient information provided.
						</label>
					</td></tr>
					<tr><td colspan="2">Use Mocha to lookup description and prerequisites: <a href="http://brown.mochacourses.com/mocha/search.action?q={department}{course_num}&amp;semesters={/cr/edition/next/@mocha}" title="See this course in Mocha" target="_blank">Mocha</a></td></tr>
					<tr><td colspan="2">Spell the professor name correctly: <strong style="font-size: 160%;"><xsl:value-of select="professor"/></strong></td></tr>
					<xsl:apply-templates select="content-source" mode="edit_form"/>
				</tbody>
			</xsl:if>

			<tbody>
				<xsl:if test="not(@is_new)">
					<tr>
						<td class="first">Editors Initials:</td>
						<td>
							<input type="text" name="editors" size="20" value="{editors}">
								<xsl:if test="revision > 0 or not($executive or /cr/user/uid = editor/user/@id)">
									<xsl:attribute name="readonly">readonly</xsl:attribute>
								</xsl:if>
							</input>
							<span class="instructions"> Separate each distinct editor's initials by commas (Example: JC, GG if Josiah Carberry and Gordon Gee both edited this review)</span>
						</td>
					</tr>
					<xsl:if test="editor_comments">
						<tr>
							<td class="first">Comments for Writer:</td>
							<td>
								<textarea name="editor_comments" style="width: auto;" rows="4" cols="60">
									<xsl:if test="revision > 0">
										<xsl:attribute name="readonly">readonly</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="editor_comments"/>
								</textarea>
								<br/>
								<span class="instructions">If the writer has done a good job, or could use some improvement, let him/her know!  All comments will be saved for later.  When you're ready, send the comments from the <a href="/cr.php?action=my_writers">My Writers page</a>.</span>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="$executive">
						<tr>
							<td class="first">Total Edit Distance:</td>
							<td>
								<xsl:value-of select="edit_distance"/>
								<br/>
								<span class="instructions">(Total number of words modified by this review's editor.)</span>
							</td>
						</tr>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(@is_new) and revision = 0 and $chief">
					<tr>
						<td class="first">Published?</td>
						<td>
							<label class="soft">
								<input type="radio" name="active" value="0">
									<xsl:if test="not(number(active))">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<xsl:text> No</xsl:text>
							</label>
							<xsl:text> </xsl:text>
							<label class="soft">
								<input type="radio" name="active" value="1">
									<xsl:if test="number(active)">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<xsl:text> Yes</xsl:text>
							</label>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="not(@is_new) and revision = 0 and $executive">
					<tr>
						<td class="first">Flagged?</td>
						<td>
							<label class="soft">
								<input type="radio" name="flagged" value="0">
									<xsl:if test="not(number(flagged))">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<xsl:text> No</xsl:text>
							</label>
							<xsl:text> </xsl:text>
							<label class="soft">
								<input type="radio" name="flagged" value="1">
									<xsl:if test="number(flagged)">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
								<xsl:text> Yes</xsl:text>
							</label>
						</td>
					</tr>
				</xsl:if>
			</tbody>
			<xsl:if test="$is_modifiable">
				<tbody>
					<tr class="submit"><td colspan="2">
						<!-- TODO
						<input type="submit" name="preview" value="Preview" />
						<xsl:text> </xsl:text>
						<input type="submit" name="save" value="Save" />
						<xsl:text> </xsl:text>
						<input type="submit" name="finish" value="Save &amp; Finish" />
						-->
						<input type="submit" value="Save" />
					</td></tr>
				</tbody>
			</xsl:if>
			<xsl:if test="$webmaster">
				<p><a href="/cr.php?action=remove;id={@id}">Remove this Review</a></p>
			</xsl:if>
		</table>
	</form>
</xsl:template>

<xsl:template match="edit_reviews/edit">
	<div id="content">
		<h3><xsl:value-of select="$title"/></h3>

		<p><a href="/cr.php?{$edit_query}">&#8592; Return to Reviews List (without saving)</a></p>

		<xsl:call-template name="instruct"/>

		<xsl:apply-templates select="review" mode="edit_form">
			<xsl:with-param name="is_new" select="boolean(@new)"/>
		</xsl:apply-templates>
	</div>
</xsl:template>

<xsl:template match="edit_reviews">
	<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
