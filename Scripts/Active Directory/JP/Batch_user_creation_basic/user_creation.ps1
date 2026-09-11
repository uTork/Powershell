# モジュール: Active Directory
# タイトル:  CSV ファイルからのユーザー一括作成
# 説明: ユーザーを作成し、USERS 組織単位に配置するシンプルなスクリプト #


#ハードディスク上の CSV ファイル
$fichier_csv = "C:\power\ad\user_list.txt"

#リストを変数 $list_usagers にメモリへインポートし、ファイルの有無を検証
$list_usagers = try{import-csv -path $fichier_csv -Encoding UTF8 -ErrorAction Stop}catch{$value = "Le fichier $fichier_csv n'est pas acessible";clear;write-output $value;break}

#一時ユーザーパスワード Welcome1
$mot_de_passe = ConvertTo-SecureString -String "Welcome1" -AsPlainText -Force

#アカウント無効化日（この場合「1年」）
$date_disable_user = (get-date).AddYears(1)

#CSV ファイルから行ごとにユーザーを作成するループ
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
    $display_name =  $givenname + " " + $name             #AD の display name 用に・姓を連結
    $sam_account =   ($givenname + "." + $name).ToLower() # AD ユーザー名用に・姓を小文字で連結
    $homepage =      "http://www.google.ca"
    $user_enabled =  $true                                # AD でユーザーを有効化、$false にも設定可
    $passw_change =  $false                               # 初回ログオン時のパスワード変更を防止


    # TRY/CATCH でエラー検証しながら new-aduser コマンドでユーザーを作成
    Try{New-ADUser -Name $display_name -AccountExpirationDate $date_disable_user -AccountPassword $mot_de_passe -GivenName $givenname -ChangePasswordAtLogon $passw_change -City $city -Company $compagny -DisplayName $display_name -EmailAddress $courriel -Enabled $user_enabled -HomePage $homepage -MobilePhone $phone -SamAccountName $sam_account -ErrorAction Stop;$value = "L'usager $display_name est créé.";write-output $value}catch{$value = "erreur impossible de créé l'usager $display_name. Le script s'arrête...";clear;write-output $value}
    

}
