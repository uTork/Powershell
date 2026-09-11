# Módulo: Active Directory
# Título:  Creación de usuarios por lotes a partir de un archivo CSV
# Descripción: Un script simple que crea usuarios y los coloca en la unidad organizativa USERS #


#Archivo CSV en su disco duro
$fichier_csv = "C:\power\ad\user_list.txt"

#Importación de la lista en memoria en la variable $list_usagers y valida si el archivo existe o no
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#Contraseña temporal del usuario Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#Fecha de desactivación de las cuentas de usuario en este caso "1 año"
$date_disable_user = (get-date).AddYears(1)

#Bucle que crea los usuarios línea por línea a partir del archivo CSV
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
    $display_name =  $givenname + " " + $name             #Concatena el nombre y apellido para el display name en AD
    $sam_account =   ($givenname + "." + $name).ToLower() # Concatena el nombre y apellido en minúsculas para el nombre de usuario AD
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # Activa el usuario en AD puede establecerse en $false
    $passw_change =  $false                               # Impide el cambio de contraseña en el primer inicio de sesión


    # Creación del usuario con el comando new-aduser con validación de errores mediante TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
