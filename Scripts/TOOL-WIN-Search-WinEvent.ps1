# Analyse Log and log sources

$All = $false

$server = "localhost"

# Set the command on the event source parameter
$provider = $event_source

# Provider list if siwtch -ALL is on
if($all -eq $true){$provider = Get-WinEvent -ListLog * -force -ErrorAction stop}

# Level of the event
$level = "erreur"


$provider = @(
              "Microsoft-Windows-AppModel-Runtime/Admin"
              "Microsoft-Client-Licensing-Platform/Admin"
              )

$level = "erreur"

# Event List
$event_list = @(
                 $provider | foreach{$log_name = "Microsoft-Windows-AppModel-Runtime/Admin" #$_.logname
                                     $event = Get-WinEvent -ComputerName $server -LogName $log_name | where-object {$_.leveldisplayname -eq $level}
                                     $event
                                    }
                )

$date_html = (get-date).DateTime
# HTML Report Building...

$html_report = @(
                "<html>"
                "<head>"
                "<H2>WinEvent HTML report</H2>"
                "<style>"
                'table, th, td {border: 1px solid black;border-collapse: collapse;}'
                'table {table-layout:fixed}'
                "</style>"
                "</head>"
                "<body>"
                "<H3>Server: $server Date: $date_html</H3>"
                )
# HTML tablea Header
$html_report += @(
                '<table style="width:100%">'
                "<tr><th>Event Source</th><th>Time Created</th><th>ID</th><th>Level</th><th>Message</th></tr>"
                )

$html_report += @(
                    $event_list | foreach{
                                          $timecreated = $_.timecreated
                                          $provider = $_.ProviderName
                                          $event_id = $_.id
                                          $level = $_.leveldisplayname
                                          $message = $_.message

                                          $table_row = "<tr><td>$provider</td><td>$timecreated</td><td>$event_id</td><td>$level</td><td>$message</td></tr>"
                                          $table_row
                                          }
                                          )

$html_report += @(
                   "</table>"    
                   "<p>Generate by Search-WinEvent powered by PowerShell</p>"
                   "</BODY>"
                   "</HTML>"
                 )


#WAITING FOR COMMAND COMPLETION... ... ... ..

$HTML_REPORT | SET-CONTENT -Path "C:\Users\test\OneDrive\Script\Search-WinEvent\report.html"

start-process -FilePath "C:\Users\test\OneDrive\Script\Search-WinEvent\report.html"
