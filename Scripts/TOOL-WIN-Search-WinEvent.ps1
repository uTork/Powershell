function Search-WinEvent {
<#
.SYNOPSIS
Analyze Windows logs for event id or specific event level and generate HTML or CSV report. By Default: CSV
.DESCRIPTION
The script search ID or Event level in log sources
.PARAMETER EventLog
The name of the log you want to query. Ex: "application" or "Windows Networking Vpn Plugin Platform/Operational" or ....
.PARAMETER ALL
Select all windows event log (replace the EventLog parameter. Take long time to analyze.
.PARAMETER EventLevel
The level of the events you want to query.

Value:
      "critical"
      "error"
      "Warning"
      "Informational"
      "Verbose"

.PARAMETER ID
The event id you want to search.
.PARAMETER HTML
Show the result in HTML report and open the HTML file in the web browser.
.PARAMETER SmtpServer
Hostname or ip address of your smtp mail server
.PARAMETER SmtpUser
SMTP server username
Default:anonymous
.PARAMETER SmtpPassword
SMTP server Password
Default: anonymous
.PARAMETER Port
TCP/IP Port of your SMTP service
Default: 25
.PARAMETER MailFrom
eMail address of the sender of this email. Ex: report@ispowershell.com
.PARAMETER MailTo
eMail address of the recipient.
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
.EXAMPLE
Search event "101" in the EventLog "Microsoft-Client-Licensing-Platform/Admin" and the html report by email.
Search-WinEvent -EventLog "Microsoft-Client-Licensing-Platform/Admin" -EventLevel "information" -id "101" -html -SmtpServer "smtp.videotron.ca" -MailFrom "report@ispowershell.com" -MailTo "sebastien_maltais@hotmail.com"
.EXAMPLE
Generate a report from a list of server to find the same id in the same source

$Server_list = @("Server01"
                 "Server12"
                 "Server55"
                 "Server43"
                 "workstation1"
                 "Server05"
                 )

$server_list | foreach{Search-WinEvent -computername $_ -EventLog "Microsoft-Client-Licensing-Platform/Admin" -EventLevel "information" -id "101" -html -SmtpServer "smtp.videotron.ca" -MailFrom "report@ispowershell.com" -MailTo "recipient@hotmail.com"}

.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
LuinkedIn: https://www.linkedin.com/in/sebastienmaltais/
GIT: https://github.com/uTork/Powershell/
#>

param(
         [string]$ComputerName,
         [string]$EventLog,
         [switch]$ALL,
         [string]$ID,
         [string]$EventLevel,
         [switch]$Html,
         [string]$SmtpServer,
         [string]$SmtpUser,
         [string]$SmtpPassword,
         [int]$port,
         [string]$MailFrom,
         [string]$MailTo
    )

# Translate the level to french if the Windows is in french langage
$cult = (get-culture).name
if($cult -like "*FR*"){
                      if($EventLevel -eq "critical"){$EventLevel = "Critique"}
                      if($EventLevel -eq "error"){$EventLevel = "Erreur"}
                      if($EventLevel -eq "Warning"){$EventLevel = "Avertissement"}
                      if($EventLevel -eq "Informational"){$EventLevel = "Information"}
                      if($EventLevel -eq "Verbose"){$EventLevel = "Commentaires"}
                      }
# Set Localhost as default computername
if($ComputerName -eq ""){$ComputerName = "localhost"}                      

# Default SMTP Port
if($port -eq ""){$port ="25"}

# EventLog Full list if siwtch -ALL is on
if($all -eq $true){$EventLog = (Get-WinEvent -ListLog * -force -ErrorAction SilentlyContinue).LogName}

# Set script scope variable
$script:EventLevel = $EventLevel
$script:id = $id
$script:computername = $ComputerName
$script:SmtpServer = $SmtpServer
$script:port = $port
[string]$script:from_mail = $MailFrom
[string]$script:mailrecipient = $MailTo
$script:SmtpPassword = $SmtpPassword
$script:SmtpUser = $SmtpUser
$script:HTML = $html

$event_list = @(
                 $EventLog  | foreach{
                                     $log_name = $_ 
                                     
                                     if($id -eq "" -and $script:EventLevel -ne ""){try{Get-WinEvent -ComputerName $script:computername -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $script:EventLevel}}catch{$event = $null}}
                                     if($id -ne "" -and $script:EventLevel -eq ""){try{Get-WinEvent -ComputerName $script:computername -LogName $log_name -Erroraction Stop | where-object {$_.id -eq $script:id}}catch{$event = $null}}
                                     if($id -ne "" -and $script:EventLevel -ne ""){try{Get-WinEvent -ComputerName $script:computername -LogName $log_name -Erroraction Stop | where-object {$_.leveldisplayname -eq $script:EventLevel -and $_.id -eq $script:id}}catch{$event = $null}}
                                    }
                )

# Sort Alphabetical and Group Event by provider and ID
$event_group = $event_list | sort ProviderName | Group-object id, Providername

# PS object Creation from the last event of the set
$script:event_Filtered = @(
                    $event_group | foreach{
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
                                          $event_last | Add-Member -type NoteProperty -Name 'Count' -Value $count
                                          $event_last | Add-Member -type NoteProperty -Name 'id' -Value $event_id
                                          $event_last | Add-Member -type NoteProperty -Name 'leveldisplayname' -Value $level
                                          $event_last | Add-Member -type NoteProperty -Name 'message' -Value $message
                                          
                                          $event_last
                                         }
               )


# Generate HTML report in temp directory
if($script:HTML -eq $true){

# Date for HTML Report 
$date_html = (get-date).DateTime

# HTML Report Building...
$html_report = @(
                "<html>"
                "<head>"
                '<H2>Windows Events | <font color="#3399ff">HTML Report</font> | VM/Server: <font color="#3399ff">' + $script:computername + '</font> | Date: <font color="#3399ff">' + $date_html + '</font></H2>'
                "<style>"
                'table {table-layout:fixed;width:auto;white-space:nowrap;}'
                'th, td {border: 1px solid black;padding: 8px;white-space: nowrap;max-width:100%;}'       
                "</style>"
                "</head>"
                "<body>"
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
                    $script:event_Filtered | foreach{
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
$script:html_path = $env:temp + "\report_search-winevent.html"

$HTML_REPORT | SET-CONTENT -Path $script:html_path

# Launch the web browser with the HTML Report
if($script:SmtpServer -eq ""){start-process -FilePath $script:html_path}
}

# CSV/TEXT Report path for the mail attachement 
$script:csv_path = $env:temp + "\report_search-winevent.csv"

# Output the report to the console
if($script:HTML -ne $true -and $script:SmtpServer -eq ""){$script:event_Filtered | Format-table}

# Set the Body of the email with the text report for the mail attachement                   
If($script:HTML -ne $true -and $script:SmtpServer -ne ""){$script:event_Filtered | Export-csv -NoTypeInformation -Encoding UTF8 -Delimiter "|" -Path $script:csv_path} 

# Send report by mail

if($script:SmtpServer -ne ""){

    $date_mail = (get-date).DateTime
    $subject = "WinEvent Report of the Computer: $script:computername | $date_mail"
    $credential = $null
    if($script:HTML -eq $true){$attachement = $script:html_path}else{$attachement = $script:csv_path}

    # Body of the mail ...simple
    [string]$html_body = @(
                    "<hml>"
                    "<Head></head>"
                    "<body>"
                    "<p>Hello,</p>"
                    "<p>This is an automatic email with your HTML Report. Do not reply this email</p>"
                    "</br>"
                    "<p>Script created by  : Sebastien Maltais - sebastien_maltais@hotmail.com</p>"
                    "</body>"
                    "</html>"
                    )




    #SMTP Server credential user/pass
    if($script:SmtpUser -ne "" -and $script:SmtpPassword -ne ""){
                                                         $script:SmtpPassword = ConvertTo-SecureString $script:SmtpPassword -AsPlainText -Force                                                 
                                                         $credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $script:SmtpUser, $script:SmtpPassword
                                                        }
    # Smtp anonymous
    if($credential -eq $null){
                              try{Send-mailmessage -from $script:from_mail -To $script:mailrecipient -Port $script:port -Body $html_body -Subject $subject -Attachments $attachement -SmtpServer $script:SmtpServer -Encoding UTF8 -BodyAsHtml -ErrorAction stop}catch{$smtp_error = "SMTP Transport failure. Please try again";write-output $smtp_error}
                             }
    # Smtp with Authentification
    if($credential -ne $null){
                              try{Send-mailmessage -from $script:from_mail -To $script:mailrecipient -Port $script:port -Credential $credential  -Body $html_body -Attachments $attachement -Subject $subject -SmtpServer $script:SmtpServer -BodyAsHtml -ErrorAction stop}catch{$smtp_error = "SMTP Transport failure. Please try again";write-output $smtp_error}
                             }


}
}

