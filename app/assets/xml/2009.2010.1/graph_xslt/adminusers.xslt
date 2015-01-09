<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Admin Users - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:variable name="ulevels" select="document(concat('/xml/', $next_edition, '/ulevels.xml'))/ulevels"/>

<xsl:template match="ulevels/level">
	<xsl:param name="selected_ulevel"/>
	<!-- If we're not an editor-in-chief or above, we're not allowed to change anyone's ulevel -->
	<!-- Therefore, only show the already-selected ulevel in the select box -->
	<xsl:if test="$chief or @nbr = $selected_ulevel"> <!-- We're chief or this is the already-selected ulevel -->
		<option value="{@nbr}">
			<xsl:if test="@nbr = $selected_ulevel">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="short"/>
		</option>
	</xsl:if>
</xsl:template>

<xsl:template match="user">
	<tr>
		<td><xsl:value-of select="@id"/></td>
		<td><xsl:value-of select="username"/></td>
		<td><a href="mailto:{email}"><xsl:value-of select="email"/></a></td>
		<xsl:if test="parent::users">
			<td>
				<input type="checkbox" name="user_id[]" value="{@id}">
					<xsl:if test="number(@bio_id)">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</td>
		</xsl:if>
		<xsl:if test="parent::staff">
			<xsl:variable name="chief-only">
				<xsl:if test="not($chief)"><xsl:attribute name="readonly">readonly</xsl:attribute></xsl:if>
			</xsl:variable>
			<td>
				<select name="level[{@id}]">
					<xsl:apply-templates select="$ulevels/level">
						<xsl:with-param name="selected_ulevel" select="@level"/>
						<xsl:sort select="@nbr" data-type="number" order="ascending"/>
					</xsl:apply-templates>
				</select>
			</td>
			<td><input type="text" name="name[{@id}]" size="20" value="{name}"/></td>
			<xsl:if test="$chief">
				<td><input type="text" name="title[{@id}]" size="20" value="{title}"/></td>
				<td><input type="text" name="rank[{@id}]" size="4" value="{rank}"/></td>
			</xsl:if>
			<td><input type="text" name="year[{@id}]" size="6" value="{year}"/></td>
			<td><input type="text" name="phone[{@id}]" size="12" value="{phone}"/></td>
			<td><input type="text" name="mailbox[{@id}]" size="8" value="{mailbox}"/></td>
		</xsl:if>
	</tr>
</xsl:template>

<xsl:template match="users">
	<div id="content">
		<h3>Assign Staff for <xsl:value-of select="/cr/edition/next"/></h3>

		<p><strong>Assign Staff</strong> | <a href="/cr.php?action=adminusers;subpage=staffonly">Edit Staff</a></p>

		<p>
			<a>
				<xsl:attribute name="href">
					<xsl:text>mailto:</xsl:text>
					<xsl:for-each select="user[boolean(number(@bio_id)) and email != '']">
						<xsl:value-of select="email"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				Email the staff
			</a>
		</p>

		<form action="/cr.php?action=adminusers" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<table border="1">
				<thead>
					<tr><th>User ID</th><th>Username</th><th>Email</th><th>Staff?</th></tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="user">
						<xsl:sort select="boolean(number(@bio_id))" data-type="number" order="descending"/>
						<xsl:sort select="username"/>
					</xsl:apply-templates>
				</tbody>
			</table>

			<p>
				<input type="hidden" name="action" value="adminusers"/>
				<input type="submit" name="assignstaff" value="Assign Staff"/>
			</p>
		</form>
	</div>
</xsl:template>

<xsl:template match="staff" priority="10">
	<div id="content">
		<h3>Edit Staff for <xsl:value-of select="/cr/edition/next"/></h3>

		<xsl:if test="$chief">
			<p><a href="/cr.php?action=adminusers">Assign Staff</a> | <strong>Edit Staff</strong></p>
		</xsl:if>
		
		<p>
			<a>
				<xsl:attribute name="href">
					<xsl:text>mailto:</xsl:text>
					<xsl:for-each select="user[email != '']">
						<xsl:value-of select="email"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				Email the staff</a>

			|
			<a>
				<xsl:attribute name="href">
					<xsl:text>mailto:</xsl:text>
					<xsl:for-each select="user[email != '' and @level >= 3]">
						<xsl:value-of select="email"/>
						<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
				Email the editors</a>
		</p>

		<form action="/cr.php?action=adminusers;subpage=staffonly" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<table border="1">
				<thead>
					<tr>
						<th>User ID</th>
						<th>Username</th>
						<th>Email</th>
						<th>Level</th>
						<th>Name</th>
						<xsl:if test="$chief">
							<th>Title</th>
							<th>Rank</th>
						</xsl:if>
						<th>Year</th>
						<th>Phone #</th>
						<th>Mailbox</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="user">
						<xsl:sort select="@level" data-type="number" order="descending"/>
						<xsl:sort select="username"/>
					</xsl:apply-templates>
				</tbody>
			</table>

			<p>
				<input type="hidden" name="action" value="adminusers"/>
				<input type="hidden" name="subpage" value="staffonly"/>
				<xsl:if test="user">
					<input type="submit" name="editstaff" value="Submit Changes"/>
					<xsl:if test="$chief">
						<input type="submit" name="purgestaff" value="Purge Writers Without Reviews"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(user)">
					<xsl:if test="$chief">
						<input type="submit" name="copystaff" value="Copy Staff from Last Semester"/>
					</xsl:if>
				</xsl:if>
			</p>
		</form>

		<fieldset>
			<legend>Print Barcode Materials</legend>

			<p class="instructions">Use this form to print barcode sheets for the Packet Distribution.</p>

			<form action="/cr.php?action=print_staff_barcode_materials" method="post">
				<xsl:copy-of select="$csrf_token_input"/>
				<p>Number of new user forms: <input type="text" name="nbr_dummy_users" value="40" size="10"/></p>
				<p>First dummy user ID: <input type="text" name="first_dummy_user_id" value="1000" size="10"/></p>
				<p class="instructions">
					At any single Packet Distribution, it is vital that no two new user forms have the same dummy ID.
					If you aren't reusing forms from a previous semester, you don't need to worry about this, but if you
					are reusing forms, make sure that the first dummy user ID from this batch is greater than each
					dummy ID from the forms you are reusing.  (The dummy ID is the number below the barcode on the form.)
				</p>
				<p>
					Send to:
					<select name="printer">
						<option value="">PDF Download</option>
						<option>click</option>
						<option>clack</option>
					</select>
				</p>
				<p><input type="submit" name="submit_btn" value="Generate"/></p>
			</form>

			<p><a href="/admin/barcode_commands.pdf">Barcode Command Sheet (PDF)</a></p>
		</fieldset>

		<p><a href="/cr.php?action=register_staff">Staff Registration</a></p>
	</div>
</xsl:template>

</xsl:stylesheet>
