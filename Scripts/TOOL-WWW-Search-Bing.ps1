
function Search-Bing {

<#
.SYNOPSIS
Search Bing.com
.DESCRIPTION
Use this command to get an HTML report of the search result
.PARAMETER KEYWORD
The keyword you want to search on BING
.PARAMETER Number_of_result
Numver of search result
.PARAMETER Unique
Remove result with same hostname
.PARAMETER HTML
Show the result in HTML report
.EXAMPLE
Search-Bing -keyword chien -number_of_result 200
Give 200 results of the search
.EXAMPLE 
Search-Bing -keyword chien -number_of_result 200 -HTML
Give 200 results of the search and open HTML report with the link
.LINK
Sébastien Maltais
sebastien_maltais@hotmail.com
https://github.com/uTork/Powershell/
.INPUTS
[string]
.OUTPUTS
[string] or [pscustomobject]
#>


param($keyword,$number_of_result,[switch]$Unique,[switch]$Html)


# Table Header
$query_h2 = @("Description,Link")

$keyword = $keyword -replace " ","+"

# Result counter
$p = 0

while($p -lt $number_of_result){

$www = "https://www.bing.com/search?q=$keyword&qs=n&sp=-1&pq=$keyword&sc=8-5&sk=&cvid=E0A3EC737EEA49248FA4EB56B2E093D0&first=$p&FORM=PERE"

$select = Invoke-WebRequest -Uri $www

[regex]$reg = "https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"

$p = $p + 10 #add the next 10 result to the variable

$query_h2 += @(
                
                $select.ParsedHtml.body.getElementsByTagName("H2") | foreach{

                                                                            $texte = $_.innertext -replace ",",""
                                                                            $lien = $_.innerhtml | Select-string -Pattern $reg -AllMatches | % { $_.Matches }
                                                                            $CSV = $texte + "," + $lien
                                                                            
                                                                            if($csv.length -gt 45){$csv}
                                                                             }
             )

}



$query_h2 = $query_h2 | convertfrom-csv


 [array]$list_hostname = "Description,Domain,Link"
        $list_hostname += @(
                            $query_h2 | foreach{
                                            $link = $_.link
                                            $description = $_.description
                                            $domain = ([System.Uri]$link).Host
                                            $value = $description + "," + $domain + "," + $link
                                            $value

                            }
                            )
        $list_hostname = $list_hostname | convertfrom-csv

if($unique -eq $true){
# remove same host from the result

        $list_hostname = $list_hostname | sort domain -Unique
}



if($html -eq $false){

                    $list_hostname | Format-Table

                    }


if($html -eq $true){

$list = $list_hostname

$html_report = @(
          "<html>"
          "<head><H2> Search Result </h2>"
          "<style>"
          "table, th, td {"
          "border: 1px solid black;}"
          "</style>"
          "</head>"
          "<body>"
          '<table>'
          "<tr><th>Description</th><th>Link</th></tr>"
          )

$html_report += @(
            $list | foreach{
                            $link = $_.link
                            $description = $_.description
                            $domain = $_.domain

                            $html_table =   '<tr><td>' + $description + '</td><td><a href="' + $link + '">' + $domain + '</a></td></tr>'

                            $html_table
                            }
                            )

$html_report += @(
            "</table>"
            "</body>"
            "</html>"
           )

$html_file = $env:temp + "\tmp_html_bing_report.html"

$html_report | set-content -Path $html_file

Start-Process -FilePath $html_file
}
}
