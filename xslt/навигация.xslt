<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
	<!-- сюда мы приходим из шаблона 'запись.xsl' -->
	<xsl:template name="навигация">
		<ul>
			<!-- копируем атрибуты -->
			<xsl:copy-of select="@*" />
			
			<!-- сразу выбираем из документа 'журнал.xml' нужные узлы -->
			<xsl:apply-templates mode="навигация" select="document('../%D0%B6%D1%83%D1%80%D0%BD%D0%B0%D0%BB.xml')/журнал/запись" />
		</ul>
	</xsl:template>
	
	<!-- делаем список ссылок на другие записи -->
	<xsl:template mode="навигация" match="запись">
		<li>
			<a href="{text()}.xml">
				<xsl:value-of select="text()" />
			</a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>