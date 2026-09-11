# 用于在远程服务器列表（Active Directory 的所有服务器）上关闭 Windows 会话的脚本
# 所需模块：Active Directory
# 需要 Domain Admins 权限
# 将 USERNAME 替换为您自己的用户名


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
