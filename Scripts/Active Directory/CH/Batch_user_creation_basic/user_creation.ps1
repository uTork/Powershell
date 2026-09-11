# 模块: Active Directory
# 标题:  从 CSV 文件批量创建用户
# 描述: 一个简单的脚本，创建用户并将其放入 USERS 组织单位 #


#硬盘上的 CSV 文件
$fichier_csv = "C:\power\ad\user_list.txt"

#将列表导入内存到变量 $list_usagers，并验证文件是否存在
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#用户临时密码 Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#用户帐户停用日期，此处为"1年"
$date_disable_user = (get-date).AddYears(1)

#从 CSV 文件逐行创建用户的循环
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
    $display_name =  $givenname + " " + $name             #连接名和姓以生成 AD 中的 display name
    $sam_account =   ($givenname + "." + $name).ToLower() # 以小写连接名和姓作为 AD 用户名
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # 在 AD 中启用用户，可设为 $false
    $passw_change =  $false                               # 阻止首次登录时更改密码


    # 使用 new-aduser 命令创建用户，并通过 TRY/CATCH 验证错误
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
