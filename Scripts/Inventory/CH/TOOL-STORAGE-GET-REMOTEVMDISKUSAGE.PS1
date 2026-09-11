function Get-RemoteVMDiskUsage{
<#
.SYNOPSIS
此函数用于分析远程计算机的已用空间。它计算每个磁盘以及已用空间总量。

.DESCRIPTION
扫描远程计算机上的磁盘
.PARAMETER COMPUTER
要扫描的计算机名称
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

# 选择要分析的远程计算机
if($computer -eq ""){$computer = "localhost"}

# 创建硬盘列表
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-object {$_.DriveType -eq "3"}).deviceid

# 将变量设为零。
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

# 提取硬盘元数据
$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $computer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

# 要加到总计的变量
[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace

# 磁盘空间计算
[long]$size = $size + $add_size
[long]$free = $free + $add_free

}

# 磁盘已用空间
[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

# 已分配的总空间
[string]$size = [Math]::Round($size /1gb)

# 总空闲空间
[string]$free = [Math]::Round($free /1gb)

# 创建并显示 Powershell 对象
[pscustomobject]@{

                  "Computer" = $computer
                  "Provisionned(GB)" = $size
                  "Used(GB)" = $used
                  "Free(GB)" =  $free
                 }

}
