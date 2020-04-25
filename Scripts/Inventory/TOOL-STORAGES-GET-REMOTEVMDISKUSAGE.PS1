function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
Cette fonction a été créée pour analyser l’espace utilisé par un ordinateur distant. 
Elle calcule chaque disque et calcule le total de l’espace utiliser.
.DESCRIPTION
Analyse les disque d'un ordinateur distant
.PARAMETER COMPUTER
Le nom de l'ordinateur distant à analyser
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


# Creation de la liste des disques dur
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Met les variables à zéro pour le calcul
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Extraction des metadata du disque dur
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Variable à ajouter au total
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# Addition de l'espace disque
[long]$size = $size + $add_size
[long]$free = $free + $add_free



}

# Soustratction et conversion du total en GB
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Message de sortit
$output = $computer + " | Disk Usage: " + $used + " GB"

write-output $output
}
