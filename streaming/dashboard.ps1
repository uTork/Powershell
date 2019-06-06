$servername = $env:computername

$date = Get-Date -format "dd-MMM-yyyy HH:mm"

$Dashboard_title = "| isPowerShell UDashboard | Server: $servername | Date: $date |"

# Last System Error Event
$error_system = try{Get-EventLog -LogName System -EntryType Information  -ErrorAction stop | Sort-Object Time | Select-Object -Last 5}catch{$error_system_message = "No application Error";$sys_null = $true}


# Last Application Error Event
$error_application = try{Get-EventLog -LogName application -EntryType information -ErrorAction stop | Sort-Object Time | Select-Object -Last 5}catch{$error_application_message = "No application Error";$app_null = $true}



$page = @( 

            New-UDPage -Name "Event" -Content {

            New-UDHeading -Text "Event Dashboard Viewer" -Size 5

            New-UDTable -Title "System Event Log" -Headers @("Time", "Source", "Message") -FontColor "black" -Endpoint {
            $error_system | Out-UDTableData -Property @("Timegenerated", "Source", "Message")
    }
            New-UDTable -Title "Application Event Log" -Headers @("Time", "Source", "Message") -FontColor "black" -Endpoint {
            $error_application | Out-UDTableData -Property @("Timegenerated", "Source", "Message")
    }
    }
    

            New-UDPage -Name "Processor" -Content {


            New-UDMonitor -Title "Processor Performance (%)" -Type Line -Width "20%" -Endpoint {
            [math]::Round(((get-counter -Counter "\Processor Information(*)\% Processor Performance").CounterSamples | where-object {$_.instancename -eq "_total"}).CookedValue)  | Out-UDMonitorData
                                                                                   } -DataPointHistory 20 -RefreshInterval 1
          }
          )


$Dashboard = New-UDDashboard -Pages $page




    




Start-UDDashboard -Dashboard $Dashboard -Port 10001

#get-UDDashboard | Stop-UDDashboard

