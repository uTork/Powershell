# This script is created ti assign 3 different type of license and assign them by Ad group.
# You place this script in planified task and run the task at each hour 7/7 24/24
# This script use module MSOnline and Active Directory

# Mail Setup for SMTP anonymous
$smtp_server = "smtp.videotron.ca"
$from = "licence_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

# Connection to Office 365 MsOnline Service / Office 365 credential
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# Office365 domain name + @
$domain = "@octavie.onmicrosoft.com"

# Country setup for the set-location (US,CA,FR...)
$country = "CA"

# 3 license setup. You have to enter your own ad group and 365 license name.
$AD_GR_License_1 = "Grocery_Staff"
$License_1 = "octavie:DEVELOPERPACK"

$AD_GR_License_2 = "Director_Staff"
$License_2 = "octavie:Director"

$AD_GR_License_3 = "Manager_Staff"
$License_3 = "octavie:Manager"

# Office 365 user list
$user_tolicense = Get-MsolUser -all

# Licence 1 setup
$License_1 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty accountskuid
$License_1_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty ConsumedUnits

# Licence 2 setup
$License_2 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty accountskuid
$License_2_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty ConsumedUnits

# Licence 3 setup
$License_3 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty accountskuid
$licence_3_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty ConsumedUnits

# License 1 Active Directory group membership
$AD_GR_License_1  = Get-ADGroup -Identity $AD_GR_License_1 | Get-ADGroupMember

# License 2 Active Directory group membership
$AD_GR_License_2 = Get-ADGroup -Identity $AD_GR_License_2 | Get-ADGroupMember

# License 3 Active Directory group membership
$AD_GR_License_3 = Get-ADGroup -Identity $AD_GR_License_3 | Get-ADGroupMember

# assign license
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # set user location
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          #Assign license by group membership
                          $AD_GR_License_1 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $AD_GR_License_2 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $AD_GR_License_3 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# licence number mail alert
# send email when license volume is under 3 license
if($license_1_count -lt "3"){$body = "The number of licence $License_1 is under 3";$subject = "Licence $License_1";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_2_count -lt "3"){$body = "The number of licence $License_2 is under 3";$subject = "Licence $License_2";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_3_count -lt "3"){$body = "The number of licence $License_3 is under 3";$subject = "Licence $License_3";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
