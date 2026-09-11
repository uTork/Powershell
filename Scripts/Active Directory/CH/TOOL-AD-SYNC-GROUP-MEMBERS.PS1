function Sync-ADGroupMembers {
<#
.SYNOPSIS

此脚本用于将 domain users 组的成员同步到另一个 Active Directory 组。
该函数用于每 15 分钟运行一次的计划任务。例如，当用户被添加到
"domain users" 组时，计划任务执行时会同步该用户。

.DESCRIPTION
将源组成员同步到目标组。仅同步源组的第一级成员。
.PARAMETER SOURCE
Active Directory 源组
.PARAMETER DESTINATION
Active Directory 目标组
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$SOURCE,
      [string]$DESTINATION
      )

# 将源成员提取到变量
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# 提取目标成员以进行比较
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # 比较组并获取用户差异
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # 将用户差异添加到目标
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # 将所有源用户添加到目标组
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
