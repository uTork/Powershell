function Sync-ADGroupMembers {
<#
.SYNOPSIS
Le script a été creer pour synchroniser les membres du groupe domain users vers un autres groupe active directory.
La fonction sert dans une tâche planifié qui s'exécute à toutes les 15 minutes. Quand un utilisateur est ajouté au
groupe "domain users" par exemple. L'utilisateur ce synchronise quand la tâche planifier s'exécute.
.DESCRIPTION
Synchronise les membres du groupe source vers le groupe de destination. Les membres du premier sont niveau seulement.
.PARAMETER SOURCE
Groupe Source Active Directory
.PARAMETER DESTINATION
Groupe de Destination Active Directory
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$SOURCE,
      [string]$DESTINATION
      )

# Extraction des membres du groupe source
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# extraction des membres de destination pour la comparaison
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # compare les groupe et extrait les utilisateur manquant du groupe source
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # ajout des utilisateurs au groupe de destination si il ya un delta
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    # ajout tout les utilisateurs au complet du groupe source
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
