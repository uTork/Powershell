function Reboot-Computer {
<#
.SYNOPSIS
تُستخدم هذه الدالة لإعادة تشغيل كمبيوتر بعيد أو قائمة أجهزة في ملف CSV أو جزء من الأجهزة (-LIKE).
يجب أن تكون لديك حقوق المسؤول على الأجهزة البعيدة لإعادة تشغيلها.
.DESCRIPTION
إعادة تشغيل كمبيوتر بعيد
.PARAMETER RemoteComputer
اسم الكمبيوتر البعيد
.PARAMETER CSV
مسار ملف CSV. اسم كمبيوتر واحد في كل سطر.
.PARAMETER LIKE
كلمة موجودة في اسم الخوادم في Active Directory. ستتم إعادة تشغيل جميع الأجهزة التي تحتوي على هذه الكلمة في اسمها.
.PARAMETER DelaySeconds
التأخير بالثواني بين إعادة تشغيل الأجهزة.
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
    #إعادة تشغيل خادم الكمبيوتر
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# التحقق من وجود الثواني

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# استيراد CSV
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# إعادة تشغيل قائمة الأجهزة
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # إيقاف مؤقت 5 دقائق
              Start-Sleep -Seconds $DelaySeconds
              # رسالة
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
} #نهاية إذا كانت الوحدة متاحة ثم الاستيراد
else { $false } #الوحدة غير متاحة
} # نهاية إذا لم تكن هناك وحدة
else { $true } #الوحدة محمّلة بالفعل
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# قائمة أجهزة Active Directory
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# إعادة تشغيل قائمة الخوادم
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # إيقاف مؤقت 5 دقائق
              Start-Sleep -Seconds $DelaySeconds

              # رسالة
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

