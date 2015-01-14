<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml="http://www.w3.org/1999/xhtml">

<xsl:include href="svg.xslt" />

<xsl:variable name="tally-colors" select="document(concat('/xml/', /cr/view/review/@edition, '/tally_colors.xml'))/tally-colors"/>
<xsl:variable name="average-box-colors" select="document('/xml/all/average_box_colors.xml')/tally-colors"/>

<xsl:template match="tally-colors/color">
	<xsl:text>rgb(</xsl:text>
	<xsl:value-of select="r"/>
	<xsl:text>,</xsl:text>
	<xsl:value-of select="g"/>
	<xsl:text>,</xsl:text>
	<xsl:value-of select="b"/>
	<xsl:text>)</xsl:text>
</xsl:template>


<!--
	*** Enrollment stats ***
-->
<xsl:template match="enrollment">
	<table class="stats">
		<tr>
			<th title="Freshmen">Frosh:</th><td><xsl:value-of select="number(frosh)"/></td>
			<th title="Sophomores">Soph:</th><td><xsl:value-of select="number(soph)"/></td>
			<th title="Juniors">Jun:</th><td><xsl:value-of select="number(jun)"/></td>
		</tr>
		<tr>
			<th title="Seniors">Sen:</th><td><xsl:value-of select="number(sen)"/></td>
			<th title="Graduate Students">Grad:</th><td><xsl:value-of select="number(grad)"/></td>
			<th title="Total Enrollment">Total:</th><td><xsl:value-of select="number(total)"/></td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="enrollment[frosh + soph + jun + sen + grad = 0]" mode="pie-graph" priority="10">
	<p>Sorry, data not available.</p>
</xsl:template>

<xsl:template match="enrollment" mode="pie-graph">
	<xsl:param name="pie-radius" select="200"/>

	<xsl:param name="pie-legend-width" select="150" />
	<xsl:param name="pie-legend-x" select="$pie-radius * 2 + 10" />
	<xsl:param name="pie-legend-y" select="10" />

	<xsl:param name="pie-graph-width" select="$pie-legend-x + $pie-legend-width"/>
	<xsl:param name="pie-graph-height" select="$pie-radius * 2"/>

	<!--
		Note: enrollment has a <total> element but prior to Fall 2008 you can't trust it because
		writers entered by hand.  Therefore, it's safer to sum each year.
	-->
	<xsl:variable name="total" select="frosh + soph + jun + sen + grad"/>

	<xsl:variable name="frosh" select="frosh div $total * 360"/>
	<xsl:variable name="soph" select="soph div $total * 360"/>
	<xsl:variable name="jun" select="jun div $total * 360"/>
	<xsl:variable name="sen" select="sen div $total * 360"/>
	<xsl:variable name="grad" select="grad div $total * 360"/>

	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<svg xmlns="http://www.w3.org/2000/svg" width="{$pie-graph-width}" height="{$pie-graph-height}" viewBox="0 0 {$pie-graph-width} {$pie-graph-height}">
				<!-- Slices -->
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="generate-id(frosh)"/>
					<xsl:with-param name="color">#F00</xsl:with-param>
					<xsl:with-param name="start" select="0"/>
					<xsl:with-param name="span" select="$frosh"/>
					<xsl:with-param name="radius" select="$pie-radius"/>
					<xsl:with-param name="origin_x" select="$pie-radius"/>
					<xsl:with-param name="origin_y" select="$pie-radius"/>
				</xsl:call-template>
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="generate-id(soph)"/>
					<xsl:with-param name="color">#00F</xsl:with-param>
					<xsl:with-param name="start" select="$frosh"/>
					<xsl:with-param name="span" select="$soph"/>
					<xsl:with-param name="radius" select="$pie-radius"/>
					<xsl:with-param name="origin_x" select="$pie-radius"/>
					<xsl:with-param name="origin_y" select="$pie-radius"/>
				</xsl:call-template>
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="generate-id(jun)"/>
					<xsl:with-param name="color">#090</xsl:with-param>
					<xsl:with-param name="start" select="$frosh + $soph"/>
					<xsl:with-param name="span" select="$jun"/>
					<xsl:with-param name="radius" select="$pie-radius"/>
					<xsl:with-param name="origin_x" select="$pie-radius"/>
					<xsl:with-param name="origin_y" select="$pie-radius"/>
				</xsl:call-template>
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="generate-id(sen)"/>
					<xsl:with-param name="color">#909</xsl:with-param>
					<xsl:with-param name="start" select="$frosh + $soph + $jun"/>
					<xsl:with-param name="span" select="$sen"/>
					<xsl:with-param name="radius" select="$pie-radius"/>
					<xsl:with-param name="origin_x" select="$pie-radius"/>
					<xsl:with-param name="origin_y" select="$pie-radius"/>
				</xsl:call-template>
				<xsl:call-template name="pie-slice">
					<xsl:with-param name="id" select="generate-id(grad)"/>
					<xsl:with-param name="color">#FF0</xsl:with-param>
					<xsl:with-param name="start" select="$frosh + $soph + $jun + $sen"/>
					<xsl:with-param name="span" select="$grad"/>
					<xsl:with-param name="radius" select="$pie-radius"/>
					<xsl:with-param name="origin_x" select="$pie-radius"/>
					<xsl:with-param name="origin_y" select="$pie-radius"/>
				</xsl:call-template>

				<!-- Legend -->
				<g transform="translate({$pie-legend-x} {$pie-legend-y})">
					<xsl:call-template name="pie-legend-item">
						<xsl:with-param name="index" select="0"/>
						<xsl:with-param name="label">Frosh</xsl:with-param>
						<xsl:with-param name="color">#F00</xsl:with-param>
						<xsl:with-param name="count" select="frosh"/>
					</xsl:call-template>
				</g>
				<g transform="translate({$pie-legend-x} {$pie-legend-y})">
					<xsl:call-template name="pie-legend-item">
						<xsl:with-param name="index" select="1"/>
						<xsl:with-param name="label">Soph</xsl:with-param>
						<xsl:with-param name="color">#00F</xsl:with-param>
						<xsl:with-param name="count" select="soph"/>
					</xsl:call-template>
				</g>
				<g transform="translate({$pie-legend-x} {$pie-legend-y})">
					<xsl:call-template name="pie-legend-item">
						<xsl:with-param name="index" select="2"/>
						<xsl:with-param name="label">Jun</xsl:with-param>
						<xsl:with-param name="color">#090</xsl:with-param>
						<xsl:with-param name="count" select="jun"/>
					</xsl:call-template>
				</g>
				<g transform="translate({$pie-legend-x} {$pie-legend-y})">
					<xsl:call-template name="pie-legend-item">
						<xsl:with-param name="index" select="3"/>
						<xsl:with-param name="label">Sen</xsl:with-param>
						<xsl:with-param name="color">#909</xsl:with-param>
						<xsl:with-param name="count" select="sen"/>
					</xsl:call-template>
				</g>
				<g transform="translate({$pie-legend-x} {$pie-legend-y})">
					<xsl:call-template name="pie-legend-item">
						<xsl:with-param name="index" select="4"/>
						<xsl:with-param name="label">Grad</xsl:with-param>
						<xsl:with-param name="color">#FF0</xsl:with-param>
						<xsl:with-param name="count" select="grad"/>
					</xsl:call-template>
				</g>
			</svg>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
	
<xsl:template match="tally-summary" mode="conc-graph">
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<xsl:apply-templates select="." mode="graph">
				<xsl:with-param name="graph-layout" select="document('/xml/all/graphs/concentrators.xml')"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
<xsl:template match="tally-summary" mode="graded-graph">
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<xsl:apply-templates select="." mode="graph">
				<xsl:with-param name="graph-layout" select="document('/xml/all/graphs/graded.xml')"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
<xsl:template match="tally-summary" mode="requirement-graph">
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<xsl:apply-templates select="." mode="graph">
				<xsl:with-param name="graph-layout" select="document('/xml/all/graphs/requirement.xml')"/>
			</xsl:apply-templates>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="avg-scale">
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<svg xmlns="http://www.w3.org/2000/svg" width="201" height="20" viewBox="0 0 201 20">
				<defs>
					<linearGradient id="avg-scale-gradient">
						<xsl:for-each select="$average-box-colors/color[@value &lt;= 4]">
							<xsl:sort select="@value" data-type="number"/>
							<stop offset="{(position() - 1) div (last() - 1)}">
								<xsl:attribute name="stop-color">
									<xsl:apply-templates select="."/>
								</xsl:attribute>
							</stop>
						</xsl:for-each>
						<!--
						<stop offset="0">
							<xsl:attribute name="stop-color"><xsl:apply-templates select="$tally-colors/color[@value=1]"/></xsl:attribute>
						</stop>
						<stop offset="1">
							<xsl:attribute name="stop-color">#FFF</xsl:attribute>
						</stop>
						-->
					</linearGradient>
				</defs>
				<rect x="0" y="0" width="100%" height="100%" fill="url(#avg-scale-gradient)"/>
				<text x="2%" y="50%" dominant-baseline="middle" font-family="sans-serif" font-size="12" fill="black">1</text>
				<text x="33%" y="50%" dominant-baseline="middle" font-family="sans-serif" font-size="12" fill="black" text-anchor="middle">2</text>
				<text x="66%" y="50%" dominant-baseline="middle" font-family="sans-serif" font-size="12" fill="black" text-anchor="middle">3</text>
				<text x="98%" y="50%" dominant-baseline="middle" font-family="sans-serif" font-size="12" fill="black" text-anchor="end">4</text>
			</svg>
		</xsl:with-param>
		<xsl:with-param name="fallback">
			<!--
			<img src="/images/avg-scale.png" alt="" />
			-->
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="tally-key">
	<xsl:param name="line-width" select="12"/>
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<svg xmlns="http://www.w3.org/2000/svg" width="400" height="60" viewBox="0 0 400 60">
				<text x="0" y="15" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="left">Key</text>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="0" x2="70" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=1]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="71" x2="141" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=2]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="142" x2="212" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=3]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="213" x2="283" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=4]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="284" x2="354" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=5]"/>
					</xsl:attribute>
				</line>
				<rect shape-rendering="crispEdges" x="355" y="30" width="40" height="{$line-width - 1}" fill="rgb(255,255,255)" stroke="black" stroke-width="1" stroke-dasharray="1,1"/>
				<text x="35" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%1s</text>
				<text x="106" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%2s</text>
				<text x="177" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%3s</text>
                <text x="248" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%4s</text>
				<text x="319" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%5s</text>
				<text x="374" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%N/As</text>
			</svg>
		</xsl:with-param>
		<xsl:with-param name="fallback">
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="old-tally-key">
	<xsl:param name="line-width" select="12"/>
	<xsl:call-template name="svg">
		<xsl:with-param name="svg">
			<svg xmlns="http://www.w3.org/2000/svg" width="400" height="60" viewBox="0 0 400 60">
				<text x="0" y="15" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="left">Key</text>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="0" x2="120" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=1]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="121" x2="241" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=2]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="242" x2="292" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=3]"/>
					</xsl:attribute>
				</line>
				<line shape-rendering="crispEdges" stroke-width="{$line-width}" x1="293" x2="343" y1="{30 + $line-width div 2}" y2="{30 + $line-width div 2}">
					<xsl:attribute name="stroke">
						<xsl:apply-templates select="$tally-colors/color[@value=4]"/>
					</xsl:attribute>
				</line>
				<rect shape-rendering="crispEdges" x="345" y="30" width="30" height="{$line-width - 1}" fill="rgb(255,255,255)" stroke="black" stroke-width="1" stroke-dasharray="1,1"/>
				<text x="60" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%1s</text>
				<text x="180" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%2s</text>
				<text x="266" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%3s</text>
                <text x="317" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%4s</text>
				<text x="377" y="{$line-width + 44}" font-family="sans-serif" font-size="13" fill="black" font-weight="bold" text-anchor="middle">%N/As</text>
			</svg>
		</xsl:with-param>
		<xsl:with-param name="fallback">
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>


<xsl:template name="css-color">
	<xsl:param name="r" select="0"/>
	<xsl:param name="g" select="0"/>
	<xsl:param name="b" select="0"/>
	rgb(<xsl:value-of select="round($r)"/>,<xsl:value-of select="round($g)"/>,<xsl:value-of select="round($b)"/>)
</xsl:template>
<xsl:template name="color-blend">
	<xsl:param name="r1" select="0"/>
	<xsl:param name="g1" select="0"/>
	<xsl:param name="b1" select="0"/>
	<xsl:param name="r2" select="0"/>
	<xsl:param name="g2" select="0"/>
	<xsl:param name="b2" select="0"/>
	<xsl:param name="amount" select="0"/>
	<xsl:call-template name="css-color">
		<xsl:with-param name="r" select="$r1 + ($r2 - $r1) * $amount"/>
		<xsl:with-param name="g" select="$g1 + ($g2 - $g1) * $amount"/>
		<xsl:with-param name="b" select="$b1 + ($b2 - $b1) * $amount"/>
	</xsl:call-template>
</xsl:template>
<xsl:template name="average-color" match="node()|@*" mode="average-color">
	<xsl:param name="average" select="number()"/>
	<xsl:choose>
		<xsl:when test="$average &lt; 2.00">
			<xsl:call-template name="color-blend">
				<xsl:with-param name="r1" select="$average-box-colors/color[@value=1]/r"/>
				<xsl:with-param name="g1" select="$average-box-colors/color[@value=1]/g"/>
				<xsl:with-param name="b1" select="$average-box-colors/color[@value=1]/b"/>
				<xsl:with-param name="r2" select="$average-box-colors/color[@value=2]/r"/>
				<xsl:with-param name="g2" select="$average-box-colors/color[@value=2]/g"/>
				<xsl:with-param name="b2" select="$average-box-colors/color[@value=2]/b"/>
				<xsl:with-param name="amount" select="$average - 1.00"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$average &lt; 3.00">
			<xsl:call-template name="color-blend">
				<xsl:with-param name="r1" select="$average-box-colors/color[@value=2]/r"/>
				<xsl:with-param name="g1" select="$average-box-colors/color[@value=2]/g"/>
				<xsl:with-param name="b1" select="$average-box-colors/color[@value=2]/b"/>
				<xsl:with-param name="r2" select="$average-box-colors/color[@value=3]/r"/>
				<xsl:with-param name="g2" select="$average-box-colors/color[@value=3]/g"/>
				<xsl:with-param name="b2" select="$average-box-colors/color[@value=3]/b"/>
				<xsl:with-param name="amount" select="$average - 2.00"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="$average &lt;= 4.00">
			<xsl:call-template name="color-blend">
				<xsl:with-param name="r1" select="$average-box-colors/color[@value=3]/r"/>
				<xsl:with-param name="g1" select="$average-box-colors/color[@value=3]/g"/>
				<xsl:with-param name="b1" select="$average-box-colors/color[@value=3]/b"/>
				<xsl:with-param name="r2" select="$average-box-colors/color[@value=4]/r"/>
				<xsl:with-param name="g2" select="$average-box-colors/color[@value=4]/g"/>
				<xsl:with-param name="b2" select="$average-box-colors/color[@value=4]/b"/>
				<xsl:with-param name="amount" select="$average - 3.00"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="average-color-brightness" match="node()|@*" mode="average-color-brightness">
	<xsl:param name="average" select="number()"/>
	<xsl:call-template name="color-blend">
		<xsl:with-param name="r1" select="$tally-colors/color[@value=1]/r"/>
		<xsl:with-param name="g1" select="$tally-colors/color[@value=1]/g"/>
		<xsl:with-param name="b1" select="$tally-colors/color[@value=1]/b"/>
		<xsl:with-param name="r2" select="255"/>
		<xsl:with-param name="g2" select="255"/>
		<xsl:with-param name="b2" select="255"/>
		<xsl:with-param name="amount" select="$average div 4.00"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="average-box-style" match="node()|@*" mode="average-box-style">
	<xsl:param name="average" select="number()"/>
	<xsl:attribute name="style">
		<!--
		background-color: <xsl:call-template name="average-color"><xsl:with-param name="average" select="$average"/></xsl:call-template>;
		<xsl:if test="$average &lt; 2.20"> color: white;</xsl:if></xsl:attribute>
		-->
		background-color: <xsl:call-template name="average-color"><xsl:with-param name="average" select="$average"/></xsl:call-template>;
	</xsl:attribute>
</xsl:template>

<xsl:template match="tally-summary/q" mode="average-box">
	<xsl:param name="desc"/>
	<xsl:variable name="average" select="(1 * sum(a[@id=1]) + 2 * sum(a[@id=2]) + 3 * sum(a[@id=3]) + 4 * sum(a[@id=4])) div sum(a[@id != 5])"/>
	<div class="box">
		<div class="inner">
			<xsl:call-template name="average-box-style">
				<xsl:with-param name="average" select="$average"/>
			</xsl:call-template>
			<p class="avg"><xsl:value-of select="format-number($average, '#.##')"/></p>
			<p class="desc"><xsl:value-of select="$desc"/></p>
		</div>
	</div>
</xsl:template>

<xsl:template match="review" mode="banner-schedule-uri">
	<!-- https://selfservice.brown.edu/ss/bwckschd.p_get_crse_unsec?term_in=201110&sel_subj=dummy&sel_day=dummy&sel_schd=dummy&sel_insm=dummy&sel_camp=dummy&sel_levl=dummy&sel_sess=dummy&sel_instr=dummy&sel_ptrm=dummy&sel_attr=dummy&sel_subj=MATH&sel_crse=0520&sel_title=&sel_schd=%25&sel_from_cred=&sel_to_cred=&sel_levl=%25&sel_instr=%25&sel_attr=%25&begin_hh=0&begin_mi=0&begin_ap=a&end_hh=0&end_mi=0&end_ap=a -->
	<xsl:text>https://selfservice.brown.edu/ss/bwckschd.p_get_crse_unsec?term_in=</xsl:text>
	<xsl:apply-templates select="/cr/edition/current" mode="banner-term"/>
	<xsl:text>&amp;sel_subj=dummy&amp;sel_day=dummy&amp;sel_schd=dummy&amp;sel_insm=dummy&amp;sel_camp=dummy&amp;sel_levl=dummy&amp;sel_sess=dummy&amp;sel_instr=dummy&amp;sel_ptrm=dummy&amp;sel_attr=dummy&amp;sel_subj=</xsl:text>
	<xsl:value-of select="department"/>
	<xsl:text>&amp;sel_crse=</xsl:text>
	<xsl:value-of select="course_num"/>
	<xsl:text>&amp;sel_title=&amp;sel_schd=%25&amp;sel_from_cred=&amp;sel_to_cred=&amp;sel_levl=%25&amp;sel_instr=%25&amp;sel_attr=%25&amp;begin_hh=0&amp;begin_mi=0&amp;begin_ap=a&amp;end_hh=0&amp;end_mi=0&amp;end_ap=a</xsl:text>
</xsl:template>

<xsl:template match="review" mode="banner-catalog-uri">
	<!-- https://selfservice.brown.edu/ss/bwckctlg.p_display_courses?term_in=201110&one_subj=MATH&sel_crse_strt=0520&sel_crse_end=0520&sel_subj=&sel_levl=&sel_schd=&sel_coll=&sel_divs=&sel_dept=&sel_attr= -->
	<xsl:text>https://selfservice.brown.edu/ss/bwckctlg.p_display_courses?term_in=</xsl:text>
	<xsl:apply-templates select="/cr/edition/current" mode="banner-term"/>
	<xsl:text>&amp;one_subj=</xsl:text><xsl:value-of select="department"/>
	<xsl:text>&amp;sel_crse_strt=</xsl:text><xsl:value-of select="course_num"/>
	<xsl:text>&amp;sel_crse_end=</xsl:text><xsl:value-of select="course_num"/>
	<xsl:text>&amp;sel_subj=&amp;sel_levl=&amp;sel_schd=&amp;sel_coll=&amp;sel_divs=&amp;sel_dept=&amp;sel_attr=</xsl:text>
</xsl:template>

<!--
	*** Tally stats (concs, non-concs, etc.) ***
-->
<xsl:template match="tally">
	<table class="stats">
		<tr>
			<th title="Concentrators">Concs:</th><td><xsl:value-of select="number(concs)"/></td>
			<th title="Number of respondents who are unsure of their concentration">Undecided:</th><td><xsl:value-of select="number(dunno)"/></td>
		</tr>
		<tr>
			<th title="Non-concentrators">Non-concs:</th><td><xsl:value-of select="number(nonconcs)"/></td>
			<th title="Total number of respondents">Respondents:</th><td><xsl:value-of select="number(num_respondents)"/></td>
		</tr>
	</table>
</xsl:template>


<!--
	*** Review details (course code, instructors, department, stats, etc.) ***
-->
<xsl:template name="review_details">
	<table class="details"><tr>
		<td><ul>
			<li>
				<label>Course Code:</label><xsl:text> </xsl:text>
				<a href="/cr_xml.php?action=browse;department={department};number={course_num}" title="See more reviews for this course"><xsl:apply-templates select="." mode="course-code"/></a>
				<xsl:text> (</xsl:text>
				<a href="http://brown.mochacourses.com/mocha/search.action?q={department}{course_num}" title="See this course in Mocha">Mocha</a>)
			</li>
			<li>
				<label>Instructor(s):</label><xsl:text> </xsl:text>
				<a href="/cr_xml.php?action=browse;professor={professor};exact=1" title="See more reviews for this professor"><xsl:value-of select="professor"/></a>
				<xsl:text> (</xsl:text>
				<a href="http://brown.mochacourses.com/mocha/search.action?professor={professor}" title="See this professor in Mocha">Mocha</a>)
			</li>
			<li>
				<label>Department:</label><xsl:text> </xsl:text>
				<a href="/cr_xml.php?action=browse;department={department}" title="See more reviews for this department"><xsl:value-of select="/cr/departments/dept[@banner = current()/department]"/></a>
			</li>
			<li>
				<label>Format:</label><xsl:text> </xsl:text>
				<xsl:value-of select="courseformat"/>
			</li>
			<li>
				<label>CRN:</label><xsl:text> </xsl:text><xsl:value-of select="crn"/>
			</li>
		</ul></td>

		<td class="stats">
			<xsl:apply-templates select="enrollment"/>
			<xsl:apply-templates select="tally"/>
		</td>

	</tr>
	</table>
</xsl:template>

<!--
	*** The review text ***
-->

<!-- When insufficient information was provided... -->
<xsl:template match="content[number(../unreturned)]" priority="9">
	<p>Questionnaires not returned.</p>
</xsl:template>
<xsl:template match="content[number(../insufficient)]" priority="10">
	<p>Insufficient information provided.</p>
</xsl:template>

<!-- When actual content was provided... -->
<xsl:template match="content[xhtml:*]" priority="9">
	<div class="review_content">
		<xsl:copy-of select="xhtml:*"/>
	</div>
</xsl:template>
<xsl:template match="content" priority="8">
	<div class="review_content">
		<xsl:apply-templates mode="content"/>
	</div>
</xsl:template>
<xsl:template match="p" mode="content">
	<p>
		<xsl:if test="count(preceding-sibling::p) = 0">
			<xsl:attribute name="class">first</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates mode="content"/>
	</p>
</xsl:template>
<xsl:template match="code" mode="content">
	<a href="/{@dept}/{@num}"><xsl:apply-templates mode="content"/></a>
</xsl:template>
<xsl:template match="diff-added" mode="content">
	<span class="diff-added"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="diff-modified" mode="content">
	<span class="diff-modified"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="diff-removed" mode="content">
	<span class="diff-removed"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template name="review_text">
	<div class="text">
		<!-- With the graph floating to the right... -->
		<xsl:if test="number(tally/num_respondents) &gt; 3">
			<div class="graph">
				<p class="avg">
					<label>Prof Avg:</label><xsl:text> </xsl:text><xsl:value-of select="format-number(tally/profavg, '#.##')"/>
					<xsl:text> </xsl:text>
					<label>Course Avg:</label><xsl:text> </xsl:text><xsl:value-of select="format-number(tally/courseavg, '#.##')"/>
				</p>
				<!--
				<p>
					<a class="expand" href="javascript:void(0);" onclick="remove_class(this.parentNode.parentNode, 'collapsed');">Show legend</a>
					<a class="collapse" href="javascript:void(0);" onclick="add_class(this.parentNode.parentNode, 'collapsed');">Hide legend</a>
				</p>
				-->
				<p>
					<xsl:choose>
						<xsl:when test="tally/@format = 'old' or tally/@format = 'blob'">
							<img class="legend" src="/images/editions/{@edition}/legend.gif" alt="Legend Describing Graph" />
							<img class="graph" src="/getimage.php?newreviewid={@id}" alt="Graph Summarizing Students' Responses"/>
						</xsl:when>
						<xsl:when test="tally/@format = 'xml'">
							<img class="graph" src="/graph.php?id={@id}" alt="Graph Summarizing Students' Responses"/>
						</xsl:when>
					</xsl:choose>
				</p>
				<p><img class="key" src="/images/editions/{@edition}/key.gif" alt="Legend Describing Graph" /></p>
			</div>
		</xsl:if>

		<!-- Review text goes here: -->
		<xsl:apply-templates select="content"/>

		<!-- Make sure the graph doesn't extend past the black border: -->
		<p class="clearer"></p>
	</div>
</xsl:template>


</xsl:stylesheet>
