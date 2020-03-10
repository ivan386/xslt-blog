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
		<xsl:variable name="контейнер-заголовка" select="*[contains(@class, 'заголовок')]" />
		<xsl:variable name="контейнер-текста" select="*[contains(@class, 'текст')]" />
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:for-each select="$журнал/запись">
				<xsl:variable name="id" select="normalize-space(.)" />
				<xsl:variable name="xml">
					<xsl:if test="@xml">
						<xsl:value-of select="@xml"/>
					</xsl:if>
					<xsl:if test="not(@xml)">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="запись" select="document(concat('../', $xml, '.xml'))/запись" />
				<xsl:if test="normalize-space($запись)">
					<xsl:for-each select="$контейнер-заголовка">
						<xsl:call-template name="заголовок">
							<xsl:with-param name="id" select="$id" />
							<xsl:with-param name="запись" select="$запись" />
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each select="$контейнер-текста">
						<xsl:call-template name="текст">
							<xsl:with-param name="запись" select="$запись" />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>