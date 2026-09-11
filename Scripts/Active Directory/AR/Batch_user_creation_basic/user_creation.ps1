# الوحدة: Active Directory
# العنوان:  إنشاء مستخدمين دفعة واحدة من ملف CSV
# الوصف: برنامج نصي بسيط ينشئ المستخدمين ويضعهم في الوحدة التنظيمية USERS #


#ملف CSV على القرص الصلب
$fichier_csv = "C:\power\ad\user_list.txt"

#استيراد القائمة إلى الذاكرة في المتغير $list_usagers والتحقق مما إذا كان الملف موجودًا أم لا
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#كلمة مرور المستخدم المؤقتة Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#تاريخ تعطيل حسابات المستخدمين في هذه الحالة "سنة واحدة"
$date_disable_user = (get-date).AddYears(1)

#حلقة تنشئ المستخدمين سطرًا بسطر من ملف CSV
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
    $display_name =  $givenname + " " + $name             #دمج الاسم الأول واسم العائلة لـ display name في AD
    $sam_account =   ($givenname + "." + $name).ToLower() # دمج الاسم الأول واسم العائلة بأحرف صغيرة لاسم مستخدم AD
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # تفعيل المستخدم في AD يمكن تعيينه إلى $false
    $passw_change =  $false                               # منع تغيير كلمة المرور عند أول تسجيل دخول


    # إنشاء المستخدم بأمر new-aduser مع التحقق من الأخطاء باستخدام TRY/CATCH
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
