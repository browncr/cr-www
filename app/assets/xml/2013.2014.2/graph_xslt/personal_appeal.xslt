<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />

<xsl:variable name="title">A Personal Appeal</xsl:variable>

<xsl:template match="personal-appeal">
	<div id="content" class="appeal">
		<xsl:call-template name="facebook-big"/>
		<xsl:apply-templates/>
	</div>
</xsl:template>

</xsl:stylesheet>
