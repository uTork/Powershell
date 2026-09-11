function Set-ADuserTsprofile {
<#
.SYNOPSIS

Esta función permite cambiar la ruta del perfil de terminal server en los usuarios miembros de un grupo de Active Directory.
Esta función se utilizará en una tarea programada que se ejecuta cada 15 minutos.

.DESCRIPTION
Configurar la ruta del perfil de Terminal Server del usuario de AD
.PARAMETER ADGroup
Grupo de origen de Active Directory que contiene los miembros a configurar
.PARAMETER TSProfilePath
Ruta UNC del perfil TS. Ej: "\\server\share$\%username%"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$ADGroup,
      [string]$TSProfilePath
      )

# Validación de la instalación del módulo ImportExcel
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


# Extracción de los miembros del grupo de Active Directory
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# Establecer el perfil del usuario AD
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
