function Reboot-Computer {
<#
.SYNOPSIS
Cette fonction sert à redémarrer un ordinateur distant, une liste d’ordinateur dans un fichier CSV ou encore une partie des ordinateurs (-LIKE).
Vous devez avoir les droits administrateurs sur les ordinateurs distants afin de pouvoir les redémarrer.
.DESCRIPTION
Redémarre les ordinateurs distant
.PARAMETER RemoteComputer
Le nom de l'ordinateur distant à redémarrer
.PARAMETER CSV
Chemin du fichier CSV contenant le nom des ordinateurs. Un nom d'ordinateur par ligne.
.PARAMETER LIKE
Mot contenu dans le nom des serveurs dans Active Directory. Tous les ordinateurs qui contiennent ce mot dans son nom seront redémarrés.
.PARAMETER DelaySeconds
Les nombres de secondes entre chaques démarrage des ordinateurs.
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
    #redémarre l'ordinateur
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# Validation des secondes de delais entre les redémarrage des serveurs

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# Importation CSV
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# Redémarrage des serveurs
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # Pause 5 minutes
              Start-Sleep -Seconds $DelaySeconds
              # Message
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
} #fin si le module est disponible alors importer
else { $false } #module non disponible
} # fin si pas de module
else { $true } #module déjà chargé
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Liste d'ordinateurs Active Directory
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# Redémarrage des serveurs
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # Pause 5 minutes
              Start-Sleep -Seconds $DelaySeconds

              # Message
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

