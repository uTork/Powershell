# Printserver Inventory Script
# Module Needed : install-module ImportExcel
# Module Needed : install-module ActiveDirectory

# Import PrintServer list from AD from the get-adcomputer command
$keyword = "spool" # The keyword is a word in the name of all print servers
$Printservers_list =  (get-adcomputer -Filter * -Properties * | where-object {$_.name -like "*$keyword*"}).name

# Excel Report file
$date = (get-date).ToString("ddMMyy")
$excel_file = "C:\Script\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"


$Printservers_list | foreach{

$tryinventory = $null

$printsrv = $_

# List all printers of the remote server
$printer_list = try{Get-Printer -ComputerName $printsrv -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_and_port = @(
                                                  $printer_list | foreach{
                                                                          # List printer ports
                                                                          $printer_port = Get-PrinterPort -ComputerName $printsrv -Name $_.PortName
                                                                          
                                                                          # Powershell object creation
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
                                                # Excel report creation
                                                $printer_and_port | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}




# SMTP Setup
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien_maltais@hotmail.com"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@hyppocampe.ca"

# Send mail
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

# Delete Excel report
Remove-Item -path $excel_file
