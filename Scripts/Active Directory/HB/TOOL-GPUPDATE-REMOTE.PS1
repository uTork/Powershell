# סקריפט GPUPDATE במחשב מרוחק בשקט
# מודול נדרש ActiveDirectory

$Computer_list = (Get-ADComputer -Filter * -Properties * -SearchBase "OU=Computers,OU=NRBHSS,DC=rr17rrsss,DC=rtss,DC=qc,DC=ca").name

foreach($computer in $Computer_list){

Invoke-Command -ComputerName $computer -ScriptBlock {gpupdate /force} -asjob


}
