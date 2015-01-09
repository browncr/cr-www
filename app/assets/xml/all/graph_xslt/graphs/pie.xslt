<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:g="http://www.thecriticalreview.org/xmlns/graph"
	xmlns="http://www.w3.org/2000/svg"
	version="1.0">

    <xsl:include href="../svg.xslt"/>

	<xsl:param name="pie-radius" select="200"/>

	<xsl:param name="pie-legend-width" select="150" />
	<xsl:param name="pie-legend-x" select="$pie-radius * 2 + 10" />
	<xsl:param name="pie-legend-y" select="10" />

	<xsl:param name="pie-graph-width" select="$pie-legend-x + $pie-legend-width"/>
	<xsl:param name="pie-graph-height" select="$pie-radius * 2"/>

	<xsl:template match="g:pie-graph/g:ans">
		<xsl:param name="answers" select="/.."/>
		<xsl:param name="start_angle" select="0"/>

		<xsl:variable name="count" select="count($answers[not(@id) and string() = current()/@id]) + sum($answers[@id = current()/@id])"/>
		<xsl:variable name="total" select="count($answers[not(@id)]) + sum($answers[boolean(@id)])"/>
		<xsl:variable name="span" select="($count div $total) * 360"/>

		<xsl:call-template name="pie-slice">
			<xsl:with-param name="id" select="generate-id()"/>
			<xsl:with-param name="color" select="string(g:color)"/>
			<xsl:with-param name="start" select="$start_angle"/>
			<xsl:with-param name="span" select="$span"/>
			<xsl:with-param name="radius" select="$pie-radius"/>
			<xsl:with-param name="origin_x" select="$pie-radius"/>
			<xsl:with-param name="origin_y" select="$pie-radius"/>
		</xsl:call-template>

		<xsl:apply-templates select="following-sibling::g:ans[1]">
			<xsl:with-param name="answers" select="$answers"/>
			<xsl:with-param name="start_angle" select="$start_angle + $span"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="g:pie-graph/g:ans" mode="g:legend">
		<xsl:param name="answers" select="/.."/>
		<xsl:call-template name="pie-legend-item">
			<xsl:with-param name="index" select="position() - 1"/>
			<xsl:with-param name="label" select="g:title"/>
			<xsl:with-param name="color" select="g:color"/>
			<xsl:with-param name="count" select="count($answers[not(@id) and string() = current()/@id]) + sum($answers[@id = current()/@id])"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="g:pie-graph">
		<xsl:param name="answers" select="/.."/>
		<xsl:variable name="this_answers" select="$answers/q[@id=current()/@question-id]/a"/>
		<svg width="{$pie-graph-width}" height="{$pie-graph-height}" viewBox="0 0 {$pie-graph-width} {$pie-graph-height}">
			<!-- Slices -->
			<xsl:apply-templates select="g:ans[1]">
				<xsl:with-param name="answers" select="$this_answers"/>
			</xsl:apply-templates>
			<!-- Legend -->
			<g transform="translate({$pie-legend-x} {$pie-legend-y})">
				<xsl:apply-templates select="g:ans" mode="g:legend">
					<xsl:with-param name="answers" select="$this_answers"/>
				</xsl:apply-templates>
			</g>
		</svg>
	</xsl:template>
</xsl:stylesheet>
