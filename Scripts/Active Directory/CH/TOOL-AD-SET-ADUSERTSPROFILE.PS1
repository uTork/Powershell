function Set-ADuserTsprofile {
<#
.SYNOPSIS

此函数可将 Active Directory 组成员用户的终端服务器配置文件路径进行更改。
此函数将用于每 15 分钟运行一次的计划任务。

.DESCRIPTION
配置 AD 用户终端服务器配置文件路径
.PARAMETER ADGroup
包含要配置成员的 Active Directory 源组
.PARAMETER TSProfilePath
TS 配置文件的 UNC 路径。例如: "\\server\share$\%username%"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$ADGroup,
      [string]$TSProfilePath
      )

# ImportExcel 模块安装验证
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


# 提取 Active Directory 组成员
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# 设置 AD 用户配置文件
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
