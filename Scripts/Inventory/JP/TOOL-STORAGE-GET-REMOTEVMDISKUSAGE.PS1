function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
この関数はリモートコンピューターの使用容量を分析するために作成されました。各ディスクと合計使用容量を計算します。

.DESCRIPTION
リモートコンピューターのディスクをスキャン
.PARAMETER COMPUTER
スキャンするコンピューター名
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

# 分析するリモートコンピューターを選択
if($computer -eq ""){$computer = "localhost"}

# ハードドライブ一覧の作成
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# 変数をゼロに設定します。
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# ハードドライブのメタデータ抽出
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# 合計に加算する変数
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# ディスク容量の計算
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# ディスク使用容量
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# 割り当てられた合計容量
[string]$size = [Math]::Round($size /1gb)

# 合計空き容量
[string]$free = [Math]::Round($free /1gb)

# Powershell オブジェクトの作成と表示
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
