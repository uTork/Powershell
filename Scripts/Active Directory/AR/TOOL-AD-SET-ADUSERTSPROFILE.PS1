function Set-ADuserTsprofile {
<#
.SYNOPSIS

تتيح هذه الدالة تغيير مسار ملف تعريف خادم الطرفية للمستخدمين الأعضاء في مجموعة Active Directory.
ستُستخدم هذه الدالة في مهمة مجدولة تعمل كل 15 دقيقة.

.DESCRIPTION
تكوين مسار ملف تعريف خادم الطرفية لمستخدم AD
.PARAMETER ADGroup
مجموعة مصدر Active Directory التي تحتوي على الأعضاء المراد تكوينهم
.PARAMETER TSProfilePath
مسار UNC لملف تعريف TS. مثال: "\\server\share$\%username%"
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

# التحقق من تثبيت وحدة ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #نهاية إذا كانت الوحدة متاحة ثم الاستيراد
else { $false } #الوحدة غير متاحة
} # نهاية إذا لم تكن هناك وحدة
else { $true } #الوحدة محمّلة بالفعل
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# استخراج أعضاء مجموعة Active Directory
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# تعيين ملف تعريف مستخدم AD
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
