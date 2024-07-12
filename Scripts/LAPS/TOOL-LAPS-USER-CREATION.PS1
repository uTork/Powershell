# LAPS Logon Script
# This is script is a logon script to create the Admin User user for LAPS
# The gpo deny the creation of a user with a password and i use a script to create this one if the user not exist on the comnputer
# This script need to be added to a gpo like a logon script
# The password is change by the LAPS Service after the creation of this one. The password is temporary one.
# After the creation the user is added to the local adfmin group


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
