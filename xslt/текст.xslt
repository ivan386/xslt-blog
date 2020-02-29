<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- 
		теперь нам нужно поправить элементы исходного xml 
	
		копируем элементы у которых задано пространство имён
		(это может быть svg изображение) и атрибуты
	 -->
	<xsl:template mode="текст" match="*[namespace-uri()]|@*">
		<xsl:copy>
			<xsl:apply-templates mode="текст" select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- зададим пространсво имеён элементам без него -->
	<xsl:template mode="текст" match="*">
		<!--
			Создаём элемент с тем же именем. У нового элемента 
			пространство имён уже заданно по умолчанию
		-->
		<xsl:element name="{name()}">
			<xsl:apply-templates mode="текст" select="node()|@*" />
		</xsl:element>
	</xsl:template>
	
	<!-- оставляем от элемента 'срез' только его содержимое -->
	<xsl:template mode="текст" match="срез">
		<xsl:apply-templates mode="текст" select="node()|@*" />
	</xsl:template>
	
	<!-- даём возможность пользователю полноценно использовать xHTML заголовки --> 
	<xsl:template mode="текст" match="h1|h2|h3|h4|h5">
		<!-- 
			h1 у нас уже используется для элемента 'заголовок' 
			поэтому увеличиваем индекс xHTML заголовков пользователя
		-->
		<xsl:element name="h{substring(name(), 2, 1) + 1}">
			<!-- раз уж мы полезли в заголовки то добавим им id для навигации по записи -->
			<xsl:attribute name="id">
				<xsl:value-of select="." />
			</xsl:attribute>
			<xsl:apply-templates mode="текст" select="node()|@*" />
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>