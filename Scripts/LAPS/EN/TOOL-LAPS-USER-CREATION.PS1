# LAPS Logon Script
# This script is a logon script to create the Admin User for LAPS
# The GPO denies creating a user with a password; this script creates the user if it does not exist on the computer
# This script needs to be added to a GPO as a logon script
# The password is changed by the LAPS Service after creation. The password is temporary.
# After creation the user is added to the local admin group


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
