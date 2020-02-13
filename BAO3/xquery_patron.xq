for $art in collection("3208-2017-v2")//article
for $elt in $art/element
let $concat2 :=
  if (($elt/data[1]/text()="NOM") and ($elt/following-sibling::element[1]/data[1]/text()="PRP") and ($elt/following-sibling::element[2]/data[1]/text()="NOM") and ($elt/following-sibling::element[3]/data[1]/text()="PRP") and ($elt/following-sibling::element[4]/data[1]/text()="NOM")) then (
    concat($elt/data[2]/text()," ",$elt/following-sibling::element[1]/data[2]/text()," ",$elt/following-sibling::element[2]/data[2]/text()," ",$elt/following-sibling::element[3]/data[2]/text()," ",$elt/following-sibling::element[4]/data[2]/text())
  )
  else if (($elt/data[1]/text()="NOM") and ($elt/following-sibling::element[1]/data[1]/text()="ADJ")) then (
       concat($elt/data[2]/text()," ",$elt/following-sibling::element[1]/data[2]/text())
  )
  else if (($elt/data[1]/text()="ADJ") and ($elt/following-sibling::element[1]/data[1]/text()="NOM")) then (
       concat($elt/data[2]/text()," ",$elt/following-sibling::element[1]/data[2]/text())
  )
  else if (contains($elt/data[1],"VER") and ($elt/following-sibling::element[1]/data[1]/text()="DET") and ($elt/following-sibling::element[2]/data[1]/text()="NOM")) then (
       concat($elt/data[2]/text()," ",$elt/following-sibling::element[1]/data[2]/text()," ",$elt/following-sibling::element[2]/data[2]/text())
  )
  else (
    "&#10;"
  )
where $concat2 != "&#10;"
return $concat2