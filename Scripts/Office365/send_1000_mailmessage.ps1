# Send email message to mailbox to create test env


$smtp_server = "relais.videotron.ca"
$from = "office365@ispowershell.net"



$subject_list = @(
             "Allo"
             "Pokemon"
             "Fufu"
             "Octavia"
             "Flower"
             "Orteil"
             "Pomme"
             "apple"
             "hirondelle"
             "88888888888"
                 )

[array]$body_array = (Get-ChildItem -Path "C:\Program Files (x86)" -Recurse -ErrorAction SilentlyContinue | where-object {$_.name -like "*.txt"}).FullName

$recipient = (get-mailbox).UserPrincipalName

1..1000 | FOREACH{
$recipient | foreach{

                     $to = $_
                     $ubject = get-random $subject_list
                     $txt_file = get-random $body_array
                     [string]$body = get-content -Path $txt_file

                     Send-MailMessage -Body $body -Subject $ubject -From $from -TO $to -SmtpServer $smtp_server

                     Start-Sleep -Milliseconds 500

                     }
                     }
