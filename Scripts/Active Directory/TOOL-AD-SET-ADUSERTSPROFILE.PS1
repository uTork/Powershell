function Set-ADuserTsprofile {
<#
.SYNOPSIS
Cette fonction permet de changé le path du profile terminal serveur sur les utilisateurs members d'un groupe Active Directory.
Cette fonction sera utiliser dans une tâches planifié qui s'exécute au 15minutes.
.DESCRIPTION
Configure le Path du profile Terminal Server de l'objet active des usagers membres d'un groupe AD
.PARAMETER ADGroup
Groupe Source Active Directory qui contient les membres a configurer
.PARAMETER TSProfilePath
PATH UNC du chemin du profile TS . Ex: "\\server\share$\%username%"
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

# ImportExcel module installation validation
# Validation de l'installation du module ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #end if module available then import
else { $false } #module not available
} # end if not module
else { $true } #module already loaded
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Extraction des membres du groupe active directory
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}

# Ajout du chemin du profil à l'attribut AD de l'usager
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet(“terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
