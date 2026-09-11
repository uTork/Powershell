# برنامج نصي لتشغيل GPUPDATE على كمبيوتر بعيد بصمت
# الوحدة المطلوبة ActiveDirectory

$Computer_list = (Get-ADComputer -Filter * -Properties * -SearchBase "OU=Computers,OU=NRBHSS,DC=rr17rrsss,DC=rtss,DC=qc,DC=ca").name

foreach($computer in $Computer_list){

Invoke-Command -ComputerName $computer -ScriptBlock {gpupdate /force} -asjob


}
