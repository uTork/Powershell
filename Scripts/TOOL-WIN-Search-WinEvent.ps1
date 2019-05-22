# Analyse Log and log sources

# All switch to select all logs sources.
$All = $false

$server = "localhost"

$mail_address = "sebastien_maltais@hotmail.com"

$level = "error"

$html = $true

$mail = $true


#Culture | Translate the level to french if the Windows is in french langage
$cult = (get-culture).name

if($cult -like "*FR*"){

                      if($level = "critical"){$level = "Critique"}
                      if($level = "error"){$level = "Erreur"}
                      if($level = "Warning"){$level = "Avertissement"}
                      }

# Set the command on the event source parameter
$provider = $event_source

# Provider list if siwtch -ALL is on
if($all -eq $true){$provider = Get-WinEvent -ListLog * -force -ErrorAction SilentlyContinue}

# Level of the event
$level = "erreur"


$provider = @(
              "Microsoft-Windows-AppModel-Runtime/Admin"
              "Microsoft-Client-Licensing-Platform/Admin"
               "Microsoft-Windows-User Device Registration/Admin"
               'Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin'
               
                      )



# Event List
$event_list = @(
                 $provider | foreach{$log_name = $_ #$_.logname
                                     $event = try{Get-WinEvent -ComputerName $server -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $level}}catch{$event = $null}
                                     $event
                                    }
                )

# Group Event by provider and ID
$event_list = $event_list | Group-object id, Providername

[array]$event_Filtered = "ProviderName,timecreated,id,leveldisplayname,message,Count"

$event_Filtered += @(
                    $event_list | foreach{
                                          $gr = $_.group | sort TimeCreated
                                          $event = $gr | Select-Object -Last 1

                                          $timecreated = $event.timecreated
                                          $provider = $event.ProviderName
                                          $event_id = $event.id
                                          $level = $event.leveldisplayname
                                          $message = $event.message
                                          $message = $message -replace ",",""
                                          $count = $_.Count

                                          $event_last = $provider + "," + $timecreated + "," + $event_id + "," + $level + "," + $message + "," + $count
                                          $event_last
                                         }
               )

$event_list = $event_Filtered | convertfrom-csv

# Generate HTML report in temp directory
if($html -eq $true){

# Date for HTML Report 
$date_html = (get-date).DateTime

# HTML Report Building...

$html_report = @(
                "<html>"
                "<head>"
                "<H2>Search-WinEvent HTML report</H2>"
                "<style>"
                #'table {border: 1px solid black;white-space: nowrap;}'
                #'table {table-layout: auto;width:100%;}'
                #'table, th, td {border: 1px solid black;padding: 15px;white-space: nowrap;max-width:100%;}'
                'table, th, td {border: 1px solid black;border-collapse: collapse;white-space: nowrap;}'
                #'td {white-space: nowrap}'       
                "</style>"
                "</head>"
                "<body>"
                "<H3>Server: $server</H3>"
                "<H3>Date:   $date_html</H3>"
                )


# HTML table Header
$html_report += @(
                '<table style="width:100%">'
                "<tr><th>Event Source</th><th>Count</th><th>Time Created</th><th>ID</th><th>Level</th><th>Message</th><th>Google Results</th></tr>"
                )

# Table Row Creation
$html_report += @(
                    $event_list | foreach{
                                          $timecreated = $_.timecreated
                                          $provider = $_.ProviderName
                                          $event_id = $_.id
                                          $level = $_.leveldisplayname
                                          $message = $_.message
                                          $number_of_repeat = $_.count

                                          # Google search link on the event ID
                                          [string]$google_http = "https://www.google.com/search?q=$provider+event+id+$event_id+$message"
                                          [string]$google_link_name = "Google Event $event_id"
                                          [string]$google_link = '<a href="' + $google_http + '" target="_blank">' + "$google_link_name</a>"

                                          $table_row = "<tr><td>$provider</td><td>$number_of_repeat</td><td>$timecreated</td><td>$event_id</td><td>$level</td><td>$message</td><td>$google_link</td></tr>"
                                          $table_row
                                          }
                                          )

# Close HTML file
$html_report += @(
                   "</table>"    
                   "<p>Generate from the computer $env:computername by the command Search-WinEvent powered by PowerShell</p>"
                   "</BODY>"
                   "</HTML>"
                 )


# HTML File Creation
$html_path = $env:temp + "\report_search-winevent.html"

$HTML_REPORT | SET-CONTENT -Path $html_path

# Launch the web browser with the HTML Report
if($mail -eq $false){start-process -FilePath $html_path}

# Set the Body of the email with the HTML report
if($mail -eq $true){[string]$mail_body = $html_report}

}

# Output the report to the console or email body in text
if($html -eq $false){ If($mail -eq $false){$event_list | Format-table}

                      
                      If($mail -eq $true){$mail_body = $event_list} # Set the Body of the email with the text report 
}


# Send report by email
if($mail -eq $true){

    $date_mail = (get-date).DateTime
    $port = "25"
    $subject = "WinEvent Report of the Computer: $env:computername | $date_mail"
    $from_mail = "WinEvent_Report@ispowershell.com"
    $SmtpServer = "smtp.videotron.ca"
    
    if($credential -eq $null){
                              Send-mailmessage -from $from_mail -To $mail_address -Port $port -Body $mail_body -Subject $subject -SmtpServer $SmtpServer -Encoding UTF8 -BodyAsHtml
                          }

    if($credential -ne $null){
                              Send-mailmessage -from $from_mail -To $mail_address -Port $port -Credential $credential  -Body $mail_body -Subject $subject -SmtpServer $SmtpServer -BodyAsHtml
                           }


}

# Finish for tonight next steps in part4
