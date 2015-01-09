<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<!-- Boilerplate -->
	<xsl:import href="base.xslt" />
	<xsl:import href="tally_base.xslt" />

	<!-- This page is a little different from the others.  Since we don't want the full CR header and sidebar on this page, we override the /cr template here, and generate the whole HTML page. -->
	<xsl:template match="/cr">
		<xsl:param name="questions" select="document(concat('/assets/', $assets_version, '/xml/', review-header/@edition, '/tally_questions.xml'))/tally/questions"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Tally for <xsl:apply-templates select="review-header" mode="course-code"/></title>
				<link rel="stylesheet" type="text/css" href="/assets/{$assets_version}/css/tally.css" />
				<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"></script>
				<script type="text/javascript" src="/assets/{$assets_version}/js/tally.js"></script>
				<script type="text/javascript">var csrf_token = '<xsl:value-of select="$csrf_token"/>';</script>
				<script type="text/javascript">
					var tally = null;

					register_onload_event(function () {
						var question_options = {
						<xsl:apply-templates select="$questions" mode="javascript" />
						};
						tally = new Tally($("tally"), question_options);
						window.onbeforeunload = function () {
							if (tally.is_modified())
								return "You have not saved the tally.  If you navigate away without saving, you will LOSE your changes.";
						};
					});
				</script>
			</head>
			<body>
				<div id="tally_header">
					<h1>Tally for <xsl:apply-templates select="review-header" mode="course-code"/></h1>
					<p class="commands">
						<input type="button" value="Save" onclick="tally.unselect(); tally.submit(location.href);"/>
						<input type="button" value="Close" onclick="window.close();"/>
						<input type="button" value="Add Column" onclick="tally.add_column();"/>
						<input type="button" value="Remove Last Column" onclick="tally.remove_last_column();"/>
					</p>
				</div>
				<div id="tally_body">
					<xsl:apply-templates select="$questions">
						<xsl:with-param name="answers" select="tally/answers"/>
					</xsl:apply-templates>
				</div>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
