function Set-ADuserTsprofile {
<#
.SYNOPSIS

Ця функція дозволяє змінити шлях профілю термінального сервера для користувачів, які є членами групи Active Directory.
Ця функція використовуватиметься в запланованому завданні, яке виконується кожні 15 хвилин.

.DESCRIPTION
Налаштувати шлях профілю термінального сервера користувача AD
.PARAMETER ADGroup
Група-джерело Active Directory, що містить членів для налаштування
.PARAMETER TSProfilePath
UNC-шлях профілю TS. Приклад: "\\server\share$\%username%"
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

# Перевірка встановлення модуля ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #кінець якщо модуль доступний тоді імпортувати
else { $false } #модуль недоступний
} # кінець якщо немає модуля
else { $true } #модуль вже завантажено
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Витягнення членів групи Active Directory
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# Встановити профіль користувача AD
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
