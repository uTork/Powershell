# Ajoute les membre du groupe source au groupe de destination Active Directory
# Synchronise les usagers pour des services qui ne supporte pas les groupe de deuxième niveau
# Module : Active Directory
# Auteur: Sébastien Maltais
# Courriel: sebastien_maltais@hotmail.com

# Groupe source
$groupe_source = "domain users"

# Groupe destination
$groupe_destination = "ITIL users"

# Extraction des membres du groupe source
$membres_source = Get-ADGroup $groupe_source | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

# extraction des membres de destination pour la comparaison
$membres_destination = Get-ADGroup $groupe_destination | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

# compare les groupe et extrait les utilisateur manquant du groupe source
$compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


# ajout des utilisateurs au groupe de destination
foreach($membre in $compare){

get-adgroup -Identity $groupe_destination | Add-ADGroupMember -Members $membre

}
