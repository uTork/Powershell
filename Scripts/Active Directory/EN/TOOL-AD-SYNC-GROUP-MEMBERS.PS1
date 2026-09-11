function Sync-ADGroupMembers {
<#
.SYNOPSIS

The script was created to synchronize members of the domain user group to another Active Directory group.
The function is used in a scheduled task that runs every 15 minutes. When a user is added to the
"domain users" group for example. The user synchronizes when the scheduled task runs.

.DESCRIPTION
Synchronizes the members of the source group to the destination group. The first level members of the source group only.
.PARAMETER SOURCE
Active Directory Source Group
.PARAMETER DESTINATION
Active Directory Destination Group
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

# Extract sources members to variable
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# Extract destination members for comparaison
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # Compare group and get users differential
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # add user diffenrencial to destination
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # add all source user to the destination group
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
