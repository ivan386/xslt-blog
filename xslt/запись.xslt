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
	
	<!-- на выходе у нас будет xHTML а это тот же XML -->
	<xsl:output method="xml" encoding="UTF-8"/>

	<!-- сохраняем ссылку на узел с данными  -->
	<xsl:variable name="запись" select="запись" />
	
	<!-- сразу уходим в документ 'запись.xhtml' -->
	<xsl:template match="/">
		<!-- mode не даёт нам зациклиться и напоминает какой документ обрабатывает каждый шаблон -->
		<xsl:apply-templates mode="xhtml" select="document('../xhtml/%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C.xhtml')" />
	</xsl:template>
	
	<!-- копируем всё для чего нет шаблона ниже -->
	<xsl:template mode="xhtml" match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates mode="xhtml" select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- на этом этапе мы видим только содержимое страницы 'запись.xhtml' -->
	
	<!-- переменные в match работают только в Firefox -->
	
	<!-- добавляем содержимое элемента 'срез' в элементы с классом 'срез' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'срез')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="xml" select="$запись/текст//срез/node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- добавляем в meta тег содержимое элемента 'срез' -->
	<xsl:template mode="xhtml" match="xhtml:meta[contains(@class, 'срез')]">
		<meta name="description" content="{$запись/текст//срез}" />
	</xsl:template>
	
	<!-- добавляем на страницу навигацию по записям -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'навигация')]">
		<!-- вызываем шаблон по имени из файла 'навигация.xsl' -->
		<xsl:call-template name="навигация" />
	</xsl:template>
	
	<!-- добавляем содержимое элемента 'заголовок' в элементы с классом 'заголовок' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'заголовок')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$запись/заголовок" />
		</xsl:copy>
	</xsl:template>
	
	<!-- добавляем содержимое элемента 'текст' в элементы с классом 'текст' -->
	<xsl:template mode="xhtml" match="*[contains(@class, 'текст')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="xml" select="$запись/текст/node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- 
		теперь нам нужно поправить элементы исходного xml 
	
		копируем элементы у которых задано пространство имён
		(это может быть svg изображение) и атрибуты
	 -->
	<xsl:template mode="xml" match="*[namespace-uri()]|@*">
		<xsl:copy>
			<xsl:apply-templates mode="xml" select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- зададим пространсво имеён элементам без него -->
	<xsl:template mode="xml" match="*">
		<!--
			Создаём элемент с тем же именем. У нового элемента 
			пространство имён уже заданно по умолчанию
		-->
		<xsl:element name="{name()}">
			<xsl:apply-templates mode="xml" select="node()|@*" />
		</xsl:element>
	</xsl:template>
	
	<!-- оставляем от элемента 'срез' только его содержимое -->
	<xsl:template mode="xml" match="срез">
		<xsl:apply-templates mode="xml" select="node()|@*" />
	</xsl:template>
	
	<!-- даём возможность пользователю полноценно использовать xHTML заголовки --> 
	<xsl:template mode="xml" match="h1|h2|h3|h4|h5">
		<!-- 
			h1 у нас уже используется для элемента 'заголовок' 
			поэтому увеличиваем индекс xHTML заголовков пользователя
		-->
		<xsl:element name="h{substring(name(), 2, 1) + 1}">
			<!-- раз уж мы полезли в заголовки то добавим им id для навигации по записи -->
			<xsl:attribute name="id">
				<xsl:value-of select="." />
			</xsl:attribute>
			<xsl:apply-templates mode="xml" select="node()|@*" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>