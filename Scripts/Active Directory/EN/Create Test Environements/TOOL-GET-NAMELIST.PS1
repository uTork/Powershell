function Get-NameList{
<#
.SYNOPSIS

This function was created for the creation of Active Directory test environment. It can create millions of users or simply a hundred.
The names come from the names site http://names.mongabay.com

.DESCRIPTION
Name list generator

.PARAMETER NUMBER
Number of user you want to create

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
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# Surname Links
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# Male Name Links
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# Female Name Links
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# Html Table extraction with the command Get-HtmlTable from the ImportExcel module
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# The number of users divide by 2. To create same number of female and man
$number_divide = $number /2

# Name list creation
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
# Show the powershell object
$name_list
}
