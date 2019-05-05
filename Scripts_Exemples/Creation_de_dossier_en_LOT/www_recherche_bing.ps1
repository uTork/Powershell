# Script qui recherche des mot dans l'outil de recherche microsoft BIng
# Le script retorune la description et e lien cible

$keyword = "orignal"

$query_h2 = @("Description,Lien")

$page = @("10","20","30","40","50","60","70","80","90","100","110","120","130","140","150")

foreach($p in $page){

$www = "https://www.bing.com/search?q=$keyword&qs=n&sp=-1&pq=$keyword&sc=8-5&sk=&cvid=E0A3EC737EEA49248FA4EB56B2E093D0&first=$p&FORM=PERE"

$select = Invoke-WebRequest -Uri $www

[regex]$reg = "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"



$query_h2 += @(
                $select.ParsedHtml.body.getElementsByTagName("H2") | foreach{
                                                                            $texte = $_.innertext -replace ",",""
                                                                            $lien = $_.innerhtml | Select-string -Pattern $reg -AllMatches | % { $_.Matches }
                                                                            $CSV = $texte + "," + $lien
                                                                            
                                                                            if($csv.length -gt 45){$csv}
                                                                             }
             )

}

$query_h2 | convertfrom-csv
