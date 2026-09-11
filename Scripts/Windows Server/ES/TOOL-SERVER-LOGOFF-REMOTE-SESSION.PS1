# Script para cerrar sesiones de Windows en una lista de servidores remotos (todos los servidores de Active Directory)
# Módulo necesario: Active Directory
# Requiere derechos de Domain Admins
# Reemplace USERNAME por su nombre de usuario


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
