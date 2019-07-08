Function Get-RadioCanada {

<#
.SYNOPSIS
Affiche les nouvelles de Radio-Canada
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
         
         [ValidateSet('Grands Titres','En Continue')][string]$Information,
         [ValidateSet('Alimentation','Art de Vivre','Economie','Environnement','International','Justice et faits divers','Politique','Sante','Science','Techno')][string]$Thematiques,
         [ValidateSet('Grands Titres','Football','Hockey','Olympique','Podium','Soccer','Tennis')][string]$Sports,
         [ValidateSet('Celebrites','Cinema','Grands Titres','Humour','Livres','Musique','Tele')][string]$Arts,
         [ValidateSet('Abitibi-Témiscamingue','Alberta','Bas-Saint-Laurent','Colombie-Britannique','Cote-Nord','Estrie','Gaspesie iles de la Madeleine','Grand Montreal','Grand Nord','ile-du-Prince-Edouard','Manitoba','Mauricie-Centre-du-Quebec','Mauricie-Centre-du-Quebec','Nord Ontario','Nouveau-Brunswick','Nouvelle-Écosse','Ottawa-Gatineau','Quebec','Saskatchewan','Terre-Neuve-et-Labrador','Toronto','Windsor')][string]$Regions,                  
         [ValidateSet('Archives','Dossiers','Espaces Autochtones','RCI')][string]$Autres,
         [switch]$HTML
      )



# Informations
$Information_GrandsTitres = "https://ici.radio-canada.ca/rss/4159"
$Information_EnContinu = "https://ici.radio-canada.ca/rss/1000524"

# Sélection de l'information
if($Information -eq "Grands Titres"){$RSS = $Information_GrandsTitres}
if($Information -eq "En Continue"){$RSS = $Information_EnContinu}

# Thematique
$Thematiques_Alimentation = "https://ici.radio-canada.ca/rss/7239"
$Thematiques_ArtdeVivre = "https://ici.radio-canada.ca/rss/4163"
$Thematiques_Economie = "https://ici.radio-canada.ca/rss/5717"
$Thematiques_Environnement = "https://ici.radio-canada.ca/rss/92408"
$Thematiques_International = "https://ici.radio-canada.ca/rss/96"
$Thematiques_JusticeFaitDivers = "https://ici.radio-canada.ca/rss/92411"
$Thematiques_Politique = "https://ici.radio-canada.ca/rss/4175"
$Thematiques_Sante = "https://ici.radio-canada.ca/rss/4175"
$Thematiques_Science = "https://ici.radio-canada.ca/rss/4165"
$Thematiques_Techno = "https://ici.radio-canada.ca/rss/4169"

# Sélection des thématiques
if($Thematiques -eq "Alimentation"){$RSS = $Thematiques_Alimentation}
if($Thematiques -eq "Art de Vivre"){$RSS = $Thematiques_ArtdeVivre}
if($Thematiques -eq "Economie"){$RSS = $Thematiques_Economie}
if($Thematiques -eq "Environnement"){$RSS = $Thematiques_Environnement}
if($Thematiques -eq "International"){$RSS = $Thematiques_International}
if($Thematiques -eq "Justice et faits divers"){$RSS = $Thematiques_JusticeFaitDivers}
if($Thematiques -eq "Politique"){$RSS = $Thematiques_Politique}
if($Thematiques -eq "Sante"){$RSS = $Thematiques_Sante}
if($Thematiques -eq "Science"){$RSS = $Thematiques_Science}
if($Thematiques -eq "Techno"){$RSS = $Thematiques_Techno}


# Sports
$Sport_Football = "https://ici.radio-canada.ca/rss/1000057"
$Sport_GrandsTitres = "https://ici.radio-canada.ca/rss/771"
$Sport_hockey = "https://ici.radio-canada.ca/rss/1000056"
$Sport_Olympique = "https://ici.radio-canada.ca/rss/64852"
$Sport_Podium = "https://ici.radio-canada.ca/rss/555082"
$Sport_Soccer = "https://ici.radio-canada.ca/rss/1000058"
$Sport_Tennis = "https://ici.radio-canada.ca/rss/1000059"

if($Sports -eq "Football"){$RSS = $Sport_Football}
if($Sports -eq "Grands Titres"){$RSS = $Sport_GrandsTitres}
if($Sports -eq "Hockey"){$RSS = $Sport_hockey}
if($Sports -eq "Olympique"){$RSS = $Sport_Olympique}
if($Sports -eq "Podium"){$RSS = $Sport_Podium}
if($Sports -eq "Soccer"){$RSS = $Sport_Soccer}
if($Sports -eq "Tennis"){$RSS = $Sport_Tennis}

# Arts
$Art_Celebrites = "https://ici.radio-canada.ca/rss/1000232"
$Art_Cinema = "https://ici.radio-canada.ca/rss/1000229"
$Art_GrandsTitres = "https://ici.radio-canada.ca/rss/4167"
$Art_Humour = "https://ici.radio-canada.ca/rss/1000231"
$Art_Livres = "https://ici.radio-canada.ca/rss/1000083"
$Art_Musique = "https://ici.radio-canada.ca/rss/1000230"
$Art_Tele = "https://ici.radio-canada.ca/rss/1000233"

# Selection des Arts
if($Arts -eq "Celebrites"){$RSS = $Art_Celebrites}
if($Arts -eq "Cinema"){$RSS = $Art_Cinema}
if($Arts -eq "Grands Titres"){$RSS = $Art_GrandsTitres}
if($Arts -eq "Humour"){$RSS = $Art_Humour}
if($Arts -eq "Livres"){$RSS = $Art_Livres}
if($Arts -eq "Musique"){$RSS = $Art_Musique}
if($Arts -eq "Tele"){$RSS = $Art_Tele}

# Regions
$Region_AbitibiTémiscamingue = "https://ici.radio-canada.ca/rss/5763"
$Region_Alberta = "https://ici.radio-canada.ca/rss/5767"
$Region_BasStLaurent = "https://ici.radio-canada.ca/rss/35004"
$Region_ClombieBritanique = "https://ici.radio-canada.ca/rss/5769"
$Region_CoteNord = "https://ici.radio-canada.ca/rss/35019"
$Region_Estrie = "https://ici.radio-canada.ca/rss/5773"
$Region_GaspésieÎlesdelaMadeleine = "https://ici.radio-canada.ca/rss/35015"
$Region_GrandMontreal = "https://ici.radio-canada.ca/rss/4201"
$Region_GrandNord = "https://ici.radio-canada.ca/rss/1001049"
$Region_IlesPrinceEdouard = "https://ici.radio-canada.ca/rss/1000814"
$Region_Manitoba = "https://ici.radio-canada.ca/rss/5775"
$Region_MauricieCentreQuebec = "https://ici.radio-canada.ca/rss/5777"
$Region_NordOntario = "https://ici.radio-canada.ca/rss/36518"
$Region_NouveauBrunswich = "https://ici.radio-canada.ca/rss/5765"
$Region_NouvelleEcosse = "https://ici.radio-canada.ca/rss/1000813"
$Region_OttawaGatineau = "https://ici.radio-canada.ca/rss/6102"
$Region_Quebec = "https://ici.radio-canada.ca/rss/6104"
$Region_SaguenayLacStJean = "https://ici.radio-canada.ca/rss/6106"
$Region_Saskatchewan = "https://ici.radio-canada.ca/rss/6108"
$Region_TerreNeuveetLabrador = "Thttps://ici.radio-canada.ca/rss/1000815"
$Region_Toronto = "https://ici.radio-canada.ca/rss/5779"
$Region_Windsor = "https://ici.radio-canada.ca/rss/475289"

# Selection Regions
if($Regions -eq "Abitibi-Témiscamingue"){$RSS = $Region_AbitibiTémiscamingue}
if($Regions -eq "Alberta"){$RSS = $Region_Alberta}
if($Regions -eq "Bas-Saint-Laurent"){$RSS = $Region_BasStLaurent}
if($Regions -eq "Colombie-Britannique"){$RSS = $Region_ClombieBritanique}
if($Regions -eq "Cote-Nord"){$RSS = $Region_GrandNord}
if($Regions -eq "Estrie"){$RSS = $Region_Estrie}
if($Regions -eq "Gaspesie iles de la Madeleine"){$RSS = $Region_GaspésieÎlesdelaMadeleine}
if($Regions -eq "Grand Montreal"){$RSS = $Region_GrandMontreal}
if($Regions -eq "Grand Nord"){$RSS = $Region_GrandNord}
if($Regions -eq "ile-du-Prince-Edouard"){$RSS = $Region_IlesPrinceEdouard}
if($Regions -eq "Manitoba"){$RSS = $Region_Manitoba}
if($Regions -eq "Mauricie-Centre-du-Quebec"){$RSS = $Region_MauricieCentreQuebec}
if($Regions -eq "Nord de l’Ontario"){$RSS = $Region_NordOntario}
if($Regions -eq "Nouveau-Brunswick"){$RSS = $Region_NouveauBrunswich}
if($Regions -eq "Nouvelle-Écosse"){$RSS = $Region_NouvelleEcosse}
if($Regions -eq "Ottawa-Gatineau"){$RSS = $Region_OttawaGatineau}
if($Regions -eq "Quebec"){$RSS = $Region_Quebec}
if($Regions -eq "Saskatchewan"){$RSS = $Region_Saskatchewan}
if($Regions -eq "Terre-Neuve-et-Labrador"){$RSS = $Region_TerreNeuveetLabrador}
if($Regions -eq "Toronto"){$RSS = $Region_Toronto}
if($Regions -eq "Windsor"){$RSS = $Region_Windsor}

# Autres
$Autres_Archives = "https://ici.radio-canada.ca/rss/1000548"
$Autres_Dossiers = "https://ici.radio-canada.ca/rss/6735"
$Autres_Espacesautochtones = "https://ici.radio-canada.ca/rss/116435"
$Autres_RCINET = "http://www.rcinet.ca/fr/feed/rss/"

if($Autres -eq "Archives"){$RSS = $Autres_Archives}
if($Autres -eq "Dossiers"){$RSS = $Autres_Dossiers}
if($Autres -eq "Espaces Autochtones"){$RSS = $Autres_Espacesautochtones}
if($Autres -eq "RCI"){$RSS = $Autres_RCINET}


# Interoge le Serveur de Radio-Canada
$RSS_Query = Invoke-RestMethod -Uri $RSS

# Extrait les donner du fil RSS
 $nouvelle = $RSS_Query | Foreach{

                     $Titre = $_.Title
                     $Description = $_ | Select-Object -ExpandProperty Description
                     $description = $description."#cdata-section"
                     $description = $description -replace "<p>"
                     $description = $description -replace "</p>"
                     $lien = $_.link

                     $obj = New-Object PSObject
                     $obj | Add-Member -type NoteProperty -Name 'Titre' -Value $titre
                     $obj | Add-Member -type NoteProperty -Name 'Nouvelle' -Value $Description
                     $obj | Add-Member -type NoteProperty -Name 'Lien' -Value $lien
                     $obj
                     




            }

# Affiche en objet            
if($html -ne $true){$nouvelle}

# Affiche en HTML
if($html -eq $true){
$image_rc = "http://generalfusion.com/wp-content/uploads/2016/04/Radio-Canada.jpg"


$html_page = "<html>"
$html_page += '<Head><img src="' + $image_rc + '" alt="' + $image_rc + '" style="width:155px;height:50px;"></head>'
$html_page += "<body>"

$nouvelle | foreach{

$titre = $_.titre
$nouvelle = $_.Nouvelle
$lien = $_.lien

$html_page += '<table style="width:100%">'
$html_page += "<tr><td><b>Titre: </b>$titre</td></tr>"
$html_page += "<tr><td><b>Nouvelle: </b>$nouvelle</td></tr>"
$html_page += '<tr><td><b>Site Radio-Canada: </b><a href="' + $lien + '">ICI</a></td></tr>'
$html_page += "</table>"
$html_page += "</br>"

}

$html_page += "</body>"
$html_page += "</html>"

$html_page_file = $env:temp + "\rc_info.html"

$html_page | Set-Content -Path $html_page_file

Start-Process -FilePath $html_page_file
}
}