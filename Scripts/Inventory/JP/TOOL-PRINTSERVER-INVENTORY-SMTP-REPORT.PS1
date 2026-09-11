# 印刷サーバーインベントリスクリプト
# 必要なモジュール : install-module ImportExcel
# 必要なモジュール : install-module ActiveDirectory

# get-adcomputer コマンドで AD から印刷サーバー一覧をインポート
$keyword = "spool" # キーワードはすべての印刷サーバー名に含まれる語です
$Printservers_list =  (get-adcomputer -Filter * -Properties * | where-object {$_.name -like "*$keyword*"}).name

# Excel レポートファイル
$date = (get-date).ToString("ddMMyy")
$excel_file = "C:\Script\PrintServer_reporting\PrintServer_Inventory_" + $date + ".xlsx"


$Printservers_list | foreach{

$tryinventory = $null

$printsrv = $_

# リモートサーバーのすべてのプリンターを一覧表示
$printer_list = try{Get-Printer -ComputerName $printsrv -ErrorAction Stop}catch{$tryinventory = $false}

if($tryinventory -ne $false){
                            $printer_and_port = @(
                                                  $printer_list | foreach{
                                                                          # プリンターポートの一覧
                                                                          $printer_port = Get-PrinterPort -ComputerName $printsrv -Name $_.PortName
                                                                          
                                                                          # Powershell オブジェクトの作成
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
                                                # Excel レポートの作成
                                                $printer_and_port | Export-Excel -Path $excel_file -WorksheetName $_ -TableName $_ -TableStyle Medium9 -AutoSize
                            }
}




# SMTP 設定
$server = "10.0.0.14"
$port = "25"
$recipient = "sebastien_maltais@hotmail.com"
$subject = "Print Server Report - $date_sujet"
$sender = "printserver@hyppocampe.ca"

# メール送信
Send-MailMessage -Body "PrintServer Report" -Encoding UTF8 -From $sender -To $recipient -Subject $subject -Attachments $excel_file -SmtpServer $server -Port $port -BodyAsHtml

# Excel レポートを削除
Remove-Item -path $excel_file
