function Sync-ADGroupMembers {
<#
.SYNOPSIS

Скрипт створено для синхронізації членів групи domain users з іншою групою Active Directory.
Функція використовується в запланованому завданні, яке виконується кожні 15 хвилин. Коли користувача додано до
групи "domain users" наприклад. Користувач синхронізується під час виконання запланованого завдання.

.DESCRIPTION
Синхронізує членів групи-джерела з групою призначення. Лише члени першого рівня групи-джерела.
.PARAMETER SOURCE
Група-джерело Active Directory
.PARAMETER DESTINATION
Група призначення Active Directory
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$SOURCE,
      [string]$DESTINATION
      )

# Витягнення членів джерела у змінну
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# Витягнення членів призначення для порівняння
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # Порівняти групи та отримати різницю користувачів
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # додати різницю користувачів до призначення
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # додати всіх користувачів джерела до групи призначення
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
