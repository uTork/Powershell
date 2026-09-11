function Sync-ADGroupMembers {
<#
.SYNOPSIS

El script fue creado para sincronizar los miembros del grupo domain users hacia otro grupo de Active Directory.
La función se usa en una tarea programada que se ejecuta cada 15 minutos. Cuando un usuario se agrega al
grupo "domain users" por ejemplo. El usuario se sincroniza cuando se ejecuta la tarea programada.

.DESCRIPTION
Sincroniza los miembros del grupo de origen hacia el grupo de destino. Solo los miembros de primer nivel del grupo de origen.
.PARAMETER SOURCE
Grupo de origen de Active Directory
.PARAMETER DESTINATION
Grupo de destino de Active Directory
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

# Extracción de los miembros del grupo de origen
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# extracción de los miembros de destino para la comparación
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # compara los grupos y extrae los usuarios faltantes del grupo de origen
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # agregar usuarios diferenciales al destino
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # agregar todos los usuarios del grupo de origen al destino
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
