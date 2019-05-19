function get-arraynoadd {
# Surname list from a web site
$uri = "https://names.mongabay.com/most_common_surnames.htm"
$data = Invoke-WebRequest $uri
$table_surname = $data.ParsedHtml.getElementsByTagName("table") | Select -first 1
[array]$table_surname = $table_surname | select -ExpandProperty innertext
$table_surname = $table_surname.Replace("SurnameApproximate","").replace("Number%","").replace("FrequencyRank","")
$table_surname = $table_surname -split "`n"
[regex]$filter = '[^a-zA-Z]'
$surname_list = $table_surname -replace $filter

# Firstname List


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

$number_of_name = 1..15000
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

}

function get-arraywithaddequal {
# Surname list from a web site
$uri = "https://names.mongabay.com/most_common_surnames.htm"
$data = Invoke-WebRequest $uri
$table_surname = $data.ParsedHtml.getElementsByTagName("table") | Select -first 1
[array]$table_surname = $table_surname | select -ExpandProperty innertext
$table_surname = $table_surname.Replace("SurnameApproximate","").replace("Number%","").replace("FrequencyRank","")
$table_surname = $table_surname -split "`n"
[regex]$filter = '[^a-zA-Z]'
$surname_list = $table_surname -replace $filter

# Firstname List


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

$number_of_name = 1..15000
$array = $null
$array = @()
$array += "Firstname,surname"


$number_of_name | %{

$random_surname_num = get-random -Maximum $surname_count

$random_surname = $surname_list[$random_surname_num]

$random_firstname_num = get-random -Maximum $firstname_count

$random_firstname = $firstname_list[$random_surname_num]

$array += $random_firstname + "," + $random_surname

}
}

write "Array without +="
Measure-Command -Expression {get-arraynoadd}
write "Array with +="
Measure-Command -Expression {get-arraywithaddequal}


#$array2 = $array | convertfrom-csv
#$a = $array2 | select -Unique

#Compare-Object -ReferenceObject $array2 -DifferenceObject $a -IncludeEqual | Where-Object



#$array2 = $array | convertfrom-csv
#$a = $array2 | select -Unique

#Compare-Object -ReferenceObject $array2 -DifferenceObject $a -IncludeEqual | Where-Object {$_.sideindicator -eq "=="}
