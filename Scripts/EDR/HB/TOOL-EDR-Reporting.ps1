# סקריפט זה מיועד לקבלת סטטוס EDR בגיליון Excel בדוא"ל.
# מודולים נדרשים: Active Directory ו-ImportExcel
# WinRM מופעל בכל שרת/מחשב וזכויות מנהל מחשב להרצת Powershell ISE


$server_list = (get-adcomputer -filter * -Properties * | where-object {$_.OperatingSystem -like "*server*"}).name

$liste = @(
foreach($srv in $server_list){

$ping = Test-Connection -Count 2 -ComputerName $srv -Quiet

if($ping -eq $true){


                    Invoke-Command -computername $srv -scriptblock {Get-MpComputerStatus -ErrorAction SilentlyContinue} -ErrorAction SilentlyContinue
                   

                   }

}
)


$liste | Export-Excel -Path "C:\script\report_EDR_Server_status.xlsx" -WorksheetName "EDR" -TableName "EDR" -TableStyle Medium9 -AutoSize

Send-MailMessage -Attachments "C:\script\report_EDR_Server_status.xlsx" -SmtpServer x.x.x.x -From EDR_Servers_Status@contose.com -to "sebastien.maltais@contoso.com" -Subject "Rapport Server EDR"
