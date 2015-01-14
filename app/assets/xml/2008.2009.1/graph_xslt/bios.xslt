<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">

<!-- Boilerplate -->
<xsl:import href="base.xslt" />
<xsl:variable name="title">Critical Review Staff Bios</xsl:variable>
<xsl:variable name="scripts">
	<link type="text/css" rel="stylesheet" href="/assets/{$assets_version}/css/bios.css" />
</xsl:variable>

<xsl:template match="ulevels/level">
	<xsl:param name="bios"/>
	<xsl:variable name="count" select="count($bios/person[@ulevel=current()/@nbr])"/>

	<xsl:if test="$count &gt; 0">
		<h4>
			<xsl:choose>
				<xsl:when test="$count = 1">
					<xsl:value-of select="singular"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="plural"/>
				</xsl:otherwise>
			</xsl:choose>
		</h4>

		<xsl:apply-templates select="$bios/person[@ulevel=current()/@nbr]">
			<xsl:sort data-type="number" select="@photo-version and bio != ''" order="descending"/>
			<xsl:sort data-type="number" select="bio != ''" order="descending"/>
			<xsl:sort select="name"/>
		</xsl:apply-templates>
	</xsl:if>
</xsl:template>

<xsl:template name="bio-name">
	<!-- If the bio has a real name, use it.  Otherwise, use the username. -->
	<xsl:choose>
		<xsl:when test="name != ''"><xsl:value-of select="name" /></xsl:when>
		<xsl:otherwise><xsl:value-of select='translate(username, "_", " ")' /></xsl:otherwise>
	</xsl:choose>
	<!-- Editors-in-chief get this special suffix -->
	<!--
	<xsl:if test="@ulevel=5">, Editor-in-Chief</xsl:if>
	-->
</xsl:template>

<xsl:template match="person">
	<div class="bio">
		<!-- (optional) photo -->
		<xsl:if test="@photo-version">
			<img src="/staff_photo/{/cr/bios/@edition}/{@uid}/{@photo-version}" alt="" />
		</xsl:if>
		<div class="header">
			<!-- Name -->
			<h5 id="bio-{@uid}"><xsl:call-template name="bio-name" /></h5>
			<!-- Title -->
			<xsl:if test="title != ''">
				<p class="title"><xsl:value-of select="title" /></p>
			</xsl:if>
		</div>
		<!-- Year -->
		<xsl:if test="year != ''">
			Year: <xsl:value-of select="year" /><br/>
		</xsl:if>
		<!-- Departments -->
		<xsl:if test="dept">
			Departments:
			<xsl:for-each select="dept">
				<!-- TODO: limit browse link to just the edition of this bio, when that is possible -->
				<a href="/{.}"><xsl:value-of select="/cr/departments/dept[@banner = current()]"/></a><xsl:if test="following-sibling::dept">, </xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- Bio text -->
		<xsl:choose>
			<xsl:when test="bio != ''">
				<!-- Non-empty bio -->
				<p class="text"><xsl:value-of select="bio" /></p>
			</xsl:when>
			<xsl:when test="@uid = /cr/user/uid and ../@edition = $next_edition">
				<!-- User's own empty bio -->
				<p class="empty text pester">You have not written your bio yet.  Click the link below now.</p>
			</xsl:when>
			<xsl:otherwise>
				<!-- Empty bio -->
				<p class="empty text">No biography provided.</p>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Link for users to edit their own bio -->
		<xsl:if test="@uid = /cr/user/uid or /cr/user/level > 3 and ../@edition = $next_edition"><a href="/about/bios?edit&amp;u={@uid}">Edit bio</a></xsl:if>
		<p class="clearer" />
	</div>
</xsl:template>

<xsl:template match="bios">
	<xsl:call-template name="about-nav"><xsl:with-param name="current">bios</xsl:with-param></xsl:call-template>
	<div id="content">
		<h3>
			About the Staff
			<xsl:if test="/cr/user/level >= 2"> (<xsl:value-of select="@edition" />)</xsl:if>
		</h3>

		<!-- Link to edit bio -->
		<xsl:if test="/cr/user/level >= 2 and @edition = $next_edition">
			<xsl:if test="person[@uid=/cr/user/uid]/bio = ''"><p class="pester">You have not written your staff bio yet.  Click the button below now!  You know you want to...</p></xsl:if>
			<p><a href="/about/bios?edit" class="button">Edit your bio</a></p>
		</xsl:if>

		<div class="bios">
			<h4>Executive Staff</h4>

			<xsl:apply-templates select="person[@ulevel &gt;= 4]">
				<xsl:sort data-type="number" select="rank" order="ascending"/>
				<xsl:sort select="name"/>
			</xsl:apply-templates>

			<h4>Editors</h4>

			<xsl:apply-templates select="person[@ulevel = 3]">
				<xsl:sort data-type="number" select="@photo-version and bio != ''" order="descending"/>
				<xsl:sort data-type="number" select="bio != ''" order="descending"/>
				<xsl:sort select="name"/>
			</xsl:apply-templates>

			<h4>Writers</h4>

			<xsl:apply-templates select="person[@ulevel = 2]">
				<xsl:sort data-type="number" select="@photo-version and bio != ''" order="descending"/>
				<xsl:sort data-type="number" select="bio != ''" order="descending"/>
				<xsl:sort select="name"/>
			</xsl:apply-templates>
		</div>
	</div>
</xsl:template>

<xsl:template match="edit_bio">
	<div id="content">
		<h3>Edit your Bio</h3>

		<p><a href="/about/bios">&#xAB; Back to Staff Bios</a></p>

		<form action="/about/bios?edit&amp;u={person/@uid}" method="post" enctype="multipart/form-data">
			<xsl:copy-of select="$csrf_token_input"/>
			<fieldset>
				<legend>Bio</legend>

				<label>Name (First Last): <input type="text" name="name" size="25" value="{person/name}" /></label><br />
				<label>Year (e.g. 2011): <input type="text" name="year" size="5" value="{person/year}" /></label><br />
				<label>About you:<br /><textarea name="bio" cols="50" rows="10"><xsl:value-of select="person/bio" /></textarea></label><br />
				<br />
				<label>Upload new photo: <input type="file" name="picture" /></label><br />
				<span class="instructions">If you don't upload a new photo, you will keep your current one.</span><br/>
				<xsl:choose>
					<xsl:when test="person/@photo-version">
						<img src="/staff_photo/{/cr/edit_bio/@edition}/{person/@uid}/{person/@photo-version}" alt="" /><br/>
						<label class="soft"><input type="checkbox" name="remove_picture" value="1" /> Remove current photo</label><br />
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="remove_picture" value="1" />
					</xsl:otherwise>
				</xsl:choose>
				<br />
				<label>Save your bio: <input type="submit" name="submit" value="Save" /></label>
			</fieldset>
		</form>
	</div>
</xsl:template>

</xsl:stylesheet>
