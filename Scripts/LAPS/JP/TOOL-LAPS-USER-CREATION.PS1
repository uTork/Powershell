# LAPS ログオンスクリプト
# このスクリプトは LAPS 用の Admin ユーザーを作成するログオンスクリプトです
# GPO はパスワード付きユーザー作成を拒否するため、ユーザーが存在しない場合にこのスクリプトで作成します
# このスクリプトはログオンスクリプトとして GPO に追加する必要があります
# 作成後、パスワードは LAPS サービスによって変更されます。パスワードは一時的です。
# 作成後、ユーザーはローカル Administrators グループに追加されます


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
