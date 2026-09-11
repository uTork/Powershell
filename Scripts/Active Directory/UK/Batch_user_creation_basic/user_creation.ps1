# Модуль: Active Directory
# Заголовок:  Пакетне створення користувачів з CSV-файлу
# Опис: Простий скрипт, який створює користувачів і розміщує їх в організаційному підрозділі USERS #


#CSV-файл на вашому жорсткому диску
$fichier_csv = "C:\power\ad\user_list.txt"

#Імпорт списку в пам'ять у змінну $list_usagers і перевірка існування файлу
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#Тимчасовий пароль користувача Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#Дата вимкнення облікових записів користувачів у цьому випадку "1 рік"
$date_disable_user = (get-date).AddYears(1)

#Цикл, що створює користувачів рядок за рядком з CSV-файлу
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
    $display_name =  $givenname + " " + $name             #Об'єднує ім'я та прізвище для display name в AD
    $sam_account =   ($givenname + "." + $name).ToLower() # Об'єднує ім'я та прізвище малими літерами для імені користувача AD
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # Активує користувача в AD може бути встановлено на $false
    $passw_change =  $false                               # Забороняє зміну пароля при першому вході


    # Створення користувача командою new-aduser з перевіркою помилок через TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
