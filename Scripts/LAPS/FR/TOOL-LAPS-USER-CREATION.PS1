# Script d'ouverture de session LAPS
# Ce script est un script d'ouverture de session pour créer l'utilisateur Admin pour LAPS
# La GPO refuse la création d'un utilisateur avec mot de passe ; ce script le crée s'il n'existe pas sur l'ordinateur
# Ce script doit être ajouté à une GPO comme script d'ouverture de session
# Le mot de passe est modifié par le service LAPS après la création. Le mot de passe est temporaire.
# Après la création, l'utilisateur est ajouté au groupe local Administrateurs


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
