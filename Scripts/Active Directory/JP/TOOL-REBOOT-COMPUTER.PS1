function Reboot-Computer {
<#
.SYNOPSIS
この関数は、リモートコンピューター、CSV ファイル内のコンピューターリスト、またはコンピューターの一部（-LIKE）を再起動するために使用されます。
再起動するにはリモートコンピューターの管理者権限が必要です。
.DESCRIPTION
リモートコンピューターを再起動
.PARAMETER RemoteComputer
リモートコンピューターの名前
.PARAMETER CSV
CSV ファイルパス。１行に１つのコンピューター名。
.PARAMETER LIKE
Active Directory のサーバー名に含まれる単語。この単語を名前に含むすべてのコンピューターが再起動されます。
.PARAMETER DelaySeconds
コンピューター再起動間の秒単位の遅延。
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
    #コンピューターサーバーを再起動
    shutdown /r /f /m \\$RemoteComputer /t 1
    $message = "The computer $RemoteComputer is restarting"
    Write-Host $message
}

# 秒が存在するかの検証

if($DelaySeconds -eq ""){$DelaySeconds = 1}




if($CSV -ne ""){

# CSV インポート
$cp = try{@(get-content -path $CSV -ErrorAction stop)}catch{$message = "Path not found";Write-Host $message;break}

# コンピューターリストを再起動
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1
              # 5 分の一時停止
              Start-Sleep -Seconds $DelaySeconds
              # メッセージ
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
} #モジュールが利用可能な場合インポートして終了
else { $false } #モジュール利用不可
} # モジュールがない場合の終了
else { $true } #モジュールは既に読み込み済み
} 
$message1 = "Install the ActiveDirectory module............."
$ad = get-mymodule -name "ActiveDirectory"
if($ad -eq $false){clear;write-output $message1;break}


# Active Directory コンピューターリスト
$cp = (get-adcomputer -filter * -Properties * | where-object {$_.name -like $like}).name

# サーバーリストを再起動
$cp | foreach{
              $name = $_
              shutdown /r /f /m \\$name /t 1

              # 5 分の一時停止
              Start-Sleep -Seconds $DelaySeconds

              # メッセージ
              $message = "$name --OK"
              Write-Host $message
              
              }
}
}

