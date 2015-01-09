<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink">



	<xsl:template name="pie-slice">
		<xsl:param name="id" select="generate-id()"/>
		<xsl:param name="color">black</xsl:param>
		<xsl:param name="start" select="0"/>
		<xsl:param name="span" select="0"/>
		<xsl:param name="radius" select="200"/>
		<xsl:param name="origin_x" select="$radius"/>
		<xsl:param name="origin_y" select="$radius"/>

		<xsl:choose>
			<xsl:when test="$span &lt; 0">
				<!--
					Normalize the negative span by adding it to the start angle
					and then negating the spam.
					e.g. a slice from 45 with span of -30 becomes slice from 15 with span of 30
				-->
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="$id"/>
					<xsl:with-param name="color" select="$color"/>
					<xsl:with-param name="start" select="$start + $span"/>
					<xsl:with-param name="span" select="-$span"/>
					<xsl:with-param name="radius" select="$radius"/>
					<xsl:with-param name="origin_x" select="$origin_x"/>
					<xsl:with-param name="origin_y" select="$origin_y"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$span &gt; 180">
				<!--
					Split this big slice into several slices - one which covers the first 180 degrees
					and another (one or more) which covers the remainder

					Note: although the first slice covers 180 degrees, we start the second slice at
					90 degrees from the start, so we're essentially overlapping the second slice on
					top of the first slice.  We do this to cover up seams which would occur if we
					started the second slice at start + 180 degrees.
				-->
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="concat($id,'-1')"/>
					<xsl:with-param name="color" select="$color"/>
					<xsl:with-param name="start" select="$start"/>
					<xsl:with-param name="span" select="180"/>
					<xsl:with-param name="radius" select="$radius"/>
					<xsl:with-param name="origin_x" select="$origin_x"/>
					<xsl:with-param name="origin_y" select="$origin_y"/>
				</xsl:call-template>
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="concat($id,'-2')"/>
					<xsl:with-param name="color" select="$color"/>
					<xsl:with-param name="start" select="$start + 90"/>
					<xsl:with-param name="span" select="$span - 90"/>
					<xsl:with-param name="radius" select="$radius"/>
					<xsl:with-param name="origin_x" select="$origin_x"/>
					<xsl:with-param name="origin_y" select="$origin_y"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$span != 0">
				<xsl:variable name="path_rotation" select="$start"/>
				<xsl:variable name="clip_rotation" select="$span - 180"/>

				<defs>
					<clipPath id="pie-slice-clip{$id}">
						<path d="M{$origin_x},{$origin_y} L{$origin_x},{$origin_y - $radius} A{$radius},{$radius} 0 0,1 {$origin_x},{$origin_y + $radius} z" transform="rotate({$clip_rotation}, {$origin_x}, {$origin_y})"/>
					</clipPath>
				</defs>
				<path d="M{$origin_x},{$origin_y} L{$origin_x},{$origin_y - $radius} A{$radius},{$radius} 0 0,1 {$origin_x},{$origin_y + $radius} z" fill="{$color}" fill-opacity="1" clip-path="url(#pie-slice-clip{$id})" transform="rotate({$path_rotation}, {$origin_x}, {$origin_y})"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="pie-legend-item">
		<xsl:param name="index" select="position() - 1"/>
		<xsl:param name="label"/>
		<xsl:param name="color"/>
		<xsl:param name="count"/>
		<xsl:param name="spacing" select="5" />
		<xsl:param name="height" select="15" />
		<xsl:param name="line-length" select="10" />

		<xsl:variable name="y" select="$index * $height"/>

		<g>
			<text fill="black" font-family="sans-serif" font-size="10" font-weight="bold" dominant-baseline="middle" x="{($line-length + $spacing)}" y="{$y}">
				<xsl:value-of select="$label"/> (<xsl:value-of select="$count"/>)
			</text>
			<rect x="0" y="{$y - $line-length div 2}" width="{$line-length}" height="{$line-length}" fill="{$color}" shape-rendering="crispEdges"/>
		</g>
	</xsl:template>

</xsl:stylesheet>
