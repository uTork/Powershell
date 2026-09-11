Function Get-CBCNews {

<#
.SYNOPSIS
Mostrar noticias de CBC
.DESCRIPTION
Transformar el feed RSS de CBC en objeto o HTML
.PARAMETER GENERAL_NEWS
Mostrar noticias generales
.PARAMETER SPORTS_NEWS
Mostrar noticias deportivas
.PARAMETER REGIONAL_NEWS
Mostrar noticias regionales
.PARAMETER HTML
Muestra las noticias en un resumen HTML que se abre en el navegador.
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>

Param(   
         
         [ValidateSet('Top_Stories','World','Canada','Politics''Business','Health','Arts_and_Entertainment','Technology_and_Science','Offbeat',"Indigenous")][string]$GENERAL_NEWS,
         [ValidateSet('Sports','MLB','NBA','Curling','CFL','NFL','NHL','Soccer','Figure_Skating')][string]$SPORTS_NEWS,
         [ValidateSet("British_Columbia","Kamloops","Calgary",'Edmonton','Saskatchewan','Saskatoon','Manitoba','Thunder_Bay',"Sudbury",'Windsor',"London","Kitchener_Waterloo","Toronto","Hamilton","Montreal","New_Brunswick",'Prince_Edward_Island','Nova_Scotia','Newfoundland_and_Labrador',"North")][string]$REGIONAL_NEWS,
         [ValidateSet('In_Depth_Reports')][string]$THE_NATIONAL,
         [switch]$HTML,
         [switch]$isPowershell
      )

# Mostrar objetos de noticias
$wiki = "https://github.com/uTork/Powershell/wiki/Function:-Get-CBCNews"          
if($ispowershell -eq $true){Start-Process $wiki;break}



# Dirección RSS de noticias generales
$GENERALNEWS = @{
                    Top_Stories	= "https://rss.cbc.ca/lineup/topstories.xml"
                    World = "https://rss.cbc.ca/lineup/world.xml"
                    Canada = "https://rss.cbc.ca/lineup/canada.xml"
                    Politics = "https://rss.cbc.ca/lineup/politics.xml"
                    Business = "https://rss.cbc.ca/lineup/business.xml"
                    Health = "https://rss.cbc.ca/lineup/health.xml"
                    Arts_and_Entertainment = "https://rss.cbc.ca/lineup/arts.xml"
                    Technology_and_Science = "https://rss.cbc.ca/lineup/technology.xml"
                    Offbeat = "https://rss.cbc.ca/lineup/offbeat.xml"
                    Indigenous = "https://www.cbc.ca/cmlink/rss-cbcaboriginal"
                 }

# Dirección RSS de noticias deportivas
$SPORTSNEWS = @{

                    Sports = "https://rss.cbc.ca/lineup/sports.xml"
                    MLB = "https://rss.cbc.ca/lineup/sports-mlb.xml"
                    NBA	= "https://rss.cbc.ca/lineup/sports-nba.xml"
                    Curling	= "https://rss.cbc.ca/lineup/sports-curling.xml"
                    CFL	= "https://rss.cbc.ca/lineup/sports-cfl.xml"
                    NFL	= "https://rss.cbc.ca/lineup/sports-nfl.xml"
                    NHL	= "https://rss.cbc.ca/lineup/sports-nhl.xml"
                    Soccer = "https://rss.cbc.ca/lineup/sports-soccer.xml"
                    Figure_Skating = "https://rss.cbc.ca/lineup/sports-figureskating.xml"

                }                  

# Dirección RSS de noticias regionales
$REGIONALNEWS = @{

                    British_Columbia = "https://rss.cbc.ca/lineup/canada-britishcolumbia.xml"
                    Kamloops = "https://rss.cbc.ca/lineup/canada-kamloops.xml"
                    Calgary	= "https://rss.cbc.ca/lineup/canada-calgary.xml"
                    Edmonton = "https://rss.cbc.ca/lineup/canada-edmonton.xml"
                    Saskatchewan = "https://rss.cbc.ca/lineup/canada-saskatchewan.xml"
                    Saskatoon = "https://rss.cbc.ca/lineup/canada-saskatoon.xml"
                    Manitoba = "https://rss.cbc.ca/lineup/canada-manitoba.xml"
                    Thunder_Bay	= "https://rss.cbc.ca/lineup/canada-thunderbay.xml"
                    Sudbury	= "https://rss.cbc.ca/lineup/canada-sudbury.xml"
                    Windsor	= "https://rss.cbc.ca/lineup/canada-windsor.xml"
                    London = "https://www.cbc.ca/cmlink/rss-canada-london"
                    Kitchener_Waterloo = "https://rss.cbc.ca/lineup/canada-kitchenerwaterloo.xml"
                    Toronto	= "https://rss.cbc.ca/lineup/canada-toronto.xml"
                    Hamilton = "https://rss.cbc.ca/lineup/canada-hamiltonnews.xml"
                    Montreal = "http://rss.cbc.ca/lineup/canada-montreal.xml"
                    New_Brunswick = "https://rss.cbc.ca/lineup/canada-newbrunswick.xml"
                    Prince_Edward_Island = "https://rss.cbc.ca/lineup/canada-pei.xml"
                    Nova_Scotia = "https://rss.cbc.ca/lineup/canada-novascotia.xml"
                    Newfoundland_and_Labrador = "https://rss.cbc.ca/lineup/canada-newfoundland.xml"
                    North = "https://rss.cbc.ca/lineup/canada-north.xml"

                    }

# Dirección RSS de The National
$THENATIONAL = @{
                    In_Depth_Reports = "https://rss.cbc.ca/lineup/thenational.xml"
                 }

# Seleccionar el feed RSS de noticias generales
if($GENERAL_NEWS -NE ""){
                         $RSS = $GENERALNEWS."$GENERAL_NEWS"                          
                        }

# Seleccionar el feed RSS de noticias regionales
if($REGIONAL_NEWS -ne ""){                       
                         $RSS = $REGIONALNEWS."$REGIONAL_NEWS"
                         }

# Seleccionar el feed RSS de The National
if($THE_NATIONAL -ne ""){
                        $RSS = $THENATIONAL."$THE_NATIONAL"
                        }



# Consultar el servidor del feed CBC News
$RSS_Query = Invoke-RestMethod -Uri "https://rss.cbc.ca/lineup/canada-thunderbay.xml" -UseBasicParsing

# Crear matriz de noticias desde RSS_Query
[array]$news = @( 

                     $RSS_Query | foreach{

                     $title = $_.title | select-object -ExpandProperty "#cdata-section"
                     #[string]$title = $title | select-object -ExpandProperty "#cdata-section"
                     $link = $_.link
                     $description = $_.description | select-object -ExpandProperty "#cdata-section"
                     $description = [regex]::matches($description , '<p>(.*?)</p>')
                     $description = $description -replace "<p>",""
                     [string]$description = $description -replace "</p>",""

                     [pscustomobject]@{

                                        Title = $title
                                        News = $description
                                        Link = $link

                                       }
                                       }
                )


# Mostrar objetos de noticias
if($html -ne $true){$news}

# Crear página HTML
if($html -eq $true){
# Imagen de encabezado HTML
$image_cbc = "https://i.ibb.co/SsVKmNj/505372227553.jpg"

$html_page = "<html>"
$html_page += '<Head><img src="' + $image_cbc + '" alt="' + $image_cbc + '" style="width:170px;height:100px;"></head>'
$html_page += "<body>"
$html_page += "</br>"
$html_page += "<hr>"

$news | foreach{

$title = $_.title
$news = $_.News
$link = $_.link

$html_page += '<table style="width:100%">'
$html_page += "<tr><td><b>Title: </b>$title</td></tr>"
$html_page += "<tr><td><b>News: </b>$news</td></tr>"
$html_page += '<tr><td><b>Link: </b><a href="' + $link + '">CBC</a></td></tr>'
$html_page += "</table>"
$html_page += "<hr>"
$html_page += "</br>"

}

$html_page += "</body>"
$html_page += "</html>"

$html_page_file = $env:temp + "\cbc_news.html"

$html_page | Set-Content -Path $html_page_file

Start-Process -FilePath $html_page_file

}
}
