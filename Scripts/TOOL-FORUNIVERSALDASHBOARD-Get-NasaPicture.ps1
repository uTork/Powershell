function Get-NasaPicture {
<#
.SYNOPSIS
Nasa Picture of the DAY / Need internet to work
.DESCRIPTION
Open the nasa picture of day on html page. Extract url. Save the image to folder
.PARAMETER HTML
Open the image in the HTML browser.
.PARAMETER IMAGEURL
Show the image url
.PARAMETER SAVEPATH
Save the image to folder.
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>
PARAM(
      [switch]$HTML,
      [switch]$IMAGE_URL,
      [string]$SAVEPATH
      )

# get your personnal free api key on nasa website https://api.nasa.gov/index.html#apply-for-an-api-key
$Nasa_API_KEY = "DEMO_KEY"

$nasa = "https://api.nasa.gov/planetary/apod?api_key=$Nasa_API_KEY"
$NasaQuery = Invoke-RestMethod -Uri $nasa
$hdurl = $NasaQuery.hdurl
$title = $NasaQuery.title
$author = $NasaQuery.copyright
$DateTaken = $NasaQuery.date
$explanation = $NasaQuery.explanation

# Output the object pciture of the day
if($savepath -eq "" -and $IMAGE_URL -ne $true -and $html -ne $true){$NasaQuery}

# Save imgage to file on the hardrive
if($SAVEPATH -ne ""){

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$filename = Split-Path -Path $hdurl -Leaf
$savehd = $SAVEPATH + "\$filename"
Invoke-WebRequest -Uri $hdurl -OutFile $savehd

}

# Output only the hd url of the image
if($image_url -eq $true){Write-Output $hdurl}

# Create an HTML page with the image
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
