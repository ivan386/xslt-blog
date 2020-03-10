<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
  	<xsl:template name="заголовок">
		<xsl:param name="запись" />
		<xsl:param name="id" />
		<xsl:choose>
		
			<!-- проверяем есть ли текст в теге заголовок -->
			<xsl:when test="$запись/заголовок[normalize-space()]">
				<!-- выводим содержимое тега 'заголовок' -->
				<xsl:call-template name="вставить">
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="узлы"
						select="$запись/заголовок/node()" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- проверяем есть ли текст после тега 'заголовок' и до тега 'текст' -->
			<xsl:when
				test="  $запись
						/заголовок
						/following-sibling::node()
						[following-sibling::текст]
						[normalize-space()]">
				
				<!-- выводим все элементы после тега 'заголовок' до тега 'текст' -->
				<xsl:call-template name="вставить">
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="узлы"
						select="$запись
								/заголовок
								/following-sibling::node()
								[following-sibling::текст]" />
					
				</xsl:call-template>
			</xsl:when>
			
			<!-- проверяем есть ли текст до тега 'текст' -->
			<xsl:when
				test="  $запись
						/текст
						/preceding-sibling::node()
						[normalize-space()]">
				<xsl:call-template name="вставить">
					<xsl:with-param name="id" select="$id" />
					<xsl:with-param name="узлы"
						select="$запись
								/текст
								/preceding-sibling::node()" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- копируем исходное содержимое тега -->
			<xsl:otherwise>
				<xsl:copy-of select="." />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="вставить">
		<xsl:param name="узлы" />
		<xsl:param name="id" />
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:choose>
				
				<!-- в теге 'title' нужен только текст без тегов -->
				<xsl:when test="self::xhtml:title">
					<xsl:apply-templates mode="текст" select="$узлы/descendant-or-self::text()" />
				</xsl:when>
				
				<!-- если задан $id то добавляем атрибут и ссылку -->
				<xsl:when test="$id">
					<xsl:attribute name="id">
							<xsl:value-of select="$id" />
					</xsl:attribute>
					<a href="{$id}.xml">
						<xsl:apply-templates mode="текст" select="$узлы" />
					</a>
				</xsl:when>
				
				<!-- просто выводим -->
				<xsl:otherwise>
					<xsl:apply-templates mode="текст" select="$узлы" />
				</xsl:otherwise>
				
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="текст">
		<xsl:param name="запись" />
		
		<xsl:choose>
			<!-- проверяем есть ли текст в теге текст -->
			<xsl:when test="$запись/текст[normalize-space()]">
				<!-- выводим содержимое тега текст -->
				<xsl:call-template name="срез">
					<xsl:with-param name="текст" select="$запись/текст/node()" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- проверяем есть ли текст после тега текст -->
			<xsl:when test="$запись/текст/following-sibling::node()[normalize-space()]">
				<!-- выводим содержимое после тега текст -->
				<xsl:call-template name="срез">
					<xsl:with-param name="текст" select="$запись/текст/following-sibling::node()" />
				</xsl:call-template>
			</xsl:when>
			
			<!-- копируем исходное содержимое тега -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates mode="xhtml" select="node()|@*" />
				</xsl:copy>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="срез">
		<xsl:param name="текст" />
		<xsl:choose>
			<!-- проверяем есть ли тег 'срез' и контейнер для него -->
			<xsl:when test="xhtml:details and $текст/self::срез">
				<xsl:copy>
					<xsl:copy-of select="@*" />
					<!-- выводим узлы до тега 'срез' -->
					<xsl:apply-templates mode="текст" select="$текст[following-sibling::срез]" />
					
					<!-- выводим узлы содержимое тега 'срез' -->
					<xsl:apply-templates mode="текст" select="$текст/self::срез" />
					<xsl:for-each select="xhtml:details">
						<xsl:copy>
							<xsl:copy-of select="node()|@*" />
							<!-- выводим узлы после тега 'срез' -->
							<xsl:apply-templates mode="текст" select="$текст[preceding-sibling::срез]" />
						</xsl:copy>
					</xsl:for-each>
				</xsl:copy>
			</xsl:when>
			
			<!-- просто выводим весь текст -->
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*" />
					<xsl:apply-templates mode="текст" select="$текст" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
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