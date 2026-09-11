# סקריפט לסגירת הפעלות Windows ברשימת שרתים מרוחקים (כל שרתי Active Directory)
# מודול נדרש: Active Directory
# דורש הרשאות Domain Admins
# החליפו USERNAME בשם המשתמש שלכם


$activedirectory = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*" -and $_.name -like "*namealias*"}).name

foreach($server in $activedirectory){


Invoke-Command -ComputerName $server {

$sessions = quser | Where-Object {$_ -match 'USERNAME'}
$sessionIds = ($sessions -split ' +')[2]

logoff $sessionIds

} -ErrorAction SilentlyContinue



}
