# リモートサーバー一覧（Active Directory の全サーバー）で Windows セッションを終了するスクリプト
# 必要なモジュール: Active Directory
# Domain Admins 権限が必要
# USERNAME をご自身のユーザー名に置き換えてください


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
