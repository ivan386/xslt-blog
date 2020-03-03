<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!--
		Шаблон для навигации я вынес в отдельный файл 'навигация.xslt'
		Пути в шаблоне идут относительно файла шаблона
		Chrome не любит кириллицу в URL поэтому кодируем URL
	-->
	<xsl:include href="%D0%BD%D0%B0%D0%B2%D0%B8%D0%B3%D0%B0%D1%86%D0%B8%D1%8F.xslt" />
	
	<!-- текст.xslt -->
	<xsl:include href="%D1%82%D0%B5%D0%BA%D1%81%D1%82.xslt" />
	
	
	<!-- на выходе у нас будет xHTML а это тот же XML -->
	<xsl:output method="xml" encoding="UTF-8"/>

	<!-- сохраняем ссылку на узел с данными  -->
	<xsl:variable name="запись" select="запись" />
	<xsl:variable name="xhtml"  select="document('../xhtml/%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C.xhtml')" />
	
	<!-- сразу уходим в документ 'запись.xhtml' -->
	<xsl:template match="/">
		<!-- mode не даёт нам зациклиться и напоминает какой документ обрабатывает каждый шаблон -->
		<xsl:apply-templates mode="xhtml"  select="$xhtml"/>
	</xsl:template>
	
	<!-- копируем всё для чего нет шаблона ниже -->
	<xsl:template mode="xhtml" match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates mode="xhtml" select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- на этом этапе мы видим только содержимое страницы 'запись.xhtml' -->
	
	<!-- переменные в match работают только в Firefox -->
	
	<!-- добавляем содержимое элемента 'срез' если оно есть в элементы с классом 'срез' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'срез')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="текст" select="$запись/текст//срез/node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- добавляем в meta тег содержимое элемента 'срез' если оно есть -->
	<xsl:template mode="xhtml" match="xhtml:meta[contains(@class, 'срез')]">
		<meta name="description" content="{$запись/текст//срез}" />
	</xsl:template>
	
	<!-- добавляем на страницу навигацию по записям -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'навигация')]">
		<!-- вызываем шаблон по имени из файла 'навигация.xsl' -->
		<xsl:call-template name="навигация" />
	</xsl:template>
	
	<!-- добавляем содержимое элемента 'заголовок' если оно есть в элементы с классом 'заголовок' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'заголовок')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="normalize-space($запись/заголовок)">
				<xsl:value-of select="$запись/заголовок" />
			</xsl:if>
			<xsl:if test="not(normalize-space($запись/заголовок))">
				<xsl:copy-of select="node()" />
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<!-- добавляем содержимое элемента 'текст' если оно есть в элементы с классом 'текст' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'текст')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="normalize-space($запись/текст)">
				<xsl:apply-templates mode="текст" select="$запись/текст/node()" />
			</xsl:if>
			<xsl:if test="not(normalize-space($запись/текст))">
				<xsl:apply-templates mode="xhtml" select="node()" />
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template mode="xhtml" match="*[contains(@class, 'текст')]//xhtml:script/@src[starts-with(., '../')]">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="substring(., 4)" />
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>