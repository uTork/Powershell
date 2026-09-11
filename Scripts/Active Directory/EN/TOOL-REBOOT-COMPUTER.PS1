function Reboot-Computer {
<#
.SYNOPSIS
This function is used to restart a remote computer, a computer list in a CSV file or even a part of the computers (-LIKE).
You must have administrator rights on remote computers before you can restart them.
.DESCRIPTION
Reboot Remote Computer
.PARAMETER RemoteComputer
The name of the remote computer
.PARAMETER CSV
CSV File Path. One computer name per line.
.PARAMETER LIKE
Word contained in the name of the servers in Active Directory. All computers that contain this word in its name will be restarted.
.PARAMETER DelaySeconds
The delay in seconds between computer reboot.
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$RemoteComputer,
      [string]$CSV,
      [string]$LIKE,
      [int]$DelaySeconds
      )

if($RemoteComputer -ne ""){
    #reboot the computer server
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# Validation if Seconds exist

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# CSV import
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# reboot computer list
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # Pause 5 minutes
              Start-Sleep -Seconds $DelaySeconds
              # Message
              $message = "$name --OK"
              Write-Host $message
              }
 }


if($like -ne ""){
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #end if module available then import
else { $false } #module not available
} # end if not module
else { $true } #module already loaded
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Active Directory computer list
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# reboot server list
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # Pause 5 minutes
              Start-Sleep -Seconds $DelaySeconds

              # Message
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

