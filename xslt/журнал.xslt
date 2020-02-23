<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" encoding="UTF-8"/>
	
	<!-- сохраняем загаловок первой записи (он же имя файла) -->
	<xsl:variable name="запись" select="журнал/запись/text()" />
	
	<xsl:template match="/">
		<!-- используем уже готовый образец страницы перенаправления -->
		<xsl:apply-templates mode="html" select="document('../index.html')" />
	</xsl:template>
	
	<!-- копируем элементы и атрибуты -->
	<xsl:template mode="html" match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates mode="html" select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- меняем необходимые элементы -->
		
	<!-- меняем адрес автоматического перенапрвления -->
	<xsl:template mode="html" match="xhtml:meta[@http-equiv='refresh']">
		<!--
			 Хак
			 1. Меняем базовый URL
				Таким образом мы избегаем необходимости кодирования URL
		-->
		<base href="{$запись}.xml" />
		
		<!-- 2. Обновляем страницу -->
		<meta http-equiv="refresh" content="0; url=#" />
	</xsl:template>
	
	<!-- меняем имя и адрес ссылки на странице перенаправления -->
	<xsl:template mode="html" match="xhtml:a[@class='перенаправление']">
		<a href="" class="{@class}">
			<xsl:value-of select="$запись" />
		</a>
	</xsl:template>
</xsl:stylesheet>