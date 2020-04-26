function Get-NameList{
<#
.SYNOPSIS

Francais
Cette fonction a été créer pour la création d'environnement de test Active Directory. Elle permet de créer des millions d'usagers ou simplement une centaine. 
Les noms provienne su site de noms http://names.mongabay.com

English
This function was created for the creation of Active Directory test environment. It can create millions of users or simply a hundred.
The names come from the names site http://names.mongabay.com

.DESCRIPTION
Name list generator | Generateur de nom

.PARAMETER NUMBER
Number of user you want to create | Nombre d'utilisateurs que vous souhaitez créer

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



# ImportExcel module installation validation
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
} #end if module available then import
else { $false } #module not available
} # end if not module
else { $true } #module already loaded
} 
$message1 = "Install the ImportExcel module on Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# Surname Links | Liens des noms de famille
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# Male Name Links | Liens des noms masculin        
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# Female Name Links | Liens des noms féminin
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# Html Table extraction with the command Get-HtmlTable from the ImportExcel module
# Extraction des tables HTML avec la commande Get-HtmlTable du module importexcel
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# The number of users divide by 2. To create same number of female and man 
# Nombre d'utilisateur divisé par deux. Pour créer la moitié d'homme et l'autre de femme.
$number_divide = $number /2

# Name list creation | Creation de la liste de nom
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
# Affiche les objets powershell | Show the powershell object
$name_list
}
