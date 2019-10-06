# Printserver Inventory Script
# Module Needed : install-module ImportExcel

# Import printserver list. 
# The servers.txt file need to be placed at the root of the script 
$Printservers_list =  Get-Content "C:\Script\PrintServer_reporting\servers.txt"

# Excel Report file
$date = (get-date).ToString("ddmmyyyy")
$excel_file = "C:\cript\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"

$Printservers_list | foreach{

$tryinventory = $null

$printer_list = try{Get-Printer -ComputerName $_ -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_list | Select-Object name,DriverName,PortName,Published,Shared,ShareName | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}

# SMTP Setup
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien.maltais@ukiton.org"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@ukiton.org"

# Send mail
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

Remove-Item -path $excel_file
