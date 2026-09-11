function Reboot-Computer {
<#
.SYNOPSIS
Ця функція використовується для перезапуску віддаленого комп'ютера, списку комп'ютерів у CSV-файлі або частини комп'ютерів (-LIKE).
Ви повинні мати права адміністратора на віддалених комп'ютерах, щоб перезапустити їх.
.DESCRIPTION
Перезапуск віддаленого комп'ютера
.PARAMETER RemoteComputer
Ім'я віддаленого комп'ютера
.PARAMETER CSV
Шлях до CSV-файлу. Одне ім'я комп'ютера на рядок.
.PARAMETER LIKE
Слово, що міститься в імені серверів в Active Directory. Усі комп'ютери, що містять це слово в імені, будуть перезапущені.
.PARAMETER DelaySeconds
Затримка в секундах між перезапуском комп'ютерів.
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$RemoteComputer,
      [string]$CSV,
      [string]$LIKE,
      [int]$DelaySeconds
      )

if($RemoteComputer -ne ""){
    #перезапустити комп'ютерний сервер
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# Перевірка чи існують секунди

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# Імпорт CSV
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# перезапуск списку комп'ютерів
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # Пауза 5 хвилин
              Start-Sleep -Seconds $DelaySeconds
              # Повідомлення
              $message = "$name --OK"
              Write-Host $message
              }
 }


if($like -ne ""){
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


# Список комп'ютерів Active Directory
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# перезапуск списку серверів
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # Пауза 5 хвилин
              Start-Sleep -Seconds $DelaySeconds

              # Повідомлення
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

