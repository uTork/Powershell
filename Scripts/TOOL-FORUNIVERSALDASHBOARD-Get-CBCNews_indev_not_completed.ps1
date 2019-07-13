Function Get-CBCNews {

<#
.SYNOPSIS
Show CBC News
.DESCRIPTION
Description | La fonction a été créée pour afficher les nouvelles dans des objets powershell. Elles peuvent être récupérées par Universal Dashboard par exemple pour afficher les nouvelles sur un Dashboard sur des téléviseurs par exemple.
.PARAMETER Information
Affiche les informations selon la sélection
.PARAMETER Thematiques
Affiche les Thematiques selon la sélection
.PARAMETER Sports
Affiche les Sports selon la sélection
.PARAMETER Arts
Affiche les Arts selon la sélection
.PARAMETER Regions
Affiche les Regions selon la sélection
.PARAMETER Autres
Affiche la catégorie Autres selon la sélection
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
         [switch]$HTML
      )




$GENERALNEWS = @{
                    Top_Stories	= "https://rss.cbc.ca/lineup/topstories.xml"
                    World = "https://rss.cbc.ca/lineup/world.xml"
                    Canada = "https://rss.cbc.ca/lineup/canada.xml"
                    Politics = "https://rss.cbc.ca/lineup/politics.xml"
                    Business = "https://rss.cbc.ca/lineup/business.xml"
                    Health = "https://rss.cbc.ca/lineup/health.xml"
                    "Arts_and_Entertainment" = "https://rss.cbc.ca/lineup/arts.xml"
                    "Technology_and_Science" = "https://rss.cbc.ca/lineup/technology.xml"
                    Offbeat = "https://rss.cbc.ca/lineup/offbeat.xml"
                    Indigenous = "https://www.cbc.ca/cmlink/rss-cbcaboriginal"
}

if($GENERAL_NEWS -eq $true){
                            $RSS = $GENERALNEWS."$GENERAL_NEWS"
                            }                  



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

if($SPORTS_NEWS -eq $true){
                            $RSS = $SPORTSNEWS."$GENERAL_NEWS"
                            }        
                    

$REGIONAL_NEWS = @{

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


if($REGIONAL_NEWS -eq $true){
                        
                        $RSS = $REGIONALNEWS."$REGIONAL_NEWS"

                            }

$THENATIONAL = @{
                    In_Depth_Reports = "https://rss.cbc.ca/lineup/thenational.xml"
                 }

if($THE_NATIONAL -eq $true){

                            $RSS = $THENATIONAL."$THE_NATIONAL"

}

$RSS

}
