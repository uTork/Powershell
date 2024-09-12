# Projet Remove Disabled user from ADgroup

$group_list = get-adgroup -filter * -SearchBase "OU=Groups,DC=Domain,DC=com"

foreach($group in $group_list){

$group_member = Get-ADGroupMember -Identity $group | Where-Object {$_.objectclass -ne "group" -and $_.objectclass -ne "computer" }

foreach($member in $group_member){

$member_property = Get-ADUser -Identity $member -Properties *

if($member_property.enabled -eq $false){

$member_property.name
$group
Remove-ADGroupMember -Identity $group -Members $member_property -Confirm:$false

}

}

}
