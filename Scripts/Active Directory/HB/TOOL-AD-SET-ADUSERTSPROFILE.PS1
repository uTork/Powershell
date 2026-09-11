function Set-ADuserTsprofile {
<#
.SYNOPSIS

פונקציה זו מאפשרת לשנות את נתיב פרופיל שרת המסוף עבור משתמשים החברים בקבוצת Active Directory.
הפונקציה תשמש במשימה מתוזמנת שרצה כל 15 דקות.

.DESCRIPTION
הגדרת נתיב פרופיל שרת המסוף של משתמש AD
.PARAMETER ADGroup
קבוצת מקור Active Directory המכילה את החברים להגדרה
.PARAMETER TSProfilePath
נתיב UNC של פרופיל TS. לדוגמה: "\\server\share$\%username%"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$ADGroup,
      [string]$TSProfilePath
      )

# אימות התקנת מודול ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #סוף אם המודול זמין אז ייבא
else { $false } #מודול לא זמין
} # סוף אם אין מודול
else { $true } #מודול כבר טעון
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# חילוץ חברי קבוצת Active Directory
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# הגדרת פרופיל משתמש AD
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
