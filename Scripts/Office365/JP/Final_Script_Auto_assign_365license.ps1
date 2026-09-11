# このスクリプトは Active Directory グループに基づき 3 種類のライセンスを割り当てます。
# このスクリプトをスケジュール済みタスクに配置し、毎時 24 時間 365 日実行します
# このスクリプトは MSOnline と Active Directory モジュールを使用します

# 匿名 SMTP 用のメール設定
$smtp_server = "smtp.videotron.ca"
$from = "license_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

# Office 365 MSOnline サービスへの接続 / Office 365 資格情報
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# Office365 ドメイン名 + @
$domain = "@octavie.onmicrosoft.com"

# set-location 用の国設定 (US,CA,FR...)
$country = "CA"

# 3 つのライセンス設定。独自の AD グループと 365 ライセンス名を入力してください。
$AD_GR_License_1 = "Grocery_Staff"
$License_1 = "octavie:DEVELOPERPACK"

$AD_GR_License_2 = "Director_Staff"
$License_2 = "octavie:Director"

$AD_GR_License_3 = "Manager_Staff"
$License_3 = "octavie:Manager"

# Office 365 ユーザー一覧
$user_tolicense = Get-MsolUser -all

# ライセンス 1 の設定
$License_1 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty accountskuid
$License_1_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty ConsumedUnits

# ライセンス 2 の設定
$License_2 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty accountskuid
$License_2_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty ConsumedUnits

# ライセンス 3 の設定
$License_3 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty accountskuid
$licence_3_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty ConsumedUnits

# ライセンス 1 の Active Directory グループメンバーシップ
$AD_GR_License_1  = Get-ADGroup -Identity $AD_GR_License_1 | Get-ADGroupMember

# ライセンス 2 の Active Directory グループメンバーシップ
$AD_GR_License_2 = Get-ADGroup -Identity $AD_GR_License_2 | Get-ADGroupMember

# ライセンス 3 の Active Directory グループメンバーシップ
$AD_GR_License_3 = Get-ADGroup -Identity $AD_GR_License_3 | Get-ADGroupMember

# ライセンスの割り当て
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # ユーザーの場所を設定
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          # グループメンバーシップでライセンスを割り当て
                          $AD_GR_License_1 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $AD_GR_License_2 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $AD_GR_License_3 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# ライセンス数のメールアラート
# ライセンス残数が 3 未満のときにメールを送信
if($license_1_count -lt "3"){$body = "The number of licence $License_1 is under 3";$subject = "Licence $License_1";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_2_count -lt "3"){$body = "The number of licence $License_2 is under 3";$subject = "Licence $License_2";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_3_count -lt "3"){$body = "The number of licence $License_3 is under 3";$subject = "Licence $License_3";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
