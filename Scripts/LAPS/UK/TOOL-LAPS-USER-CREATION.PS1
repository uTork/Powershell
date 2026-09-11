# Скрипт входу LAPS
# Цей скрипт є скриптом входу для створення користувача Admin для LAPS
# GPO забороняє створення користувача з паролем; цей скрипт створює його, якщо він відсутній на комп’ютері
# Цей скрипт потрібно додати до GPO як скрипт входу
# Після створення пароль змінює служба LAPS. Пароль тимчасовий.
# Після створення користувача додають до локальної групи адміністраторів


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
