# Script de inicio de sesión LAPS
# Este script es un script de inicio de sesión para crear el usuario Admin para LAPS
# La GPO impide crear un usuario con contraseña; este script lo crea si no existe en el equipo
# Este script debe añadirse a una GPO como script de inicio de sesión
# La contraseña la cambia el servicio LAPS tras la creación. La contraseña es temporal.
# Tras la creación, el usuario se añade al grupo local de administradores


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
