function Get-NasaPicture {
<#
.SYNOPSIS
Imagen NASA del día / Requiere Internet
.DESCRIPTION
Abrir la imagen NASA del día en una página HTML. Extraer la URL. Guardar la imagen en una carpeta
.PARAMETER HTML
Abrir la imagen en el navegador HTML.
.PARAMETER IMAGEURL
Mostrar la URL de la imagen
.PARAMETER SAVEPATH
Guardar la imagen en una carpeta.
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

# Obtenga su clave API gratuita en el sitio de la NASA https://api.nasa.gov/index.html#apply-for-an-api-key
$Nasa_API_KEY = "DEMO_KEY"

$nasa = "https://api.nasa.gov/planetary/apod?api_key=$Nasa_API_KEY"
$NasaQuery = Invoke-RestMethod -Uri $nasa
$hdurl = $NasaQuery.hdurl
$title = $NasaQuery.title
$author = $NasaQuery.copyright
$DateTaken = $NasaQuery.date
$explanation = $NasaQuery.explanation

# Mostrar el objeto de la imagen del día
if($savepath -eq "" -and $IMAGE_URL -ne $true -and $html -ne $true){$NasaQuery}

# Guardar la imagen en un archivo en el disco duro
if($SAVEPATH -ne ""){

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$filename = Split-Path -Path $hdurl -Leaf
$savehd = $SAVEPATH + "\$filename"
Invoke-WebRequest -Uri $hdurl -OutFile $savehd

}

# Mostrar solo la URL HD de la imagen
if($image_url -eq $true){Write-Output $hdurl}

# Crear una página HTML con la imagen
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
