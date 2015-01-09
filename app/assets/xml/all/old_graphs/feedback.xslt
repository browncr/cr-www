<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

	<!-- Boilerplate -->
	<xsl:import href="base.xslt" />
	<xsl:variable name="title">Critical Review Feedback</xsl:variable>

	<xsl:include href="feedback_common.xslt" />

	<xsl:template match="feedback-form">
		<div id="content">
			<h3>We Want Your Feedback</h3>

			<xsl:call-template name="feedback-form"/>
		</div>
	</xsl:template>
	<xsl:template match="feedback-thanks">
		<div id="content">
			<h3>Thank You</h3>

			<p>Thanks for taking the time to submit feedback.  Your input is invaluable in our ongoing quest to improve the Critical Review and provide a useful service to the Brown community.</p>

			<p><a href="/">Go Home</a></p>
		</div>
	</xsl:template>

</xsl:stylesheet>
