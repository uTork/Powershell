# Script analyse inactive user Active Directory
# needed module : Active Directory
# needed module : install-module -name importexcel

$excel = "C:\share\report_ad_user_logon.xlsx"

$user = get-aduser -filter * -Properties *

$date_y = (date).AddDays(-365)

$userlist_y = @(
                $user | foreach{
                
                [string]$logon = $_.LastLogonDate
                if($logon -ne ""){[datetime]$logon = $logon}
                if($logon -lt $date_y -and $logon -ne ""){$_}

                }
             )

$userlist_y = $userlist_y | select-object Name,samaccountname,mail,description,LastLogonDate,enabled

$userlist_y | Export-Excel -Path $excel -WorksheetName "1 year" -TableName "year" -TableStyle Medium9 -AutoSize


$date_6m = (date).AddMonths(-6)

$userlist_6m = @(
                $user | foreach{
                
                [string]$logon = $_.LastLogonDate
                if($logon -ne ""){[datetime]$logon = $logon}
                if($logon -lt $date_6m -and $logon -ne ""){$_}

                }
             )

$userlist_6m = $userlist_6m | select-object Name,samaccountname,mail,description,LastLogonDate,enabled

$userlist_6m | Export-Excel -Path $excel -WorksheetName "6 month" -TableName "sixm" -TableStyle Medium9 -AutoSize


$date_2m = (date).AddMonths(-2)

$userlist_2m = @(
                $user | foreach{
                [string]$logon = $_.LastLogonDate
                if($logon -ne ""){[datetime]$logon = $logon}
                if($logon -lt $date_2m -and $logon -ne ""){$_}
                }
             )

$userlist_2m = $userlist_2m | select-object Name,samaccountname,mail,description,LastLogonDate,enabled

$userlist_2m | Export-Excel -Path $excel -WorksheetName "2 month" -TableName "twom" -TableStyle Medium9 -AutoSize

$date_1m = (date).AddMonths(-1)

$userlist_1m = @(
                $user | foreach{
                [string]$logon = $_.LastLogonDate
                if($logon -ne ""){[datetime]$logon = $logon}
                if($logon -lt $date_1m -and $logon -ne ""){$_}
                }
             )

$userlist_1m = $userlist_1m | select-object Name,samaccountname,mail,description,LastLogonDate,enabled

$userlist_1m | Export-Excel -Path $excel -WorksheetName "1 month" -TableName "onem" -TableStyle Medium9 -AutoSize


$never_logged = $user | where-object {$_.LastLogonDate -eq $null}

$never_logged = $never_logged | select-object Name,samaccountname,mail,description,LastLogonDate,enabled

$never_logged | Export-Excel -Path $excel -WorksheetName "Never Logged" -TableName "never" -TableStyle Medium9 -AutoSize

$computer = Get-ADComputer -Filter * -Properties *  | Select-Object Name,LastLogonDate

$computer | Export-Excel -Path $excel -WorksheetName "Computer" -TableName "computer" -TableStyle Medium9 -AutoSize
