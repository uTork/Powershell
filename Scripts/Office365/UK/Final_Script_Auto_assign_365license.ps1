# Цей скрипт призначає 3 різні типи ліцензій за групою Active Directory.
# Розмістіть цей скрипт у запланованому завданні та запускайте щогодини, 24/7
# Цей скрипт використовує модулі MSOnline та Active Directory

# Налаштування пошти для анонімного SMTP
$smtp_server = "smtp.videotron.ca"
$from = "license_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

# Підключення до служби MSOnline Office 365 / облікові дані Office 365
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# Ім’я домену Office365 + @
$domain = "@octavie.onmicrosoft.com"

# Налаштування країни для set-location (US,CA,FR...)
$country = "CA"

# Налаштування 3 ліцензій. Введіть свою групу AD і назву ліцензії 365.
$AD_GR_License_1 = "Grocery_Staff"
$License_1 = "octavie:DEVELOPERPACK"

$AD_GR_License_2 = "Director_Staff"
$License_2 = "octavie:Director"

$AD_GR_License_3 = "Manager_Staff"
$License_3 = "octavie:Manager"

# Список користувачів Office 365
$user_tolicense = Get-MsolUser -all

# Налаштування ліцензії 1
$License_1 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty accountskuid
$License_1_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty ConsumedUnits

# Налаштування ліцензії 2
$License_2 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty accountskuid
$License_2_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty ConsumedUnits

# Налаштування ліцензії 3
$License_3 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty accountskuid
$licence_3_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty ConsumedUnits

# Членство в групі Active Directory для ліцензії 1
$AD_GR_License_1  = Get-ADGroup -Identity $AD_GR_License_1 | Get-ADGroupMember

# Членство в групі Active Directory для ліцензії 2
$AD_GR_License_2 = Get-ADGroup -Identity $AD_GR_License_2 | Get-ADGroupMember

# Членство в групі Active Directory для ліцензії 3
$AD_GR_License_3 = Get-ADGroup -Identity $AD_GR_License_3 | Get-ADGroupMember

# Призначити ліцензію
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # Встановити розташування користувача
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          # Призначити ліцензію за членством у групі
                          $AD_GR_License_1 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $AD_GR_License_2 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $AD_GR_License_3 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# Поштове сповіщення про кількість ліцензій
# Надіслати лист, коли кількість ліцензій менша за 3
if($license_1_count -lt "3"){$body = "The number of licence $License_1 is under 3";$subject = "Licence $License_1";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_2_count -lt "3"){$body = "The number of licence $License_2 is under 3";$subject = "Licence $License_2";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_3_count -lt "3"){$body = "The number of licence $License_3 is under 3";$subject = "Licence $License_3";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
