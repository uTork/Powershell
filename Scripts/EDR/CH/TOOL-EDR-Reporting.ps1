# 此脚本用于通过电子邮件获取 Excel 表中的 EDR 状态。
# 所需模块：Active Directory 和 ImportExcel
# 每台服务器/计算机需启用 WinRM，并具有运行 Powershell ISE 的计算机管理员权限


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
