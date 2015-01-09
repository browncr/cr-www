<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:g="http://www.thecriticalreview.org/xmlns/graph"
	xmlns="http://www.w3.org/2000/svg"
	version="1.0">

	<!-- Parameters that control how the tally graph looks -->
	<xsl:param name="line-height" select="10" />
	<xsl:param name="line-spacing" select="6" />
	<xsl:param name="group-spacing" select="16" />
	<xsl:param name="top-group-spacing" select="20" />
	<xsl:param name="bar-width" select="250"/>

	<!-- Parameters that control how the legend looks -->
	<xsl:param name="font-size" select="'8pt'" />
	<xsl:param name="header-font-size" select="'12pt'" />
	<xsl:param name="font-family" select="'sans-serif'" />
	<xsl:param name="text-width" select="180"/>
	
	<!-- select="document('/xml/all/tally_colors.xml')/tally-colors"/ -->
	<xsl:param name="tally-colors"/>

	<xsl:template match="tally-colors/color">
		<xsl:text>rgb(</xsl:text>
		<xsl:value-of select="r"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="g"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="b"/>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<!-- Draw a single bar -->
	<xsl:template name="bar">
		<xsl:param name="nbr" select="0"/>
		<xsl:param name="y" select="0"/>
		<xsl:param name="x" select="0"/>
		<xsl:param name="width" select="0"/>

		<line stroke-width="{$line-height}px" x1="{$x}px" x2="{$x + $width}px" y1="{$y + $line-height div 2}px" y2="{$y + $line-height div 2}px">
			<xsl:attribute name="stroke">
				<xsl:apply-templates select="$tally-colors/color[@value=$nbr]"/>
			</xsl:attribute>
		</line>
	</xsl:template>

	<!-- Draw the bars for a single question -->
	<xsl:template match="answers/q">
		<xsl:param name="y" select="0"/>
		<xsl:variable name="nbr_respondents" select="count(a)"/>
		<xsl:variable name="width1" select="count(a[number() = 1]) div $nbr_respondents * $bar-width"/>
		<xsl:variable name="width2" select="count(a[number() = 2]) div $nbr_respondents * $bar-width"/>
		<xsl:variable name="width3" select="count(a[number() = 3]) div $nbr_respondents * $bar-width"/>
		<xsl:variable name="width4" select="count(a[number() = 4]) div $nbr_respondents * $bar-width"/>
		<xsl:variable name="width5" select="count(a[number() = 5]) div $nbr_respondents * $bar-width"/>

		<xsl:call-template name="bar">
			<xsl:with-param name="nbr" select="5"/>
			<xsl:with-param name="y" select="$y"/>
			<xsl:with-param name="x" select="$text-width"/>
			<xsl:with-param name="width" select="$width5"/>
		</xsl:call-template>
		<xsl:call-template name="bar">
			<xsl:with-param name="nbr" select="4"/>
			<xsl:with-param name="y" select="$y"/>
			<xsl:with-param name="x" select="$text-width + $width5"/>
			<xsl:with-param name="width" select="$width4"/>
		</xsl:call-template>
		<xsl:call-template name="bar">
			<xsl:with-param name="nbr" select="3"/>
			<xsl:with-param name="y" select="$y"/>
			<xsl:with-param name="x" select="$text-width + $width5 + $width4"/>
			<xsl:with-param name="width" select="$width3"/>
		</xsl:call-template>
		<xsl:call-template name="bar">
			<xsl:with-param name="nbr" select="2"/>
			<xsl:with-param name="y" select="$y"/>
			<xsl:with-param name="x" select="$text-width + $width5 + $width4 + $width3"/>
			<xsl:with-param name="width" select="$width2"/>
		</xsl:call-template>
        <xsl:call-template name="bar">
			<xsl:with-param name="nbr" select="1"/>
			<xsl:with-param name="y" select="$y"/>
			<xsl:with-param name="x" select="$text-width + $width5 + $width4 + $width3 + $width2"/>
			<xsl:with-param name="width" select="$width1"/>
		</xsl:call-template>

	</xsl:template>

	<!-- Draw a single question, including the label -->
	<xsl:template match="g:tally-graph/g:group/g:q">
		<xsl:param name="answers" select="/.."/>
		<xsl:param name="group_y" select="0"/>
		<xsl:variable name="y" select="$group_y + count(preceding-sibling::g:q) * ($line-height + $line-spacing)"/>

		<g>
			<xsl:if test="$text-width > 0">
				<text x="{$text-width - 6}px" y="{$y + $line-height}px" font-size="{$font-size}" font-family="{$font-family}" fill="black" text-anchor="end">
					<xsl:value-of select="."/>
				</text>
			</xsl:if>
			<xsl:apply-templates select="$answers/q[@id = current()/@id]">
				<xsl:with-param name="y" select="$y"/>
			</xsl:apply-templates>
		</g>
	</xsl:template>

	<!-- Draw a group of questions -->
	<xsl:template match="g:tally-graph/g:group">
		<xsl:param name="answers" select="/.."/>
		<xsl:variable name="y" select="$top-group-spacing + (count(preceding-sibling::g:group/g:q)) * ($line-height + $line-spacing) + count(preceding-sibling::g:group) * $group-spacing"/>

		<g>
			<xsl:if test="$text-width > 0">
				<text x="{$text-width - 6}px" y="{$y - 4}px" font-size="{$header-font-size}" font-weight="bold" font-family="{$font-family}" fill="black" text-anchor="end">
					<xsl:value-of select="@name"/>
				</text>
			</xsl:if>
			<xsl:apply-templates select="g:q">
				<xsl:with-param name="answers" select="$answers"/>
				<xsl:with-param name="group_y" select="$y"/>
			</xsl:apply-templates>
		</g>
	</xsl:template>

	<xsl:template match="g:tally-graph">
		<xsl:param name="answers" select="/.."/>
		<svg>
			<xsl:apply-templates select="g:group">
				<xsl:with-param name="answers" select="$answers"/>
			</xsl:apply-templates>
		</svg>
	</xsl:template>
</xsl:stylesheet>
