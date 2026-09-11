# Ce script assigne 3 types de licences différents selon le groupe Active Directory.
# Placez ce script dans une tâche planifiée et exécutez-le chaque heure, 24/7
# Ce script utilise les modules MSOnline et Active Directory

# Configuration du courriel pour SMTP anonyme
$smtp_server = "smtp.videotron.ca"
$from = "license_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

# Connexion au service MSOnline Office 365 / identifiants Office 365
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# Nom de domaine Office365 + @
$domain = "@octavie.onmicrosoft.com"

# Configuration du pays pour set-location (US,CA,FR...)
$country = "CA"

# Configuration des 3 licences. Entrez votre groupe AD et le nom de licence 365.
$AD_GR_License_1 = "Grocery_Staff"
$License_1 = "octavie:DEVELOPERPACK"

$AD_GR_License_2 = "Director_Staff"
$License_2 = "octavie:Director"

$AD_GR_License_3 = "Manager_Staff"
$License_3 = "octavie:Manager"

# Liste des utilisateurs Office 365
$user_tolicense = Get-MsolUser -all

# Configuration licence 1
$License_1 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty accountskuid
$License_1_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty ConsumedUnits

# Configuration licence 2
$License_2 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty accountskuid
$License_2_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty ConsumedUnits

# Configuration licence 3
$License_3 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty accountskuid
$licence_3_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty ConsumedUnits

# Appartenance au groupe Active Directory licence 1
$AD_GR_License_1  = Get-ADGroup -Identity $AD_GR_License_1 | Get-ADGroupMember

# Appartenance au groupe Active Directory licence 2
$AD_GR_License_2 = Get-ADGroup -Identity $AD_GR_License_2 | Get-ADGroupMember

# Appartenance au groupe Active Directory licence 3
$AD_GR_License_3 = Get-ADGroup -Identity $AD_GR_License_3 | Get-ADGroupMember

# Assigner la licence
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # Définir l'emplacement de l'utilisateur
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          # Assigner la licence selon l'appartenance au groupe
                          $AD_GR_License_1 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $AD_GR_License_2 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $AD_GR_License_3 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# Alerte courriel sur le nombre de licences
# Envoyer un courriel lorsque le volume de licences est inférieur à 3
if($license_1_count -lt "3"){$body = "The number of licence $License_1 is under 3";$subject = "Licence $License_1";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_2_count -lt "3"){$body = "The number of licence $License_2 is under 3";$subject = "Licence $License_2";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_3_count -lt "3"){$body = "The number of licence $License_3 is under 3";$subject = "Licence $License_3";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
