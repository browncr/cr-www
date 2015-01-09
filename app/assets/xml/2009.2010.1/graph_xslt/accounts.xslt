<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">User Accounts - The Critical Review</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="register">
	<div id="content">
		<h3>Create an Account / Reset your Password</h3>

		<p class="instructions">To register an account, fill out the following form.  You <strong>must</strong> specify your Brown email.  To reset your account password, re-register with the same username and password.  Your password will be emailed to you.</p>

		<form action="/cr.php?action=register" method="post">

			<table>
			  <tr>
				<td><label>Desired username:</label></td>
				<td><input type="text" name="new_username" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>Your Brown email:</label></td>
				<td><input type="text" name="new_email" size="30"/> @brown.edu</td>
			  </tr>
			</table>

			<p><input type="submit" name="submit" value="Sign me up!" /></p>
		</form>
	</div>
</xsl:template>

<xsl:template match="register_staff">
	<div id="content">
		<h3>Staff Registration</h3>

		<form action="/cr.php?action=register_staff" method="post">
			<xsl:copy-of select="$csrf_token_input"/>

			<table>
			  <tr>
				<td><label>Temporary ID:</label></td>
				<td><input type="text" name="dummy_id" size="30"/> (Leave blank if none)</td>
			  </tr>

			  <tr>
				<td><label>Already has account?</label></td>
				<td>
					<select name="has_account">
						<option value="0">No</option>
						<option value="1">Yes</option>
					</select>
				</td>
			  </tr>

			  <tr>
				<td><label>(Desired) Username:</label></td>
				<td><input type="text" name="desired_username" size="30"/></td>
			  </tr>

			  <tr>
				<td><label>Brown email:</label></td>
				<td><input type="text" name="brown_email" size="30"/> @brown.edu</td>
			  </tr>

			  <tr>
				<td><label>Full name:</label></td>
				<td><input type="text" name="full_name" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>Phone number:</label></td>
				<td><input type="text" name="phone" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>Year of graduation:</label></td>
				<td><input type="text" name="year" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>Brown mailbox number:</label></td>
				<td><input type="text" name="mailbox" size="30"/></td>
			  </tr>
			</table>

			<p><input type="submit" name="submit" value="Register!" /></p>
		</form>
	</div>
</xsl:template>

<xsl:template match="change_password">
	<div id="content">
		<h3>Change Your Password</h3>

		<form action="/cr.php?action=change_password" method="post">
			<xsl:copy-of select="$csrf_token_input"/>

			<table>
			  <tr>
				<td><label>Old password:</label></td>
				<td><input type="password" name="old_password" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>New password:</label></td>
				<td><input type="password" name="new_password1" size="30"/></td>
			  </tr>
			  <tr>
				<td><label>Retype password:</label></td>
				<td><input type="password" name="new_password2" size="30"/></td>
			  </tr>
			</table>

			<p><input type="submit" name="submit" value="Change Password" /></p>
		</form>
	</div>
</xsl:template>

</xsl:stylesheet>
