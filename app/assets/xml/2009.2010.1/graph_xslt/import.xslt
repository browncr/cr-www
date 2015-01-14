<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Registrar Data Import - The Critical Review</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/import.css" />
	<!-- Place dummy text nodes inside script tags for Internet Explorer. -->
	<script type="text/javascript" src="/assets/{$assets_version}/js/support.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/assets/{$assets_version}/js/common.js"><xsl:text> </xsl:text></script>
</xsl:variable>
<xsl:variable name="staff_sidebar" select="true()"/>

<xsl:template match="import">
	<div id="content">
		<h3>Import Registrar Course Data</h3>

		<p>Use this form to import course data from the Registrar.  <a href="https://secure.thecriticalreview.org/trac/wiki/RegistrarData">Consult the wiki</a> for information about obtaining the data.</p>

		<p class="import-warning"><strong>Read this carefully before uploading.  Failure to adhere to these instructions will result in data corruption.</strong></p>

		<h4>Data Format</h4>

		<ul>
			<li>The data must be a comma-separated-values (CSV) file, with one course per line, with fields separated by a delimiter. Note that contrary to the name, commas are NOT the delimiter.</li>
			<li>The field delimiter must be a tilde: <strong>~</strong></li>
			<li>The character set encoding must be: <strong>Unicode (UTF-8)</strong> (this is important to get right because some course titles and professor names have accented characters).</li>
			<li>The must be no text delimiter, quoting, or escaping.</li>
			<li>There must be no header row or other superfluous content (i.e. the first row should be the first course).</li>
		</ul>

		<p>The columns of the CSV should be <strong>exactly</strong>:</p>

		<table>
			<tr><th>Column A</th><td>Department Name</td></tr>
			<tr><th>Column B</th><td>Department Code</td></tr>
			<tr><th>Column C</th><td>Course Number</td></tr>
			<tr><th>Column D</th><td>Section</td></tr>
			<tr><th>Column E</th><td>CRN</td></tr>
			<tr><th>Column F</th><td>Title</td></tr>
			<tr><th>Column G</th><td>Professor in <strong>Last, First</strong> format</td></tr>
			<tr><th>Column H</th><td>Freshmen</td></tr>
			<tr><th>Column I</th><td>Sophomores</td></tr>
			<tr><th>Column J</th><td>Juniors</td></tr>
			<tr><th>Column K</th><td>Seniors</td></tr>
			<tr><th>Column L</th><td>Other</td></tr>
			<tr><th>Column M</th><td>Total enrollment</td></tr>
		</table>

		<p>There should be no other columns.  Sometimes the registrar uses multiple columns for the title.  Remove the superfluous columns.</p>

		<h4>Generating the CSV</h4>

		<ol>
			<li>Open the XLS file from the registrar in OpenOffice.</li>
			<li>Ensure the columns are in the correct order. Rearrange as necessary.</li>
			<li>Delete the extraneous rows and columns.</li>
			<li>Go to File->Save As and save as a CSV.</li>
			<li>Specify the following when prompted:
				<ul>
					<li>Character set: Unicode (UTF-8)</li>
					<li>Field delimiter: ~</li>
					<li>Text delimiter:</li>
					<li>Save cell content as shown: checked</li>
					<li>Fixed column width: not checked</li>
				</ul>
			</li>
		</ol>
		<p>You can probably use Excel, but be careful.  In particular, make sure you use Unicode (UTF-8) encoding.</p>

		<h4>Upload the CSV</h4>

		<form action="/cr.php?action=import;command=upload" method="post" enctype="multipart/form-data">
			<xsl:copy-of select="$csrf_token_input"/>

			<p>
				Semester the <strong>courses were offered</strong> (i.e. this semester):
				<select name="edition">
					<option></option>
					<xsl:for-each select="editions/edition">
						<xsl:sort select="@name" order="descending"/>
						<option value="{@name}"><xsl:value-of select="."/></option>
					</xsl:for-each>
				</select>
				Don't see the right semester?  Visit <a href="/cr.php?action=editions_admin">Editions Management</a>.
			</p>

			<p>
				CSV File:
				<input type="file" name="csvfile" />
			</p>

			<p>
				<input type="submit" name="submit_button" value="Upload"/>
			</p>
		</form>
	</div>
</xsl:template>
<xsl:template match="import2">
	<div id="content">
		<h3>Results of Course Data Import</h3>

		<p>Examine the log below for any irregularities or courses which may have been erroneously filtered.  In particular, pay attention to courses which were filtered due to "Blacklisted Phrase in Course Name."  To override the filter, check the box next to each course which should be added and press the button at the bottom of the page.</p>

		<form action="/cr.php?action=import;command=override_filter" method="post">
			<xsl:copy-of select="$csrf_token_input"/>

			<input type="hidden" name="edition" value="{@edition}"/>

			<ul>
				<xsl:for-each select="course">
					<li>
						<xsl:if test="@filtered = 'yes'">
							<input type="checkbox" name="override_filter[]" value="{@line}"/>
						</xsl:if>
						Line <xsl:value-of select="@lineno"/> - <xsl:value-of select="concat(@dept, @num, '-', @section)"/> - <xsl:value-of select="@title"/>
						<xsl:if test="@filtered = 'yes'">: Filtered</xsl:if>
						<xsl:if test="count(notice) = 1">
							<xsl:text>: </xsl:text><xsl:value-of select="notice"/>
						</xsl:if>
						<xsl:if test="count(notice) > 1">
							<ul>
								<xsl:for-each select="notice"><li><xsl:value-of select="."/></li></xsl:for-each>
							</ul>
						</xsl:if>
					</li>
				</xsl:for-each>
			</ul>

			<p class="instructions">To include courses that were filtered, check them off above and click the button below.</p>
			<p>
				<input type="submit" name="submit_button" value="Override Filter"/>
			</p>
		</form>
	</div>
</xsl:template>
</xsl:stylesheet>
