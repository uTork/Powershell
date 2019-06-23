# This script is created ti assign 3 different type of license and assign them by Ad group.
# You place this script in planified task and run the task at each hour 7/7 24/24
# This script use module MSOnline and Active Directory

# Mail Setup
$smtp_server = "smtp.videotron.ca"
$from = "licence_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

$domain = "@octavie.onmicrosoft.com"
$country = "CA"

# Connection to Office 365 MsOnline Service
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# Office 365 user list
$user_tolicense = Get-MsolUser -all

# Grocery Staff license
$Grocery_license_name = "octavie:DEVELOPERPACK"
$Grocery_license = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Grocery_license_name} | Select-Object -ExpandProperty accountskuid
$Grocery_license_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Grocery_license_name} | Select-Object -ExpandProperty ConsumedUnits

# Director Staff license
$Director_license_name = "octavie:Director"
$Director_license = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Director_license_name} | Select-Object -ExpandProperty accountskuid
$Director_license_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Director_license_name} | Select-Object -ExpandProperty ConsumedUnits

# Manager Staff license
$Manager_license_name = "octavie:Manager"
$Manager_license = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Manager_license_name} | Select-Object -ExpandProperty accountskuid
$Manager_license_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $Manager_license_name} | Select-Object -ExpandProperty ConsumedUnits

# Grocery Staff membership
$groupmember_Grocery = Get-ADGroup -Identity "Grocery_Staff" | Get-ADGroupMember

# Director staff group membership
$groupmember_Director = Get-ADGroup -Identity "Director_Staff" | Get-ADGroupMember


# Director staff group membership
$groupmember_Manager = Get-ADGroup -Identity "Manager_Staff" | Get-ADGroupMember

# assign license
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # set user location
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          #Assign license by group membership
                          $groupmember_Grocery | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $groupmember_Director | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $groupmember_Manager | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# licence number mail alert
# send email when license volume is under 3 license
if($Grocery_license_count -lt "3"){$body = "The number of licence $Grocery_license_name is under 3";$subject = "Licence $Grocery_license_name";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($Director_license_count -lt "3"){$body = "The number of licence $Director_license_name is under 3";$subject = "Licence $Director_license_name";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($Manager_license_count -lt "3"){$body = "The number of licence $Manager_license_name is under 3";$subject = "Licence $Manager_license_name";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
