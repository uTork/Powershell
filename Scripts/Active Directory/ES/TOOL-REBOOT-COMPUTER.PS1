function Reboot-Computer {
<#
.SYNOPSIS
Esta función se usa para reiniciar un equipo remoto, una lista de equipos en un archivo CSV o incluso una parte de los equipos (-LIKE).
Debe tener derechos de administrador en los equipos remotos para poder reiniciarlos.
.DESCRIPTION
Reiniciar equipo remoto
.PARAMETER RemoteComputer
El nombre del equipo remoto
.PARAMETER CSV
Ruta del archivo CSV. Un nombre de equipo por línea.
.PARAMETER LIKE
Palabra contenida en el nombre de los servidores en Active Directory. Todos los equipos que contengan esta palabra en su nombre serán reiniciados.
.PARAMETER DelaySeconds
El retraso en segundos entre el reinicio de los equipos.
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
    #reiniciar el equipo servidor
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# Validación si existen los segundos

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# Importación CSV
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# reiniciar lista de equipos
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # Pausa 5 minutos
              Start-Sleep -Seconds $DelaySeconds
              # Mensaje
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
} #fin si el módulo está disponible entonces importar
else { $false } #módulo no disponible
} # fin si no hay módulo
else { $true } #módulo ya cargado
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Lista de equipos de Active Directory
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# reiniciar lista de servidores
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # Pausa 5 minutos
              Start-Sleep -Seconds $DelaySeconds

              # Mensaje
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

