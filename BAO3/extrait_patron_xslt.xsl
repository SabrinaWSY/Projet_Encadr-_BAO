<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="utf-8"/>
    
    <xsl:template match="/">
        <xsl:text>Voici les contenus étiquetés avec TreeTagger de la rubrique «France»: </xsl:text><xsl:text>
	Affichage en texte simple</xsl:text><xsl:text>
	        </xsl:text>
        <xsl:apply-templates select="//item"/>
    </xsl:template>
    
    <xsl:template match="item">
        <xsl:for-each select="./titre/document/article/element">
            
            <xsl:if test="./data[contains(@type,'type')]='NOM' and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'ADJ')]">
                <xsl:text>NOM-ADJ : </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text>		
		</xsl:text>		
                
            </xsl:if>
            <xsl:if test="./data[contains(@type,'type')]='ADJ' and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')]">
                <xsl:text>ADJ-NOM : </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text>		
		</xsl:text>		
                
            </xsl:if>
            <xsl:if test="./data[contains(@type,'type')][contains(text(),'DET')] and preceding-sibling::element[1]/data[contains(@type,'type')][contains(text(),'VER')] and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')]">
                <xsl:text>VER-DET-NOM : </xsl:text>
                <xsl:value-of select="preceding-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> 
		</xsl:text>		
            </xsl:if>
            
            <xsl:if test="./data[contains(@type,'type')][contains(text(),'PRP')] and preceding-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')] and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')] and following-sibling::element[2]/data[contains(@type,'type')][contains(text(),'PRP')]">
                <xsl:text>NOM-PRP-NOM-PRP : </xsl:text>
                <xsl:value-of select="preceding-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[2]/data[contains(@type,'string')]"/><xsl:text> 
		</xsl:text>		
            </xsl:if>
            
        </xsl:for-each>
        <xsl:for-each select="./description/document/article/element">
            <xsl:if test="./data[contains(@type,'type')]='NOM' and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'ADJ')]">
                <xsl:text>NOM-ADJ : </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text>		
		</xsl:text>		
            </xsl:if>
            
            <xsl:if test="./data[contains(@type,'type')]='ADJ' and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')]">
                <xsl:text>ADJ-NOM : </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text>		
		</xsl:text>		
            </xsl:if>
            
            <xsl:if test="./data[contains(@type,'type')][contains(text(),'DET')] and preceding-sibling::element[1]/data[contains(@type,'type')][contains(text(),'VER')] and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')]">
                <xsl:text>VER-DET-NOM : </xsl:text>
                <xsl:value-of select="preceding-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> 
		</xsl:text>		
            </xsl:if>
            
            <xsl:if test="./data[contains(@type,'type')][contains(text(),'PRP')] and preceding-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')] and following-sibling::element[1]/data[contains(@type,'type')][contains(text(),'NOM')] and following-sibling::element[2]/data[contains(@type,'type')][contains(text(),'PRP')]">
                <xsl:text>NOM-PRP-NOM-PRP : </xsl:text>
                <xsl:value-of select="preceding-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="./data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[1]/data[contains(@type,'string')]"/><xsl:text> </xsl:text>
                <xsl:value-of select="following-sibling::element[2]/data[contains(@type,'string')]"/><xsl:text> 
		</xsl:text>		
            </xsl:if>
            
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>