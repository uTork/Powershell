


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
Show HTML report of the Warning event of the application log of the localhost
Search-WinEvent -EventLog "application" -EventLevel "Warning" -Html


.EXAMPLE 
Output in console the report of the error event of the system log of the localhost
Search-WinEvent -EventLog "system" -EventLevel "Error" 

.EXAMPLE
Show HTML report of the Warning event of the application log of the remote server "server01"
Search-WinEvent -computername "server01" -EventLog "application" -EventLevel "Warning" -Html


.EXAMPLE 
Output in console the report of the error event of the system log of the remote server "server01"
Search-WinEvent -computername "server01" -EventLog "system" -EventLevel "Error"

.LINK
SÃ©bastien Maltais
sebastien_maltais@hotmail.com
https://github.com/uTork/Powershell/
.INPUTS
[string]
.OUTPUTS
[string] or [pscustomobject]
#>

param(

         [Parameter(Mandatory=$False, Position=0)][string] $ComputerName,
         [Parameter(Mandatory=$False, Position=1)][string] $EventLog,
         [Parameter(Mandatory=$False, Position=2)][switch]$ALL,
         [Parameter(Mandatory=$False, Position=3)][int]$ID,
         [Parameter(Mandatory=$true, Position=4)][string]$EventLevel,
         [Parameter(Mandatory=$false, Position=5)][switch]$Html,
         [Parameter(Mandatory=$false, Position=6)][switch]$mail,
         [Parameter(Mandatory=$false, Position=7)][string]$SmtpServer,
         [Parameter(Mandatory=$false, Position=8)][int]$port,
         [Parameter(Mandatory=$false, Position=9)][string]$from_mail,
         [Parameter(Mandatory=$false, Position=10)][string]$MailTo

    )
$EventLog
$EventLevel
# Set Localhost as the computername
if($computername -eq $null){$computername = "localhost"}



# Translate the level to french if the Windows is in french langage
$cult = (get-culture).name


if($cult -like "*FR*"){

                      if($EventLevel -eq "critical"){$EventLevel -eq "Critique"}
                      if($EventLevel -eq "error"){$EventLevel -eq "Erreur"}
                      if($EventLevel -eq "Warning"){$EventLevel -eq "Avertissement"}
                      if($EventLevel -eq "Informational"){$EventLevel -eq "Information"}
                      if($EventLevel -eq "Verbose"){$EventLevel -eq "Commentaires"}
                      
                      }


# EventLog Full list if siwtch -ALL is on
if($all -eq $true){$EventLog = (Get-WinEvent -ListLog * -force -ErrorAction SilentlyContinue).LogName}

$event_list = @(
                 $EventLog  | foreach{
                                     $log_name = $_ 

                                     if($id -eq $null -and $EventLevel -ne $null){try{Get-WinEvent -ComputerName $computername -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $EventLevel}}catch{$event = $null}}
                                     if($id -ne $null -and $EventLevel -eq $null){try{Get-WinEvent -ComputerName $computername -LogName $log_name -Erroraction Stop | where-object {$_.id -eq $id}}catch{$event = $null}}
                                     if($id -ne $null -and $EventLevel -ne $null){try{Get-WinEvent -ComputerName $computername -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $EventLevel -and $_.id -eq $id}}catch{$event = $null}}
                                    }
                )



# Sort Alphabetical and Group Event by provider and ID
$event_list = $event_list | sort ProviderName | Group-object id, Providername


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
                '<H4>Server: <font color="#3399ff">' + $computername + '</font></H3>'
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
    $subject = "WinEvent Report of the Computer: $computername | $date_mail"

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
