(:Projet_Encadré Sur les fichiers étiquetés avec treetagger. Construire une 
requête pour extraire les patrons morpho-syntaxiques NOM PREP NOM PREP:)  
  for $art in collection("sortie-3208-regexp")//article
  for $elt in $art/element
  let $nextElt := $elt/following-sibling::element[1]
  let $nextElt2 := $elt/following-sibling::element[2]
  let $nextElt3 := $elt/following-sibling::element[3]
  where contains($elt/data[1],"NOM") and contains($nextElt/data[1],"PRP") and $nextElt2/data[1] = "NOM" and $nextElt3/data[1] = "PRP"
  return concat($elt/data[3]/text()," ",$nextElt/data[3]/text()," ",$nextElt2/data[3]/text()," ", $nextElt3/data[3]/text())
