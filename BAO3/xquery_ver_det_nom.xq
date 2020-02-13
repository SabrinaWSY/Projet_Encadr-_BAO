(:Projet_Encadré Sur les fichiers étiquetés avec treetagger. Construire une 
requête pour extraire les patrons morpho-syntaxiques VERBE DET NOM:)  
  for $art in collection("sortie-3208-regexp")//article
  for $elt in $art/element
  let $nextElt := $elt/following-sibling::element[1]
  let $nextElt2 := $elt/following-sibling::element[2]
  where contains($elt/data[1],"VER") and contains($nextElt/data[1],"DET") and $nextElt2/data[1] = "NOM"
  return concat($elt/data[3]/text()," ",$nextElt/data[3]/text()," ",$nextElt2/data[3]/text())
