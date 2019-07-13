Function Get-CBCNews {

<#
.SYNOPSIS
Show CBC News
.DESCRIPTION
Transform the RSS NEWS FEED from CBC into object or html
.PARAMETER $GENERAL_NEWS
Show general news
.PARAMETER SPORTS_NEWS
Show sport news
.PARAMETER REGIONAL_NEWS
Show Regional News
.PARAMETER HTML
Affiche les nouvelles sur un résumer en HTML qui s'ouvre dans le navigateur.
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

# Show news objects
$wiki = "https://github.com/uTork/Powershell/wiki/Function:-Get-CBCNews"          
if($ispowershell -eq $true){Start-Process $wiki;break}



# General News RSS address
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

# Sport News RSS Address           
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

# Regional News RSS Address
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

# The Nationnal News RSS address
$THENATIONAL = @{
                    In_Depth_Reports = "https://rss.cbc.ca/lineup/thenational.xml"
                 }

# Select General RSS news FEED
if($GENERAL_NEWS -NE ""){
                         $RSS = $GENERALNEWS."$GENERAL_NEWS"                          
                        }

# Select Regional RSS news FEED
if($REGIONAL_NEWS -ne ""){                       
                         $RSS = $REGIONALNEWS."$REGIONAL_NEWS"
                         }

# Select Nationnal RSS news FEED
if($THE_NATIONAL -ne ""){
                        $RSS = $THENATIONAL."$THE_NATIONAL"
                        }



# Query CBC News FEED server
$RSS_Query = Invoke-RestMethod -Uri "https://rss.cbc.ca/lineup/canada-thunderbay.xml" -UseBasicParsing

# Create News Array from RSS_Query
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


# Show news objects            
if($html -ne $true){$news}

# Create HTML Page
if($html -eq $true){
# HTML header image
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
