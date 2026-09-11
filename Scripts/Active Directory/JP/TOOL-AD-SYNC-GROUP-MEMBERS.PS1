function Sync-ADGroupMembers {
<#
.SYNOPSIS

このスクリプトは、domain users グループのメンバーを別の Active Directory グループに同期するために作成されました。
この関数は 15 分ごとに実行されるスケジュール済みタスクで使用されます。たとえばユーザーが
"domain users" グループに追加されると、スケジュール済みタスクの実行時に同期されます。

.DESCRIPTION
ソースグループのメンバーを宛先グループに同期します。ソースグループの第1レベルメンバーのみ。
.PARAMETER SOURCE
Active Directory ソースグループ
.PARAMETER DESTINATION
Active Directory 宛先グループ
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

# ソースメンバーを変数に抽出
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# 比較用に宛先メンバーを抽出
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # グループを比較してユーザー差分を取得
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # ユーザー差分を宛先に追加
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # すべてのソースユーザーを宛先グループに追加
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
