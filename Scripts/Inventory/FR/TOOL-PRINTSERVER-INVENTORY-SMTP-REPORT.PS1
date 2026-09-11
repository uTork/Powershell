# Script d'inventaire des serveurs d'impression
# Module requis : install-module ImportExcel
# Module requis : install-module ActiveDirectory

# Importer la liste des serveurs d'impression depuis AD avec get-adcomputer
$keyword = "spool" # Le mot clé contenu dans le nom des serveurs d'impression
$Printservers_list =  (get-adcomputer -Filter * -Properties * | where-object {$_.name -like "*$keyword*"}).name

# Fichier de rapport Excel
$date = (get-date).ToString("ddMMyy")
$excel_file = "C:\Script\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"


$Printservers_list | foreach{

$tryinventory = $null

$printsrv = $_

# Liste des imprimantes du serveur distant
$printer_list = try{Get-Printer -ComputerName $printsrv -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_and_port = @(
                                                  $printer_list | foreach{
                                                                          # Liste des ports d'imprimante
                                                                          $printer_port = Get-PrinterPort -ComputerName $printsrv -Name $_.PortName
                                                                          
                                                                          # Création de l'objet Powershell
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
                                                # Création du rapport Excel
                                                $printer_and_port | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}




# Configuration SMTP
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien_maltais@hotmail.com"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@hyppocampe.ca"

# Envoi du courriel
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

# Supprimer le rapport Excel
Remove-Item -path $excel_file
