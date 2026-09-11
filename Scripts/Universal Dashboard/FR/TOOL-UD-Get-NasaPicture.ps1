function Get-NasaPicture {
<#
.SYNOPSIS
Image NASA du jour / Nécessite Internet
.DESCRIPTION
Ouvrir l'image NASA du jour sur une page HTML. Extraire l'URL. Enregistrer l'image dans un dossier
.PARAMETER HTML
Ouvrir l'image dans le navigateur HTML.
.PARAMETER IMAGEURL
Afficher l'URL de l'image
.PARAMETER SAVEPATH
Enregistrer l'image dans un dossier.
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

# Obtenez votre clé API gratuite sur le site NASA https://api.nasa.gov/index.html#apply-for-an-api-key
$Nasa_API_KEY = "DEMO_KEY"

$nasa = "https://api.nasa.gov/planetary/apod?api_key=$Nasa_API_KEY"
$NasaQuery = Invoke-RestMethod -Uri $nasa
$hdurl = $NasaQuery.hdurl
$title = $NasaQuery.title
$author = $NasaQuery.copyright
$DateTaken = $NasaQuery.date
$explanation = $NasaQuery.explanation

# Afficher l'objet de l'image du jour
if($savepath -eq "" -and $IMAGE_URL -ne $true -and $html -ne $true){$NasaQuery}

# Enregistrer l'image dans un fichier sur le disque dur
if($SAVEPATH -ne ""){

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$filename = Split-Path -Path $hdurl -Leaf
$savehd = $SAVEPATH + "\$filename"
Invoke-WebRequest -Uri $hdurl -OutFile $savehd

}

# Afficher uniquement l'URL HD de l'image
if($image_url -eq $true){Write-Output $hdurl}

# Créer une page HTML avec l'image
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
