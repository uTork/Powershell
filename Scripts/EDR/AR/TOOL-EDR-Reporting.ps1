# يهدف هذا البرنامج النصي إلى الحصول على حالة EDR في ورقة Excel عبر البريد الإلكتروني.
# الوحدات المطلوبة: Active Directory و ImportExcel
# يجب تفعيل WinRM على كل خادم/كمبيوتر وحقوق مسؤول الكمبيوتر لتشغيل Powershell ISE


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
