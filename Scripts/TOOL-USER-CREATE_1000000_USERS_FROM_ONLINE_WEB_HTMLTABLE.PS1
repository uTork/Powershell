function Get-NameList {

<#
.SYNOPSIS
Generate Name List from Magabay website https://names.mongabay.com
.DESCRIPTION
This command create an array @("firstname,surname")
.PARAMETER Number_of_name
.EXAMPLE
Search-Bing -keyword chien -number_of_result 200
Give 200 results of the search
.EXAMPLE 
Get-NameList -number_of_users 10000
Give a list of 10 000 name
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
https://github.com/uTork/Powershell/
.INPUTS
[string]
.OUTPUTS
[string] or [pscustomobject]
#>

Param([int]$number_of_name)

# Surname list from a web site
$uri = "https://names.mongabay.com/most_common_surnames.htm"
$data = Invoke-WebRequest $uri
$table_surname = $data.ParsedHtml.getElementsByTagName("table") | Select -first 1
[array]$table_surname = $table_surname | select -ExpandProperty innertext
$table_surname = $table_surname.Replace("SurnameApproximate","").replace("Number%","").replace("FrequencyRank","")
$table_surname = $table_surname -split "`n"
[regex]$filter = '[^a-zA-Z]'
$surname_list = $table_surname -replace $filter

# Surname list from a web site
$uri = "https://names.mongabay.com/male_names_alpha.htm"
$data = Invoke-WebRequest $uri
$table_firstname = $data.ParsedHtml.getElementsByTagName("table") | Select -first 1
[array]$table_firstname = $table_firstname | select -ExpandProperty innertext
$table_firstname = $table_firstname.Replace("Name%","").replace("NumberRank","").replace("FrequencyApproximate","")
$table_firstname = $table_firstname -split "`n"
[regex]$filter = '[^a-zA-Z]'
$firstname_list = $table_firstname -replace $filter



$surname_count = $surname_list.count
$firstname_count = $firstname_list.count

$number_of_name = 1..$number_of_name
$array = $null

$array = @(
"Firstname,surname"


$number_of_name | %{

    $random_surname_num = get-random -Maximum $surname_count

    $random_surname = $surname_list[$random_surname_num]

    $random_firstname_num = get-random -Maximum $firstname_count

    $random_firstname = $firstname_list[$random_surname_num]

    $random_firstname + "," + $random_surname

}
)

$array | convertfrom-csv
}
