<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Critical Review - Send a Mailing</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="mailing/comments">
	<xsl:for-each select="comment">
		<xsl:apply-templates select="." mode="course-code"/><xsl:text>:&#10;</xsl:text>
		<xsl:value-of select="text"/>
		<xsl:if test="position() != last()">
			<xsl:text>&#10;&#10;</xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:template>
<xsl:template match="mailing">
	<div id="content">
		<h3>Send a Mailing</h3>

		<form action="/cr.php?action=mailing" method="post">
			<xsl:copy-of select="$csrf_token_input"/>
			<fieldset>
				<p>
					<label>From: 
						<select name="sender">
							<option value="{@from}|{@from-name}"><xsl:value-of select="@from-name"/> &lt;<xsl:value-of select="@from"/>&gt;</option>
							<xsl:if test="$chief">
								<option value="Critical_Review@brown.edu|Critical Review">Critical Review &lt;Critical_Review@brown.edu&gt;</option>
							</xsl:if>
						</select>
					</label>
				</p>
				<p>
					<label>To:

						<select name="recipient">
							<xsl:if test="recipient">
								<option value="uid:{recipient/@id}"><xsl:value-of select="recipient"/></option>
							</xsl:if>
							<option value="my_writers">My Writers</option>
							<xsl:if test="$executive">
								<option value="staff">All Staff</option>
								<option value="editors">All Editors</option>
							</xsl:if>
						</select>
					</label>
					<xsl:text> </xsl:text>
					<label class="soft">
						<input type="checkbox" name="bcc_me" value="1"/>Send me a copy
					</label>
					<xsl:if test="$chief">
						<xsl:text> </xsl:text>
						<label class="soft">
							<input type="checkbox" name="bcc_cr" value="1"/>Send a copy to Critical_Review@brown.edu
						</label>
					</xsl:if>
				</p>
				<p>
					<label>Subject: <input type="text" name="subject" size="40" /></label>
				</p>

				<p>
					<label>Type your message in the box below:</label><br/>
					<textarea name="message" rows="20" cols="60" class="full"><xsl:apply-templates select="comments"/></textarea>
				</p>

				<p>
					<label>Send the message: <input type="submit" name="send_mailing" value="Send"/></label>
				</p>
				<p>
					<label>Start fresh: <input type="button" value="Clear Message" onclick="this.form['message'].value = '';"/></label>
				</p>
			</fieldset>
		</form>
	</div>
</xsl:template>

</xsl:stylesheet>
