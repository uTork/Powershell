function Sync-ADGroupMembers {
<#
.SYNOPSIS

FR
Le script a été creer pour synchroniser les membres du groupe domain users vers un autres groupe active directory.
La fonction sert dans une tâche planifié qui s'exécute à toutes les 15 minutes. Quand un utilisateur est ajouté au
groupe "domain users" par exemple. L'utilisateur ce synchronise quand la tâche planifier s'exécute.

EN
The script was created to synchronize members of the domain user group to another Active Directory group.
The function is used in a scheduled task that runs every 15 minutes. When a user is added to the
"domain users" group for example. The user synchronizes when the scheduled task runs.

.DESCRIPTION
Synchronise les membres du groupe source vers le groupe de destination. Les membres du premier niveau du groupe source seulement.
Synchronizes the members of the source group to the destination group. The first level members of the source group only.
.PARAMETER SOURCE
Groupe Source Active Directory | Active Directory Source Group
.PARAMETER DESTINATION
Groupe de Destination Active Directory | Active Directory Destination Group
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

# Extraction des membres du groupe source | Extract sources members to variable
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# extraction des membres de destination pour la comparaison | Extract destination members for comparaison
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # compare les groupes et extrait les utilisateurs manquant du groupe source | Compare group and get users differential
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # ajout des utilisateurs au groupe de destination si il ya un delta | add user diffenrencial to destination
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # ajout tout les utilisateurs au complet du groupe source | add all source user to the destination group
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
