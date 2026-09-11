function Set-ADuserTsprofile {
<#
.SYNOPSIS

この関数は、Active Directory グループのメンバーであるユーザーのターミナルサーバープロファイルのパスを変更できます。
この関数は 15 分ごとに実行されるスケジュール済みタスクで使用されます。

.DESCRIPTION
AD ユーザーのターミナルサーバープロファイルのパスを構成
.PARAMETER ADGroup
構成するメンバーを含む Active Directory ソースグループ
.PARAMETER TSProfilePath
TS プロファイルの UNC パス。例: "\\server\share$\%username%"
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

# ImportExcel モジュールのインストール検証
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #モジュールが利用可能な場合インポートして終了
else { $false } #モジュール利用不可
} # モジュールがない場合の終了
else { $true } #モジュールは既に読み込み済み
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Active Directory グループメンバーの抽出
$goupmember = get-adgroup -Identity $ADGroup | Get-ADGroupMember | where-object {$_.objectClass -eq "user"}


# AD ユーザープロファイルを設定
Foreach ($user in $goupmember) {
                                $AD = get-aduser $user.samaccountname | select -ExpandProperty disting*
                                $ADUser = [ADSI]"LDAP://$AD"
                                $ADUser.psbase.InvokeSet("terminalservicesprofilepath",$TSProfilePath)
                                $ADuser.setinfo()
                                }
                                }
