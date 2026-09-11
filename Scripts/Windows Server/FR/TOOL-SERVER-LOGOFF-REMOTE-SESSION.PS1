# Script pour fermer les sessions Windows sur une liste de serveurs distants (tous les serveurs Active Directory)
# Module requis : Active Directory
# Nécessite les droits Domain Admins
# Remplacez USERNAME par votre nom d'utilisateur


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
