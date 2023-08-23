# Mettre la description de l'objet ordinateur dans l'Active Directory à partir d'une feuille Excel

$serveur_list = Import-Excel -path "C:\excel\serveur.xlsx" | Select-Object "Nom du serveur","Description"

foreach($serveur in $serveur_list){

$description = $serveur.Description
$server_name = $serveur."Code du serveur"

$description
$server_name

Set-ADComputer -Identity $server_name -Add @{"description"=$description}


}

