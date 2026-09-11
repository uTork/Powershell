# LAPS 登录脚本
# 此脚本是用于为 LAPS 创建 Admin 用户的登录脚本
# GPO 禁止创建带密码的用户；若计算机上不存在该用户，则用此脚本创建
# 需要将此脚本作为登录脚本添加到 GPO
# 创建后由 LAPS 服务更改密码。该密码为临时密码。
# 创建后，用户会被添加到本地 Administrators 组


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
