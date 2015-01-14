<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" encoding="utf-8" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />

	<!--
	Generate the Javascript serialization of a quiestion's option.  Meant to go inside a [ ] (i.e. array) block.
	Example: { name: "Yes", value: "C", inputs: ["Y", "C"] }, { name: "No", value: "N", inputs: ["N"] }, { name: "Undecided", value: "D", inputs: ["U", "D"] }
	-->
	<xsl:template match="option" mode="javascript">
		<!-- If there was a preceding option, place a comma delimiter -->
		<xsl:if test="position() > 1">
			<xsl:text>, </xsl:text>
		</xsl:if>

		<!-- Specify the English name of the option -->
		<xsl:text>{ name: "</xsl:text>
		<xsl:value-of select="@name" />
		<!-- Specify the value of the option -->
		<xsl:text>", value: "</xsl:text>
		<xsl:value-of select="@value" />
		<!-- Specify an array of valid inputs for this option -->
		<xsl:text>", inputs: [</xsl:text>
		<xsl:for-each select="input">
			<xsl:if test="position() > 1">
				<xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:text>"</xsl:text><xsl:value-of select="." /><xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>] }</xsl:text>
	</xsl:template>

	<!--
	Generate the Javascript serialization for a question. Meant to go inside a { } block.
	Example:
		conc: [ { name: "Yes", value: "C", inputs: ["Y", "C"] }, { name: "No", value: "N", inputs: ["N"] }, { name: "Undecided", value: "D", inputs: ["U", "D"] } ]
	-->
	<xsl:template match="question" mode="javascript">
		<xsl:param name="options" select="ancestor::tally/options"/>

		<!-- If there was a previous question, place a comma delimiter -->
		<xsl:if test="position() > 1">
			<xsl:text>,&#10;</xsl:text>
		</xsl:if>

		<!-- Write the ID of the question -->
		<xsl:text>"</xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text>": [ </xsl:text>

		<!-- Now serialize the options for this question -->
		<xsl:choose>
			<xsl:when test="@type = 'freeform'">
				<!-- Freeform question - no options to serialize -->
				<!-- Instead, serialize the restricted input -->
				<xsl:for-each select="restrict-input">
					<xsl:text>/^</xsl:text><xsl:value-of select="."/><xsl:text>$/</xsl:text>
					<xsl:if test="position() != last()">, </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@options">
				<!-- @options attribute specified - use the options with the specified ID -->
				<xsl:apply-templates select="$options[@id = current()/@options]/option" mode="javascript" />
			</xsl:when>
			<xsl:when test="option">
				<!-- Options specified right here, as child elements -->
				<xsl:apply-templates select="option" mode="javascript" />
			</xsl:when>
			<xsl:otherwise>
				<!-- No options specified -->
				<xsl:message>
					No options for question <xsl:value-of select="@id"/>.
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> ]</xsl:text>
	</xsl:template>

	<!-- Serialize all the Javascript for a bunch of questions -->
	<xsl:template match="questions[@uri]" mode="javascript" priority="10">
		<!-- @uri attribute was specified - fetch the questions from that URI -->
		<xsl:apply-templates select="document(@uri)/tally/questions" mode="javascript"/>
	</xsl:template>
	<xsl:template match="questions" mode="javascript" priority="9">
		<!-- Just serialize each individual question -->
		<xsl:apply-templates select="question|group/question" mode="javascript"/>
	</xsl:template>


	<!-- Create the cell for a question's answer -->
	<xsl:template match="q/a">
		<td class="cell"><span><xsl:value-of select="."/></span></td>
	</xsl:template>
	<!-- Display help for a question -->
	<xsl:template match="help">
		<span class="instructions"><xsl:text> (</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text></span>
	</xsl:template>
	<xsl:template match="question">
		<xsl:param name="answers"/>
		<tr id="{@id}">
			<xsl:if test="@type = 'freeform'">
				<xsl:attribute name="class">freeform</xsl:attribute>
			</xsl:if>
			<td title="{long}"><xsl:value-of select="short"/>?<xsl:apply-templates select="help"/></td>
			<xsl:apply-templates select="$answers/q[@id=current()/@id]/a"/>
		</tr>
	</xsl:template>

	<xsl:template match="questions[@uri]" priority="10">
		<xsl:param name="answers"/>
		<xsl:apply-templates select="document(@uri)/tally/questions">
			<xsl:with-param name="answers" select="$answers"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="questions" priority="9">
		<xsl:param name="answers"/>
		<div id="tally_wrapper">
		<table id="tally">
			<xsl:for-each select="group">
				<tr class="group"><td colspan="{count($answers/q[1]/a) + 1}"><xsl:value-of select="@name" /></td></tr>
				<xsl:apply-templates select="question">
					<xsl:with-param name="answers" select="$answers"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</table>
		</div>
	</xsl:template>

	<xsl:template match="/tally">
		<xsl:param name="questions" select="questions"/>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Critical Review Tally</title>
				<link rel="stylesheet" type="text/css" href="/css/tally.css" />
				<script type="text/javascript" src="/js/support.js"></script>
				<script type="text/javascript" src="/js/tally.js"></script>
				<script type="text/javascript">
					var tally = null;

					register_onload_event(function () {
						var question_options = {
								<xsl:apply-templates select="$questions" mode="javascript" />
						};
						tally = new Tally($("tally"), question_options);
						/*
						window.onbeforeunload = function () {
							if (tally.is_modified())
								return "You have not saved the tally.  If you navigate away without saving, you will LOSE your changes.";
						};
						*/
					});
				</script>
			</head>
			<body>
				<h1>Critical Review Tally</h1>
				<xsl:apply-templates select="$questions">
					<xsl:with-param name="answers" select="answers"/>
				</xsl:apply-templates>
				<a href="javascript:void(0)" onclick="tally.add_column();">Add Column</a><br />
				<a href="javascript:void(0)" onclick="tally.remove_last_column();">Remove Last Column</a><br />
				<a href="javascript:void(0)" onclick="tally.trim_columns();">Trim Columns</a><br />
				<a href="javascript:void(0)" onclick="tally.unselect();">Clear Selection</a><br />
				<a href="javascript:void(0)" onclick="tally.prev_cell();">Prev</a><br />
				<a href="javascript:void(0)" onclick="tally.next_cell();">Next</a><br />
				<a href="javascript:void(0)" onclick="tally.up();">Up</a><br />
				<a href="javascript:void(0)" onclick="tally.down();">Down</a><br />
				<a href="javascript:void(0)" onclick="tally.left();">Left</a><br />
				<a href="javascript:void(0)" onclick="tally.right();">Right</a><br />
				<a href="javascript:void(0)" onclick="alert(tally.serialize_xml());">Serialize XML</a><br />
				<a href="javascript:void(0)" onclick="tally.submit('submit.cgi');">Submit</a><br />


			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
