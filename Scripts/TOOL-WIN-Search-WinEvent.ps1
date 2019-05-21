# Analyse Log and log sources

# All switch to select all logs sources.
$All = $true

$server = "localhost"

# Set the command on the event source parameter
$provider = $event_source

# Provider list if siwtch -ALL is on
if($all -eq $true){$provider = Get-WinEvent -ListLog * -force -ErrorAction SilentlyContinue}

# Level of the event
$level = "erreur"


#$provider = @(
#              "Microsoft-Windows-AppModel-Runtime/Admin"
#              "Microsoft-Client-Licensing-Platform/Admin"
#              )

$level = "erreur"

# Event List
$event_list = @(
                 $provider | foreach{$log_name = $_.logname
                                     $event = try{Get-WinEvent -ComputerName $server -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $level}}catch{$event = $null}
                                     $event
                                    }
                )

# Date for HTML Report 
$date_html = (get-date).DateTime

# HTML Report Building...

$html_report = @(
                "<html>"
                "<head>"
                "<H2>Search-WinEvent HTML report</H2>"
                "<style>"
                'table, th, td {border: 1px solid black;padding: 15px;}'
                'td {white-space: nowrap}'       
                "</style>"
                "</head>"
                "<body>"
                "<H3>Server: $server</H3>"
                "<H3>Date:   $date_html</H3>"
                )


# HTML table Header
$html_report += @(
                '<table style="width:100%">'
                "<tr><th>Event Source</th><th>Time Created</th><th>ID</th><th>Level</th><th>Message</th><th>Google Results</th></tr>"
                )

# Table Row Creation
$html_report += @(
                    $event_list | foreach{
                                          $timecreated = $_.timecreated
                                          $provider = $_.ProviderName
                                          $event_id = $_.id
                                          $level = $_.leveldisplayname
                                          $message = $_.message

                                          # Google search link on the event ID
                                          [string]$google_http = "https://www.google.com/search?q=$provider+$event_id+$message"
                                          [string]$google_link_name = "Google Event $event_id"
                                          [string]$google_link = '<a href="' + $google_http + '" target="_blank">' + "$google_link_name</a>"

                                          $table_row = "<tr><td>$provider</td><td>$timecreated</td><td>$event_id</td><td>$level</td><td>$message</td><td>$google_link</td></tr>"
                                          $table_row
                                          }
                                          )

# Close HTML file
$html_report += @(
                   "</table>"    
                   "<p>Generate by Search-WinEvent powered by PowerShell</p>"
                   "</BODY>"
                   "</HTML>"
                 )


#WAITING FOR COMMAND COMPLETION... ... ... ..

$HTML_REPORT | SET-CONTENT -Path "C:\Users\test\OneDrive\Script\Search-WinEvent\report.html"

start-process -FilePath "C:\Users\test\OneDrive\Script\Search-WinEvent\report.html"


# Part2 Terminated. I continue in Part3.... .... .... 
