(:Projet_Encadré Construire une requête pour extraire les patrons morpho-syntaxiques NOM ADJ :)
for $art in collection("sortie-3208-regexp")//article
for $elt in $art/element
let $nextElt := $elt/following-sibling::element[1]
where $elt/data[1] = "NOM" and $nextElt/data[1] = "ADJ"
return concat($elt/data[3]/text(),' ',$nextElt/data[3]/text())
