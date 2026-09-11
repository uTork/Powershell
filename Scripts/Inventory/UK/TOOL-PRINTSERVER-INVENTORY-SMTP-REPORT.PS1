# Скрипт інвентаризації серверів друку
# Потрібний модуль : install-module ImportExcel
# Потрібний модуль : install-module ActiveDirectory

# Імпортувати список серверів друку з AD командою get-adcomputer
$keyword = "spool" # Ключове слово — частина імені всіх серверів друку
$Printservers_list =  (get-adcomputer -Filter * -Properties * | where-object {$_.name -like "*$keyword*"}).name

# Файл звіту Excel
$date = (get-date).ToString("ddMMyy")
$excel_file = "C:\Script\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"


$Printservers_list | foreach{

$tryinventory = $null

$printsrv = $_

# Список усіх принтерів віддаленого сервера
$printer_list = try{Get-Printer -ComputerName $printsrv -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_and_port = @(
                                                  $printer_list | foreach{
                                                                          # Список портів принтера
                                                                          $printer_port = Get-PrinterPort -ComputerName $printsrv -Name $_.PortName
                                                                          
                                                                          # Створення об’єкта Powershell
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
                                                # Створення звіту Excel
                                                $printer_and_port | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}




# Налаштування SMTP
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien_maltais@hotmail.com"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@hyppocampe.ca"

# Надіслати лист
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

# Видалити звіт Excel
Remove-Item -path $excel_file
