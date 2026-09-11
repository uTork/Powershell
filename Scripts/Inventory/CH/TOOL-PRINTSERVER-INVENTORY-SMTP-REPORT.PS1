# 打印服务器清单脚本
# 所需模块 : install-module ImportExcel
# 所需模块 : install-module ActiveDirectory

# 使用 get-adcomputer 命令从 AD 导入打印服务器列表
$keyword = "spool" # 关键字是所有打印服务器名称中的词
$Printservers_list =  (get-adcomputer -Filter * -Properties * | where-object {$_.name -like "*$keyword*"}).name

# Excel 报告文件
$date = (get-date).ToString("ddMMyy")
$excel_file = "C:\Script\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"


$Printservers_list | foreach{

$tryinventory = $null

$printsrv = $_

# 列出远程服务器上的所有打印机
$printer_list = try{Get-Printer -ComputerName $printsrv -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_and_port = @(
                                                  $printer_list | foreach{
                                                                          # 列出打印机端口
                                                                          $printer_port = Get-PrinterPort -ComputerName $printsrv -Name $_.PortName
                                                                          
                                                                          # 创建 Powershell 对象
                                                                          [pscustomobject]@{
                                                                                            'Name' = $_.name
                                                                                            'Status' = $_.PrinterStatus
                                                                                            'Location' = $_.Location                                                                                            
                                                                                            'Description' = $_.Description
                                                                                            'Driver Name' = $_.DriverName
                                                                                            'Port Name' = $_.PortName
                                                                                            'Port IP Address' = $printer_port.PrinterHostAddress
                                                                                            'Published' = $_.Published
                                                                                            'Shared' = $_.Shared
                                                                                            'Share Name' = $_.ShareName 
                                                                                            }  
                                                                            }
                                                 )
                                                # 创建 Excel 报告
                                                $printer_and_port | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}




# SMTP 设置
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien_maltais@hotmail.com"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@hyppocampe.ca"

# 发送邮件
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

# 删除 Excel 报告
Remove-Item -path $excel_file
