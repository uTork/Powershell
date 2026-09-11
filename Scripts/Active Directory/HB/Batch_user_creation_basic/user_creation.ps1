# מודול: Active Directory
# כותרת:  יצירת משתמשים באצווה מקובץ CSV
# תיאור: סקריפט פשוט שיוצר משתמשים ומציב אותם ביחידה הארגונית USERS #


#קובץ CSV בכונן הקשיח שלך
$fichier_csv = "C:\power\ad\user_list.txt"

#ייבוא הרשימה לזיכרון במשתנה $list_usagers ואימות אם הקובץ קיים או לא
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#סיסמה זמנית של המשתמש Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#תאריך השבתת חשבונות המשתמש במקרה זה "שנה אחת"
$date_disable_user = (get-date).AddYears(1)

#לולאה שיוצרת משתמשים שורה אחר שורה מקובץ ה-CSV
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
    $display_name =  $givenname + " " + $name             #שרשור שם פרטי ושם משפחה ל-display name ב-AD
    $sam_account =   ($givenname + "." + $name).ToLower() # שרשור שם פרטי ושם משפחה באותיות קטנות לשם משתמש AD
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # מפעיל את המשתמש ב-AD ניתן להגדיר ל-$false
    $passw_change =  $false                               # מונע שינוי סיסמה בכניסה הראשונה


    # יצירת המשתמש עם הפקודה new-aduser עם אימות שגיאות באמצעות TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
