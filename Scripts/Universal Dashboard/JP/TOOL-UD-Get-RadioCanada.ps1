Function Get-RadioCanada {

<#
.SYNOPSIS
Radio-Canada のニュースを表示
.DESCRIPTION
この関数はニュースを PowerShell オブジェクトとして表示するために作成されました。Universal Dashboard で取得し、テレビ上のダッシュボードに表示できます。
.PARAMETER Information
選択に応じて情報を表示
.PARAMETER Thematiques
選択に応じてテーマを表示
.PARAMETER Sports
選択に応じてスポーツを表示
.PARAMETER Arts
選択に応じてアートを表示
.PARAMETER Regions
選択に応じて地域を表示
.PARAMETER Autres
選択に応じて「その他」カテゴリを表示
.PARAMETER HTML
ブラウザーで開く HTML 要約でニュースを表示します。
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>

Param(   
         
         [ValidateSet('Grands Titres','En Continue')][string]$Information,
         [ValidateSet('Alimentation','Art de Vivre','Economie','Environnement','International','Justice et faits divers','Politique','Sante','Science','Techno')][string]$Thematiques,
         [ValidateSet('Grands Titres','Football','Hockey','Olympique','Podium','Soccer','Tennis')][string]$Sports,
         [ValidateSet('Celebrites','Cinema','Grands Titres','Humour','Livres','Musique','Tele')][string]$Arts,
         [ValidateSet('Abitibi-Témiscamingue','Alberta','Bas-Saint-Laurent','Colombie-Britannique','Cote-Nord','Estrie','Gaspesie iles de la Madeleine','Grand Montreal','Grand Nord','ile-du-Prince-Edouard','Manitoba','Mauricie-Centre-du-Quebec','Nord Ontario','Nouveau-Brunswick','Nouvelle-Écosse','Ottawa-Gatineau','Quebec','Saskatchewan','Terre-Neuve et Labrador','Toronto','Windsor')][string]$Regions,                  
         [ValidateSet('Archives','Dossiers','Espaces Autochtones','RCINET')][string]$Autres,
         [switch]$HTML,
         [switch]$isPowershell
      )

# wiki ispowershell
if($isPowershell -eq $true){
                            $wiki = "https://github.com/uTork/Powershell/wiki/Function-%7C-Get-RadioCanada"
                            Start-Process $wiki
                            break
                            }

# 情報
$informations_list = [pscustomobject]@{
                                        'Grands Titres' = "https://ici.radio-canada.ca/rss/4159"
                                        'En Continue' = "https://ici.radio-canada.ca/rss/1000524"
                                       }

# テーマ
$Thematiques_list = [pscustomobject]@{
                                        "Alimentation" = "https://ici.radio-canada.ca/rss/7239"
                                        "Art de Vivre" = "https://ici.radio-canada.ca/rss/4163"
                                        "Economie" = "https://ici.radio-canada.ca/rss/5717"
                                        "Environnement" = "https://ici.radio-canada.ca/rss/92408"
                                        "International" = "https://ici.radio-canada.ca/rss/96"
                                        'Justice et faits divers' = "https://ici.radio-canada.ca/rss/92411"
                                        "Politique" = "https://ici.radio-canada.ca/rss/4175"
                                        "Sante" = "https://ici.radio-canada.ca/rss/4175"
                                        "Science" = "https://ici.radio-canada.ca/rss/4165"
                                        "Techno" = "https://ici.radio-canada.ca/rss/4169"
                                      }

# スポーツ RSS フィード一覧
$Sports_list = [pscustomobject]@{

                                "Football" = "https://ici.radio-canada.ca/rss/1000057"
                                "Grands Titres" = "https://ici.radio-canada.ca/rss/771"
                                "hockey" = "https://ici.radio-canada.ca/rss/1000056"
                                "Olympique" = "https://ici.radio-canada.ca/rss/64852"
                                "Podium" = "https://ici.radio-canada.ca/rss/555082"
                                "Soccer" = "https://ici.radio-canada.ca/rss/1000058"
                                "Tennis" = "https://ici.radio-canada.ca/rss/1000059"
                                }

# アート一覧
$Arts_list = [pscustomobject]@{
                                Celebrites = "https://ici.radio-canada.ca/rss/1000232"
                                Cinema = "https://ici.radio-canada.ca/rss/1000229"
                                "Grands Titres" = "https://ici.radio-canada.ca/rss/4167"
                                Humour = "https://ici.radio-canada.ca/rss/1000231"
                                Livres = "https://ici.radio-canada.ca/rss/1000083"
                                Musique = "https://ici.radio-canada.ca/rss/1000230"
                                Tele = "https://ici.radio-canada.ca/rss/1000233"
                                }

# 地域一覧
$regions_list = [pscustomobject]@{
                                    'Abitibi-Témiscamingue' = "https://ici.radio-canada.ca/rss/5763"
                                    Alberta = "https://ici.radio-canada.ca/rss/5767"
                                    'Bas-Saint-Laurent' = "https://ici.radio-canada.ca/rss/35004"
                                    'Colombie-Britannique' = "https://ici.radio-canada.ca/rss/5769"
                                    'Cote-Nord' = "https://ici.radio-canada.ca/rss/35019"
                                    Estrie = "https://ici.radio-canada.ca/rss/5773"
                                    'Gaspesie iles de la Madeleine' = "https://ici.radio-canada.ca/rss/35015"
                                    'Grand Montreal' = "https://ici.radio-canada.ca/rss/4201"
                                    'Grand Nord' = "https://ici.radio-canada.ca/rss/1001049"
                                    'ile-du-Prince-Edouard' = "https://ici.radio-canada.ca/rss/1000814"
                                     Manitoba = "https://ici.radio-canada.ca/rss/5775"
                                    'Mauricie-Centre-du-Quebec' = "https://ici.radio-canada.ca/rss/5777"
                                    "Nord Ontario" = "https://ici.radio-canada.ca/rss/36518"
                                    "Nouveau-Brunswick" = "https://ici.radio-canada.ca/rss/5765"
                                    "Nouvelle-Écosse" = "https://ici.radio-canada.ca/rss/1000813"
                                    "Ottawa-Gatineau" = "https://ici.radio-canada.ca/rss/6102"
                                     Quebec = "https://ici.radio-canada.ca/rss/6104"
                                    "Saguenay Lac-St-Jean" = "https://ici.radio-canada.ca/rss/6106"
                                    Saskatchewan = "https://ici.radio-canada.ca/rss/6108"
                                    'Terre-Neuve et Labrador' = "https://ici.radio-canada.ca/rss/1000815"
                                    Toronto = "https://ici.radio-canada.ca/rss/5779"
                                    Windsor = "https://ici.radio-canada.ca/rss/475289"
                                  }


# その他の RSS フィード一覧
$autres_list = [pscustomobject]@{
                                Archives = "https://ici.radio-canada.ca/rss/1000548"
                                Dossiers = "https://ici.radio-canada.ca/rss/6735"
                                "Espaces Autochtones" = "https://ici.radio-canada.ca/rss/116435"
                                RCINET = "http://www.rcinet.ca/fr/feed/rss/"
                                }
           
# 情報の選択
if($Information -ne ""){$RSS = $informations_list | select-object -ExpandProperty $Information }
# スポーツの選択
if($Sports -ne ""){$RSS = $Sports_list | select-object -ExpandProperty $Sports}
# テーマの選択
if($Thematiques -ne ""){$RSS = $Thematiques_list | select-object -ExpandProperty $Thematiques}
# アートの選択
if($Arts -ne ""){$RSS = $Arts_list | select-object -ExpandProperty $Arts}
# 地域の選択
if($Regions -ne ""){$RSS = $regions_list | select-object -ExpandProperty $Regions}
# その他の選択
if($Autres -ne ""){$RSS = $Autres_list | select-object -ExpandProperty $Autres}

# Radio-Canada サーバーを照会
$RSS_Query = Invoke-RestMethod -Uri $RSS

# RSS フィードからデータを抽出
 [array]$nouvelle = @(
                     $RSS_Query | Foreach{

                     $Titre = $_.Title
                     $Description = $_.description | Select-Object -ExpandProperty "#cdata-section"
                     $description = $description -replace "<p>"
                     $description = $description -replace "</p>"
                     $lien = $_.link

                     [pscustomobject]@{
                                        'Titre' = $titre
                                        'Nouvelle' = $Description
                                        'Lien' = $lien
                                       }
                                       }
                    )

# オブジェクトとして表示
if($html -ne $true){$nouvelle}

# HTML で表示
if($html -eq $true){

# Radio-Canada HTML ヘッダー画像
$image_rc = "http://generalfusion.com/wp-content/uploads/2016/04/Radio-Canada.jpg"


$html_page = "<html>"
$html_page += '<Head><img src="' + $image_rc + '" alt="' + $image_rc + '" style="width:200px;height:70px;"></head>'
$html_page += "<body>"
$html_page += "<hr>"

$nouvelle | foreach{

                    $titre = $_.titre
                    $nouvelle = $_.Nouvelle
                    $lien = $_.lien

                    $html_page += '<table style="width:100%">'
                    $html_page += "<tr><td><b>Titre: </b>$titre</td></tr>"
                    $html_page += "<tr><td><b>Nouvelle: </b>$nouvelle</td></tr>"
                    $html_page += '<tr><td><b>Site Radio-Canada: </b><a href="' + $lien + '">ICI</a></td></tr>'
                    $html_page += "</table>"
                    $html_page += "<hr>"
                    $html_page += "</br>"

                    }

$html_page += "</body>"
$html_page += "</html>"

$html_page_file = $env:temp + "\rc_info.html"

$html_page | Set-Content -Path $html_page_file

Start-Process -FilePath $html_page_file
}
}
