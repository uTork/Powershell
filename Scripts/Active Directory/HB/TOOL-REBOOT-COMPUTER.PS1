function Reboot-Computer {
<#
.SYNOPSIS
פונקציה זו משמשת להפעלה מחדש של מחשב מרוחק, רשימת מחשבים בקובץ CSV או חלק מהמחשבים (-LIKE).
עליך להיות בעל הרשאות מנהל במחשבים המרוחקים כדי להפעיל אותם מחדש.
.DESCRIPTION
הפעלה מחדש של מחשב מרוחק
.PARAMETER RemoteComputer
שם המחשב המרוחק
.PARAMETER CSV
נתיב קובץ CSV. שם מחשב אחד בכל שורה.
.PARAMETER LIKE
מילה הכלולה בשם השרתים ב-Active Directory. כל המחשבים המכילים מילה זו בשמם יופעלו מחדש.
.PARAMETER DelaySeconds
ההשהיה בשניות בין הפעלה מחדש של מחשבים.
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
    #הפעלה מחדש של שרת המחשב
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# אימות אם קיימות שניות

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# ייבוא CSV
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# הפעלה מחדש של רשימת מחשבים
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # השהיה 5 דקות
              Start-Sleep -Seconds $DelaySeconds
              # הודעה
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
} #סוף אם המודול זמין אז ייבא
else { $false } #מודול לא זמין
} # סוף אם אין מודול
else { $true } #מודול כבר טעון
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# רשימת מחשבים מ-Active Directory
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# הפעלה מחדש של רשימת שרתים
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # השהיה 5 דקות
              Start-Sleep -Seconds $DelaySeconds

              # הודעה
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

