function Get-NameList{
<#
.SYNOPSIS

この関数は Active Directory テスト環境の作成のために作られました。数百万のユーザー、または単に百人程度を作成できます。
名前は名前サイト http://names.mongabay.com から取得します。

.DESCRIPTION
名前リストジェネレーター

.PARAMETER NUMBER
作成したいユーザーの数

.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param(
      [string]$Number
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
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# 姓のリンク
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# 男性名のリンク
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# 女性名のリンク
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# ImportExcel モジュールの Get-HtmlTable コマンドによる HTML テーブル抽出
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# ユーザー数を 2 で割る。男女同数を作成するため
$number_divide = $number /2

# 名前リストの作成
$name_list = @(
                1..$Number | foreach{
                    $surname = Get-Random $surname_list
                    $male = get-random $male_list
                    $female = get-random $female_list

                    if($_ -lt $number_divide){$name = $male}else{$name = $female}
                    
                    [pscustomobject]@{
                                      "Name" = $name
                                      "Surname" = $surname
                                     }

                    }
                )
# PowerShell オブジェクトを表示
$name_list
}
