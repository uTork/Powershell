# Module: Active Directory
# Titre:  Création d'usager en lot à partir d'un fichier CSV
# Description: Un script simple qui créé les usagers et les place dans l'unité d'organisation USERS #


#Fichier CSV sur votre disque dur
$fichier_csv = "C:\power\ad\user_list.txt"

#Importation de la liste en mémoire dans la variable $list_usagers et valide si le fichier existe ou non 
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#Mot de passse temporaire de l'usager Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#Date de désactivation des comptes usager dans ce cas "1an"
$date_disable_user = (get-date).AddYears(1)

#Boucle qui créé les usagers ligne par ligne à partir du fichier CSV
foreach($usager in $list_usagers){

    $name =          $usager.nom
    $address =       $usager.adresse
    $postal =        $usager.code_postal
    $compagny =      $usager.compagnie
    $courriel =      $usager.courriel
    $country =       $usager.pays
    $givenname =     $usager.prenom
    $city =          $usager.ville
    $phone =         $usager.telephone
    $display_name =  $givenname + " " + $name             #Concatène le prenom et nom pour faire le display name dans l'AD
    $sam_account =   ($givenname + "." + $name).ToLower() # Concatène le prenom et le nom en minuscule pour le nom d'usager AD
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # Active l'usager dans AD peut être setter à $false
    $passw_change =  $false                               # Empeche le changement de mot de passe à l'ouverture de la premiere session


    # Creation de l'usager avec la commande new-aduser avec validation si il ya des erreurs avec un TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}