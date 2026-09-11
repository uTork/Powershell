function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
أُنشئت هذه الدالة لتحليل المساحة المستخدمة على كمبيوتر بعيد. تحسب كل قرص وإجمالي المساحة المستخدمة.

.DESCRIPTION
فحص الأقراص على كمبيوتر بعيد
.PARAMETER COMPUTER
اسم الكمبيوتر المراد فحصه
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

# تحديد الكمبيوتر البعيد المراد تحليله
if($computer -eq ""){$computer = "localhost"}

# إنشاء قائمة الأقراص الصلبة
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# تعيين المتغيرات إلى صفر.
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# استخراج بيانات تعريف القرص الصلب
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# المتغير المراد إضافته إلى الإجمالي
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# حساب مساحة القرص
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# المساحة المستخدمة على القرص
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# إجمالي المساحة المخصصة
[string]$size = [Math]::Round($size /1gb)

# إجمالي المساحة الحرة
[string]$free = [Math]::Round($free /1gb)

# إنشاء وعرض كائن Powershell
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
