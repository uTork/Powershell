# Module: Active Directory
# Title:  Batch user creation from a CSV file
# Description: A simple script that creates users and places them in the USERS organizational unit #


#CSV file on your hard drive
$fichier_csv = "C:\power\ad\user_list.txt"

#Import the list into memory in the variable $list_usagers and validate if the file exists or not
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#Temporary user password Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#Account disable date in this case "1 year"
$date_disable_user = (get-date).AddYears(1)

#Loop that creates users line by line from the CSV file
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
    $display_name =  $givenname + " " + $name             #Concatenate first name and last name for the display name in AD
    $sam_account =   ($givenname + "." + $name).ToLower() # Concatenate first name and last name in lowercase for the AD username
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # Enable the user in AD can be set to $false
    $passw_change =  $false                               # Prevent password change at first logon


    # User creation with the new-aduser command with error validation using TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
