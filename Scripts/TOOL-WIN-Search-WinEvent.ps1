function Search-WinEvent {
<#
.SYNOPSIS
Analyze Windows logs for event id or specific event level and generate HTML report.

.DESCRIPTION
The script search ID or Event level in log sources

.PARAMETER EventLog
The name of the log you want to query. Ex: "application" or "Windows Networking Vpn Plugin Platform/Operational"

.PARAMETER ALL
Select all windows event log (replace the EventLog parameter. Take long time to analyze.

.PARAMETER ID
The event id you want to search.

.PARAMETER HTML
Show the result in HTML report and open the web browser.

.PARAMETER Mail
Attach and and send the html or csv report

.PARAMETER SmtpServer
Hostname or ip address of your mail smtp server

.PARAMETER Port
TCP/IP Port of your SMTP service

.PARAMETER from_mail
Mail address of the sender of this email. Ex: report@ispowershell.com

.PARAMETER MailTo
Mail address of the recipient.

.PARAMETER from_mail
Mail address of the sender of this email. Ex: report@ispowershell.com

.EXAMPLE
Search-Bing -keyword chien -number_of_result 200
Give 200 results of the search
.EXAMPLE 
Search-Bing -keyword chien -number_of_result 200 -HTML
Give 200 results of the search and open HTML report with the link
.LINK
SÃ©bastien Maltais
sebastien_maltais@hotmail.com
https://github.com/uTork/Powershell/
.INPUTS
[string]
.OUTPUTS
[string] or [pscustomobject]
#>


param([string]$EventLog,[switch]$ALL,[int]$ID,[string]$EventLevel,[switch]$Html,[switch]$mail,[string]$SmtpServer,[int]$port,[string]$from_mail,[string]$MailTo)

# All switch to select all logs sources.
#$All = $false

#$server = "localhost"

#$MailTo = "sebastien_maltais@hotmail.com"

#$EventLevel = "critical"

#$html = $true

#$mail = $false

#$ID = $null

##testing testing testing....


#Culture | Translate the level to french if the Windows is in french langage
$cult = (get-culture).name

$level = $EventLevel
if($cult -like "*FR*"){

                      if($level = "critical"){$level = "Critique"}
                      if($level = "error"){$level = "Erreur"}
                      if($level = "Warning"){$level = "Avertissement"}
                      if($level = "Informational"){$level = "Information"}
                      if($level = "Verbose"){$level = "Commentaires"}
                      
                      }

# Set the command on the event source parameter
$provider = $event_source

# Provider list if siwtch -ALL is on
if($all -eq $true){$provider = (Get-WinEvent -ListLog * -force -ErrorAction SilentlyContinue).LogName}



$EventLog = @(
              "Application"
             )


# Event List from the source
$event_list = @(
                 $EventLog  | foreach{
                                     $log_name = $_ 

                                     if($id -eq $null -and $level -ne $null){try{Get-WinEvent -ComputerName $server -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $level}}catch{$event = $null}}
                                     if($id -ne $null -and $level -eq $null){try{Get-WinEvent -ComputerName $server -LogName $log_name -Erroraction Stop | where-object {$_.id -eq $id}}catch{$event = $null}}
                                     if($id -ne $null -and $level -ne $null){try{Get-WinEvent -ComputerName $server -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $level -and $_.id -eq $id}}catch{$event = $null}}
                                    }
                )

# Sort Alphabetical order
$event_list = $event_list | sort ProviderName

# Group Event by provider and ID
$event_list = $event_list | Group-object id, Providername


# PS object Creation from the last event of the set
$event_Filtered = @(
                    $event_list | foreach{
                                          $gr = $_.group | sort TimeCreated
                                          $event = $gr | Select-Object -Last 1

                                          $timecreated = $event.timecreated
                                          $provider = $event.ProviderName
                                          $event_id = $event.id
                                          $level = $event.leveldisplayname
                                          $message = $event.message
                                          $count = $_.Count

                                          $event_last = New-Object PSObject
                                          $event_last | Add-Member -type NoteProperty -Name 'ProviderName' -Value $provider
                                          $event_last | Add-Member -type NoteProperty -Name 'timecreated' -Value $timecreated
                                          $event_last | Add-Member -type NoteProperty -Name 'id' -Value $event_id
                                          $event_last | Add-Member -type NoteProperty -Name 'leveldisplayname' -Value $level
                                          $event_last | Add-Member -type NoteProperty -Name 'message' -Value $message
                                          $event_last | Add-Member -type NoteProperty -Name 'Count' -Value $count
                                          $event_last
                                         }
               )



# Generate HTML report in temp directory
if($html -eq $true){

# Date for HTML Report 
$date_html = (get-date).DateTime

# HTML Report Building...

$html_report = @(
                "<html>"
                "<head>"
                '<H3>Windows Events | <font color="#3399ff">HTML Report</font></H4>'
                "<style>"
                'table {table-layout:fixed;width:auto;white-space:nowrap;}'
                'th, td {border: 1px solid black;padding: 15px;white-space: nowrap;max-width:100%;}'       
                "</style>"
                "</head>"
                "<body>"
                '<H4>Server: <font color="#3399ff">' + $server + '</font></H3>'
                '<H5>Date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#3399ff">' + $date_html + '</font></H5>'
                )

# HTML Table Header color
$header_color = 'bgcolor="#3399ff"'

# HTML table Header
$html_report += @(
                '<table>'
                "<tr><th $header_color>Event Source</th><th $header_color>Count</th><th $header_color>Time Created</th><th $header_color>ID</th><th $header_color>Level</th><th $header_color>Message</th><th $header_color>Google Results</th></tr>"
                )
                
# Table Row Creation
$html_report += @(
                    $event_Filtered | foreach{
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
                   "<p>** Count = number of repeat of the same event.</p>"    
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

# CSV/TEXT Report path for the mail attachement 
$csv_path = $env:temp + "\report_search-winevent.csv"
# Output the report to the console
if($html -eq $false -and $mail -eq $false){$event_list | convertfrom-csv | Format-table}

# Set the Body of the email with the text report for the mail attachement                   
If($html -eq $false -and $mail -eq $true){$event_list | export-csv -NoTypeInformation -Path $csv_path } 



# Send report by mail
if($mail -eq $true){

    $date_mail = (get-date).DateTime
    #$port = "25"
    $subject = "WinEvent Report of the Computer: $server | $date_mail"
    #$from_mail = "WinEvent_Report@ispowershell.com"
    #$SmtpServer = "smtp.videotron.ca"
    if($html -eq $true){$attachement = $html_path}else{$attachement = $csv_path}

    # Body of the mail ...simple
    [string]$html_body = @(
                    "<hml>"
                    "<Head></head>"
                    "<body>"
                    "<h2>The report is in the attachement</H2>"
                    "</body>"
                    "</html>"
                    )




    #SMTP Server credential user/pass
    if($SmtpUser -ne $null -and $SmtpPassword -ne $null){
                                                         $SmtpPassword = ConvertTo-SecureString $SmtpPassword -AsPlainText -Force                                                 
                                                         $credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $SmtpUser, $SmtpPassword
                                                        }
    # Smtp anonymous
    if($credential -eq $null){
                              Send-mailmessage -from $from_mail -To $MailTo -Port $port -Body $html_body -Subject $subject -Attachments $attachement -SmtpServer $SmtpServer -Encoding UTF8 -BodyAsHtml
                             }
    # Smtp with Authentification
    if($credential -ne $null){
                              Send-mailmessage -from $from_mail -To $MailTo -Port $port -Credential $credential  -Body $html_body -Attachments $attachement -Subject $subject -SmtpServer $SmtpServer -BodyAsHtml
                             }


}
}

# Part 4 terminated. Next step in part 5
