# Скрипт для закриття сеансів Windows на списку віддалених серверів (усі сервери Active Directory)
# Потрібний модуль: Active Directory
# Потрібні права Domain Admins
# Замініть USERNAME на своє ім’я користувача


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
