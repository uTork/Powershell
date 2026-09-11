function Get-NasaPicture {
<#
.SYNOPSIS
NASA 今日の画像 / インターネットが必要
.DESCRIPTION
NASA の今日の画像を HTML ページで開く。URL を抽出。画像をフォルダーに保存
.PARAMETER HTML
画像を HTML ブラウザーで開きます。
.PARAMETER IMAGEURL
画像の URL を表示
.PARAMETER SAVEPATH
画像をフォルダーに保存します。
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>
PARAM(
      [switch]$HTML,
      [switch]$IMAGE_URL,
      [string]$SAVEPATH
      )

# NASA サイトで無料の個人 API キーを取得 https://api.nasa.gov/index.html#apply-for-an-api-key
$Nasa_API_KEY = "DEMO_KEY"

$nasa = "https://api.nasa.gov/planetary/apod?api_key=$Nasa_API_KEY"
$NasaQuery = Invoke-RestMethod -Uri $nasa
$hdurl = $NasaQuery.hdurl
$title = $NasaQuery.title
$author = $NasaQuery.copyright
$DateTaken = $NasaQuery.date
$explanation = $NasaQuery.explanation

# 今日の画像オブジェクトを出力
if($savepath -eq "" -and $IMAGE_URL -ne $true -and $html -ne $true){$NasaQuery}

# 画像をハードドライブ上のファイルに保存
if($SAVEPATH -ne ""){

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$filename = Split-Path -Path $hdurl -Leaf
$savehd = $SAVEPATH + "\$filename"
Invoke-WebRequest -Uri $hdurl -OutFile $savehd

}

# 画像の HD URL のみを出力
if($image_url -eq $true){Write-Output $hdurl}

# 画像付きの HTML ページを作成
if($html -eq $true){
$altimage = "Title: $Title Author: $author Date: $DateTaken"
$nasalogo = "https://api.nasa.gov/images/logo.png"

$html_page = "<html>"
$html_page += "<Head></head>"
$html_page += "<body>"
$html_page += '<table style="width:34%">'
$html_page += '<tr><th><img src="' + $nasalogo + '" alt="NASA Logo" style="width:65px;height:60px;"></th></tr>'
$html_page += '<tr><td align="center"><b>Title: </b>' +  $title + '</td></tr>'
$html_page += '<tr><td><b>HD URL: </b><a href="' + $hdurl + '">' + $hdurl + '</a></td></tr>'
$html_page += '<tr><td><img src="' + $hdurl + '" alt="' + $altimage + '" style="width:500px;height:600px;"></td></tr>'
$html_page += "<tr><td><b>Explanation: </b> $explanation</td></tr>"
$html_page += "<tr><td><b>Date: </b> $DateTaken</td></tr>"
$html_page += "</table>"
$html_page += "</body>"
$html_page += "</html>"


$html_page_file = $env:temp + "\nasa_picture_of_the_day.html"

$html_page | Set-Content -Path $html_page_file

Start-Process -FilePath $html_page_file
}
}
