function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
This function was created to analyze the space used by a remote computer. It calculates each disk and calculates the total space used.

.DESCRIPTION
Scan disks on a remote computer
.PARAMETER COMPUTER
Computer name to scan
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param(
      [string]$COMPUTER
     )

# Select the remote computer to analyze
if($computer -eq ""){$computer = "localhost"}

# Hard drive list creation
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# Set the variable to zero.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# Hard drive metadata extraction
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# Variable to add
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# Disk space calculation
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# Space used on disk
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# Total space allocated
[string]$size = [Math]::Round($size /1gb)

# Total free space
[string]$free = [Math]::Round($free /1gb)

# Powershell object creation and display
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
