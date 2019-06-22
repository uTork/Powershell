function Get-CNN {

<#
.SYNOPSIS
Get CNN news from RSS
.DESCRIPTION
Convert the news for object for universal dashboard or HTML for reading
.PARAMETER Category
News Category
.PARAMETER HTML
Show the news in HTML
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

Param(   
         
         [ValidateSet('Technology','Politics','Video','Business','Most_Recent','Health','Travel','Top_Stories','US','CNN_10','World','Entertainment','CNN_Underscored')][string]$Category,
         [switch]$HTML
      )


$cnn = @{
'Top_Stories' =	'http://rss.cnn.com/rss/cnn_topstories.rss'
'World' =	'http://rss.cnn.com/rss/cnn_world.rss'
'US' = "http://rss.cnn.com/rss/cnn_us.rss"
"Business" = "http://rss.cnn.com/rss/money_latest.rss"
"Politics" = "http://rss.cnn.com/rss/cnn_allpolitics.rss"
"Technology" =	"http://rss.cnn.com/rss/cnn_tech.rss"
"Health" =	"http://rss.cnn.com/rss/cnn_health.rss"
"Entertainment" = "http://rss.cnn.com/rss/cnn_showbiz.rss"
"Travel"	= "http://rss.cnn.com/rss/cnn_travel.rss"
"Video"	 = "http://rss.cnn.com/rss/cnn_freevideo.rss"
"CNN_10" = "http://rss.cnn.com/services/podcasting/cnn10/rss.xml"
"Most_Recent" = "http://rss.cnn.com/rss/cnn_latest.rss"
'CNN_Underscored' =	'http://rss.cnn.com/cnn-underscored.rss'
}

# query cnn
$cnn_news = Invoke-RestMethod -uri $cnn."$Category"


$cnn_news_object =  $cnn_news | foreach{
                    $title = ($_ | select-object -ExpandProperty title)."#cdata-section"
                    $Description = $_.description
                    $pos = $Description.IndexOf('<div class="feedflare">')
                    $Description = $Description.Substring(0, $pos)
                    $link = $_.origLink

                     $obj = New-Object PSObject
                     $obj | Add-Member -type NoteProperty -Name 'Title' -Value $title
                     $obj | Add-Member -type NoteProperty -Name 'News' -Value $Description
                     $obj | Add-Member -type NoteProperty -Name 'Link' -Value $link
                     $obj                   
                    }


# Show news objects            
if($html -ne $true){$cnn_news_object}

# Show News in HTML
if($html -eq $true){
$image_cnn = "https://seeklogo.com/images/C/CNN-logo-8DA6D1FC28-seeklogo.com.png"


$html_page = "<html>"
$html_page += '<Head><img src="' + $image_cnn + '" alt="' + $image_cnn + '" style="width:155px;height:70px;"></head>'
$html_page += "<body>"
$html_page += "</br></br>"

$cnn_news_object | foreach{

$title = $_.title
$news = $_.News
$link = $_.link

$html_page += '<table style="width:100%">'
$html_page += "<tr><td><b>Title: </b>$title</td></tr>"
$html_page += "<tr><td><b>News: </b>$news</td></tr>"
$html_page += '<tr><td><b>Link: </b><a href="' + $link + '">CNN</a></td></tr>'
$html_page += "</table>"
$html_page += "</br>"

}

$html_page += "</body>"
$html_page += "</html>"

$html_page_file = $env:temp + "\cnn_news.html"

$html_page | Set-Content -Path $html_page_file

Start-Process -FilePath $html_page_file
}
}
