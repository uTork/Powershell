# הגדרת תיאור אובייקט המחשב ב-Active Directory מגיליון Excel

$serveur_list = Import-Excel -path "C:\excel\serveur.xlsx" | Select-Object "Nom du serveur","Description"

foreach($serveur in $serveur_list){

$description = $serveur.Description
$server_name = $serveur."Code du serveur"

$description
$server_name

Set-ADComputer -Identity $server_name -Add @{"description"=$description}


}

