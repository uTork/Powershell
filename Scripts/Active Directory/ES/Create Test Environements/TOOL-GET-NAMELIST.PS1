function Get-NameList{
<#
.SYNOPSIS

Esta función fue creada para la creación de entornos de prueba de Active Directory. Puede crear millones de usuarios o simplemente cien.
Los nombres provienen del sitio de nombres http://names.mongabay.com

.DESCRIPTION
Generador de lista de nombres

.PARAMETER NUMBER
Número de usuarios que desea crear

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



# Validación de la instalación del módulo ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #fin si el módulo está disponible entonces importar
else { $false } #módulo no disponible
} # fin si no hay módulo
else { $true } #módulo ya cargado
} 
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# Enlaces de apellidos
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# Enlaces de nombres masculinos
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# Enlaces de nombres femeninos
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# Extracción de tablas HTML con el comando Get-HtmlTable del módulo ImportExcel
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# El número de usuarios dividido por 2. Para crear el mismo número de mujeres y hombres
$number_divide = $number /2

# Creación de la lista de nombres
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
# Mostrar el objeto powershell
$name_list
}
