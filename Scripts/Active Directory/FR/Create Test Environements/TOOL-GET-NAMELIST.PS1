function Get-NameList{
<#
.SYNOPSIS

Cette fonction a été créer pour la création d'environnement de test Active Directory. Elle permet de créer des millions d'usagers ou simplement une centaine.
Les noms provienne su site de noms http://names.mongabay.com

.DESCRIPTION
Generateur de nom

.PARAMETER NUMBER
Nombre d'utilisateurs que vous souhaitez créer

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



# Validation de l'installation du module ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #fin si le module est disponible alors importer
else { $false } #module non disponible
} # fin si pas de module
else { $true } #module déjà chargé
} 
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# Liens des noms de famille
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# Liens des noms masculin
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# Liens des noms féminin
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# Extraction des tables HTML avec la commande Get-HtmlTable du module importexcel
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# Nombre d'utilisateur divisé par deux. Pour créer la moitié d'homme et l'autre de femme.
$number_divide = $number /2

# Creation de la liste de nom
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
# Affiche les objets powershell
$name_list
}
