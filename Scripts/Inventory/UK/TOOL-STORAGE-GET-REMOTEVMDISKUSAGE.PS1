function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
Цю функцію створено для аналізу використаного простору на віддаленому комп’ютері. Вона обчислює кожен диск і загальний використаний простір.

.DESCRIPTION
Сканувати диски на віддаленому комп’ютері
.PARAMETER COMPUTER
Ім’я комп’ютера для сканування
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param(
      [string]$COMPUTER
     )

# Вибрати віддалений комп’ютер для аналізу
if($computer -eq ""){$computer = "localhost"}

# Створення списку жорстких дисків
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Встановити змінні в нуль.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Витягування метаданих жорсткого диска
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Змінна для додавання до підсумку
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# Обчислення місця на диску
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# Використане місце на диску
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Загальний виділений простір
[string]$size = [Math]::Round($size /1gb)

# Загальний вільний простір
[string]$free = [Math]::Round($free /1gb)

# Створення та відображення об’єкта Powershell
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
