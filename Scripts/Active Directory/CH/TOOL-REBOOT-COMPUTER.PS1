function Reboot-Computer {
<#
.SYNOPSIS
此函数用于重启远程计算机、CSV 文件中的计算机列表或一部分计算机（-LIKE）。
您必须在远程计算机上拥有管理员权限才能重启它们。
.DESCRIPTION
重启远程计算机
.PARAMETER RemoteComputer
远程计算机的名称
.PARAMETER CSV
CSV 文件路径。每行一个计算机名。
.PARAMETER LIKE
Active Directory 中服务器名称包含的单词。名称中包含此单词的所有计算机都将被重启。
.PARAMETER DelaySeconds
计算机重启之间的秒数延迟。
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
    #重启计算机服务器
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# 验证秒数是否存在

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# CSV 导入
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# 重启计算机列表
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # 暂停 5 分钟
              Start-Sleep -Seconds $DelaySeconds
              # 消息
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
} #如果模块可用则导入后结束
else { $false } #模块不可用
} # 无模块时结束
else { $true } #模块已加载
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Active Directory 计算机列表
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# 重启服务器列表
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # 暂停 5 分钟
              Start-Sleep -Seconds $DelaySeconds

              # 消息
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

