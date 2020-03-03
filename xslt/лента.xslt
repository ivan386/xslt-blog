<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
	<!--               текст.xslt                          -->
	<xsl:include href="%D1%82%D0%B5%D0%BA%D1%81%D1%82.xslt" />
  
	<xsl:variable name="журнал" select="журнал" />
	
	<!--                                                  лента.xhtml                            -->
	<xsl:variable name="xhtml" select="document('../xhtml/%D0%BB%D0%B5%D0%BD%D1%82%D0%B0.xhtml')" />
  
	<xsl:template match="/">
		<xsl:apply-templates mode="xhtml" select="$xhtml"/>
	</xsl:template>
	
	<xsl:template mode="xhtml" match="*">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates mode="xhtml" select="node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template mode="xhtml" match="*[contains(@class, 'навигация')]">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates mode="навигация" select="$журнал/запись" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template mode="навигация" match="запись">
		<xsl:variable name="запись" select="." />
		<xsl:for-each select="$xhtml//*[contains(@class, 'ссылка')]">
			<xsl:copy>
				[<a href="#{$запись}">#</a>]
				<a href="{$запись}.xml">
					<xsl:copy-of select="$запись" />
				</a>
			</xsl:copy>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template mode="xhtml" match="*[contains(@class, 'записи')]">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates mode="записи" select="$журнал/запись" />
		</xsl:copy>
	</xsl:template>

	<xsl:template mode="записи" match="запись">
		<xsl:variable name="id" select="." />
		<xsl:variable name="запись" select="document(concat('../', ., '.xml'))/запись" />
		<xsl:for-each select="$xhtml//*[contains(@class, 'заголовок')][normalize-space($запись/заголовок)]">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<xsl:attribute name="id">
					<xsl:value-of select="$id" />
				</xsl:attribute>
				<a href="{$id}.xml">
					<xsl:copy-of select="$запись/заголовок/node()" />
				</a>
			</xsl:copy>
		</xsl:for-each>
		<xsl:for-each select="$xhtml//*[contains(@class, 'текст')][normalize-space($запись/текст)]">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<xsl:apply-templates mode="текст" select="$запись/текст/node()" />
			</xsl:copy>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>