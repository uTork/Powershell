function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
Esta función se creó para analizar el espacio usado por un equipo remoto. Calcula cada disco y el espacio total usado.

.DESCRIPTION
Analizar discos en un equipo remoto
.PARAMETER COMPUTER
Nombre del equipo a analizar
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

# Seleccionar el equipo remoto a analizar
if($computer -eq ""){$computer = "localhost"}

# Creación de la lista de discos duros
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Establecer las variables a cero.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Extracción de metadatos del disco duro
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Variable a añadir al total
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# Cálculo del espacio en disco
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# Espacio usado en el disco
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Espacio total asignado
[string]$size = [Math]::Round($size /1gb)

# Espacio libre total
[string]$free = [Math]::Round($free /1gb)

# Creación y visualización del objeto Powershell
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
