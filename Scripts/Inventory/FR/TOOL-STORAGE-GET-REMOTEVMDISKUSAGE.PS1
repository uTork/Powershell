function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
Cette fonction a été créée pour analyser l'espace utilisé par un ordinateur distant. Elle calcule chaque disque et calcule le total de l'espace utilisé.

.DESCRIPTION
Analyse les disques d'un ordinateur distant
.PARAMETER COMPUTER
Nom de l'ordinateur distant à analyser
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

# Sélection de l'ordinateur distant à analyser (localhost si vide)
if($computer -eq ""){$computer = "localhost"}

# Création de la liste des disques durs
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Mettre les variables à zéro pour le calcul
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Extraction des métadonnées du disque dur
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Variable à ajouter au total
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# Calcul de l'espace disque
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# Espace utilisé sur le disque
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Espace total alloué à l'ordinateur
[string]$size = [Math]::Round($size /1gb)

# Espace libre total
[string]$free = [Math]::Round($free /1gb)

# Création et affichage de l'objet Powershell
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
