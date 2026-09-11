# סקריפט זה מקצה 3 סוגי רישיונות שונים לפי קבוצת Active Directory.
# יש להוסיף סקריפט זה למשימה מתוזמנת ולהריץ בכל שעה, 24/7
# סקריפט זה משתמש במודולי MSOnline ו-Active Directory

# הגדרת דוא"ל עבור SMTP אנונימי
$smtp_server = "smtp.videotron.ca"
$from = "license_365@ispowershell.net"
$to = "sebastien_maltais@hotmail.com"

# חיבור לשירות MSOnline של Office 365 / אישורי Office 365
$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "Tondeus2011!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)
Connect-MsolService -Credential $cred

# שם דומיין Office365 + @
$domain = "@octavie.onmicrosoft.com"

# הגדרת מדינה עבור set-location (US,CA,FR...)
$country = "CA"

# הגדרת 3 רישיונות. הזינו את קבוצת ה-AD ושם רישיון 365.
$AD_GR_License_1 = "Grocery_Staff"
$License_1 = "octavie:DEVELOPERPACK"

$AD_GR_License_2 = "Director_Staff"
$License_2 = "octavie:Director"

$AD_GR_License_3 = "Manager_Staff"
$License_3 = "octavie:Manager"

# רשימת משתמשי Office 365
$user_tolicense = Get-MsolUser -all

# הגדרת רישיון 1
$License_1 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty accountskuid
$License_1_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_1} | Select-Object -ExpandProperty ConsumedUnits

# הגדרת רישיון 2
$License_2 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty accountskuid
$License_2_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_2} | Select-Object -ExpandProperty ConsumedUnits

# הגדרת רישיון 3
$License_3 = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty accountskuid
$licence_3_count = Get-MsolAccountSku | Where-object {$_.accountskuid -eq $License_3} | Select-Object -ExpandProperty ConsumedUnits

# חברות בקבוצת Active Directory לרישיון 1
$AD_GR_License_1  = Get-ADGroup -Identity $AD_GR_License_1 | Get-ADGroupMember

# חברות בקבוצת Active Directory לרישיון 2
$AD_GR_License_2 = Get-ADGroup -Identity $AD_GR_License_2 | Get-ADGroupMember

# חברות בקבוצת Active Directory לרישיון 3
$AD_GR_License_3 = Get-ADGroup -Identity $AD_GR_License_3 | Get-ADGroupMember

# הקצאת רישיון
$user_tolicense | foreach{
                          $islicensed = $_.isLicensed
                          $UPN = $_.UserPrincipalName
                          $usagelocation = $_.UsageLocation
                          $office365_samaccount = $UPN -replace "$domain",""
                          
                          # הגדרת מיקום המשתמש
                          if($usagelocation -ne $country){Set-MsolUser -UserPrincipalName $UPN -UsageLocation $country}

                          # הקצאת רישיון לפי חברות בקבוצה
                          $AD_GR_License_1 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Grocery_license}}
                          $AD_GR_License_2 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Director_license}}
                          $AD_GR_License_3 | foreach{if($_.samaccountname -eq "$office365_samaccount" -and $islicensed -eq $false){Set-MsolUserLicense -UserPrincipalName $UPN -AddLicenses $Manager_license}}
                          }

# התראת דוא"ל על מספר הרישיונות
# שליחת דוא"ל כאשר מספר הרישיונות נמוך מ-3
if($license_1_count -lt "3"){$body = "The number of licence $License_1 is under 3";$subject = "Licence $License_1";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_2_count -lt "3"){$body = "The number of licence $License_2 is under 3";$subject = "Licence $License_2";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
if($license_3_count -lt "3"){$body = "The number of licence $License_3 is under 3";$subject = "Licence $License_3";Send-MailMessage -Body $body -Subject $subject -To $to -From $from -SmtpServer $smtp_server}
