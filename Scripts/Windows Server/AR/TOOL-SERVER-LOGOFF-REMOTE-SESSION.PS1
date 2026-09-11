# برنامج نصي لإغلاق جلسات Windows على قائمة خوادم بعيدة (كل خوادم Active Directory)
# الوحدة المطلوبة: Active Directory
# يتطلب حقوق Domain Admins
# استبدل USERNAME باسم المستخدم الخاص بك


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
