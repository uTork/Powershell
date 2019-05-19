# This function search a keyword on bing search engine and create a table with the search result
function Search-Bing {

param($keyword,$number_of_result)


# Table Header
$query_h2 = @("Description,Lien")

$number_of_result = $number_of_result -replace " ","+"

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



$query_h2 | convertfrom-csv


}

$list = Search-Bing -keyword "Public FTP Server" -number_of_result 1000

$html = @("<html>"
          "<head><H2> Search Result </h2></head>"
          "<body>"
          '<table>'
          "<tr><th>Description</th><th>Domain</th><th>Link</th></tr>"
          )

$html += @(
            $list | foreach{
                            $link = $_.lien
                            $description = $_.description
                            $domain = ([System.Uri]$link).Host

                            $html_table =   '<tr><td>' + $description + '</td><td><a href="' + $link + '">' + $domain + '</a></td></tr>'

                            $html_table
                            }
                            )


$html += @(
            "</table>"
            "</body>"
            "</html>"
           )

$html_file = $env:temp + "\tmp_html_bing_report.html"

$html | set-content -Path $html_file

Start-Process -FilePath $html_file