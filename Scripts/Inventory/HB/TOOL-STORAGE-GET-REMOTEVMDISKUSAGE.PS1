function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
פונקציה זו נוצרה לניתוח השטח שבשימוש במחשב מרוחק. היא מחשבת כל דיסק ואת סך השטח שבשימוש.

.DESCRIPTION
סריקת דיסקים במחשב מרוחק
.PARAMETER COMPUTER
שם המחשב לסריקה
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

# בחירת המחשב המרוחק לניתוח
if($computer -eq ""){$computer = "localhost"}

# יצירת רשימת כוננים קשיחים
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# הגדרת המשתנים לאפס.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# חילוץ מטא-נתונים של הכונן הקשיח
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# משתנה להוספה לסכום
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# חישוב שטח דיסק
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# שטח בשימוש בדיסק
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# שטח כולל שהוקצה
[string]$size = [Math]::Round($size /1gb)

# שטח פנוי כולל
[string]$free = [Math]::Round($free /1gb)

# יצירה והצגה של אובייקט Powershell
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
