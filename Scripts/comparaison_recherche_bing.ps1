# Planified Task who compare the result based on 2 dates
$number_of_result = 100000 #number to change to get more or less result

$keyword = "torrent"

$excel_report = "C:\Users\test\OneDrive\Script\GITHUB\Powershell\Scripts_Exemples\rapport.xlsx" #Excel File to keep the first run
$excel_comparaison = "C:\Users\test\OneDrive\Script\GITHUB\Powershell\Scripts_Exemples\comparaison.xlsx" #Excel File to keep the first run

$old_result = try{Import-Excel -Path $excel_report -WorksheetName "data" -ErrorAction Stop}catch{$wri = "Le fichier excel n'existe pas";write-output $wri}

$query_h2 = @("Description,Lien")

$p = 0

while($p -lt $number_of_result){

$www = "https://www.bing.com/search?q=$keyword&qs=n&sp=-1&pq=$keyword&sc=8-5&sk=&cvid=E0A3EC737EEA49248FA4EB56B2E093D0&first=$p&FORM=PERE"

$select = Invoke-WebRequest -Uri $www

[regex]$reg = "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"

$p = $p + 10 #add the next 10 result to the variable

$query_h2 += @(
                $select.ParsedHtml.body.getElementsByTagName("H2") | foreach{
                                                                            $texte = $_.innertext -replace ",",""
                                                                            $lien = $_.innerhtml | Select-string -Pattern $reg -AllMatches | % { $_.Matches }
                                                                            $CSV = $texte + "," + $lien
                                                                            
                                                                            if($csv.length -gt 45){$csv}
                                                                             }
             )

}

$table = $query_h2 | convertfrom-csv


$table | Export-Excel -Path $excel_report -WorksheetName "data" 



[array]$list = Compare-Object -ReferenceObject $old_result -DifferenceObject $table | where-object {$_.sideindicator -eq "=>"} | Select-Object -ExpandProperty inputobject
#$list = $list | convertfrom-csv

$list | export-excel -Path $excel_comparaison -WorksheetName "torrent"

$body  = "Liste excel"

$sujet = "Liste des nouveaulien torrent dans les $number_of_result dernier resultat"
$server = "smtp.videotron.ca"
$destinataire = "sebastien_maltais@hotmail.com"
$expediteur = "rapport@sebastienmaltais.com"
$port = 25

Send-MailMessage -SmtpServer $server -Port $port -Subject $sujet -From $expediteur -to $destinataire -Body $body -Attachments $excel_comparaison -BodyAsHtml

