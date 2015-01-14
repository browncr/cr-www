<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">

<xsl:template name="feedback-form">
	<form action="/feedback" method="post">
		<xsl:copy-of select="$csrf_token_input"/>
		<p><textarea name="comments" cols="60" rows="4"></textarea></p>
		<p>
			Your email address <em><strong>(optional)</strong></em>:
			<input type="text" name="email" size="30"/>
		</p>
		<p class="minor info">If provided, your email address will be used only to reply to your feedback.</p>
		<p><input type="submit" name="btn" value="Submit your Feedback"/></p>
	</form>
</xsl:template>

</xsl:stylesheet>
