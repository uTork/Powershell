function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
FR
Cette fonction a été créée pour analyser l’espace utilisé par un ordinateur distant. Elle calcule chaque disque et calcule le total de l’espace utiliser.

EN
This function was created to analyze the space used by a remote computer. It calculates each disk and calculates the total space used.

.DESCRIPTION
Analyse les disque d'un ordinateur distant | Scan disks on a remote computer
.PARAMETER COMPUTER
Le nom de l'ordinateur distant à analyser | Computer name to scan
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

# Sélection de l'ordinateur local si aucun nom d'ordinateur n'est saisit
# Select the remote computer to analyze
if($computer -eq ""){$computer = "localhost"}

# Creation de la liste des disques dur
# Hard rive list creation
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Met les variables à zéro pour le calcul
# Set the variable to zero.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Extraction des metadata du disque dur
# Hard drive metadata extraction
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Variable à ajouter au total
# Variable to add
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# calcule de l'espace disque
# disk space calcul
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# espace utiliser sur le disque
# Space used on disk
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Espace totale alloué à l'ordinateur
# Total space allocated
[string]$size = [Math]::Round($size /1gb)

# Esapce libre total
# total Free Space
[string]$free = [Math]::Round($free /1gb)

# Creation et affichage de l'objet powershell
# Powershell object creation and display
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
