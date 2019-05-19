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

# Whois Funtion to get information of ip address (country etc...)
Function Get-MyWhoIs {
 
<#
.SYNOPSIS
Get WhoIS data
.DESCRIPTION
Use this command to get public WhoIS domain information for a given IP v4 address.
.PARAMETER Ip
Enter an IPv4 Address. This command has aliases of: Address
.PARAMETER Full
Show complete whoIs information.
.EXAMPLE
PS C:\> Get-MyWhoIs 208.67.222.222
OpenDNS, LLC
.EXAMPLE
PS C:\> Get-MyWhoIs 208.67.222.222 -full
 
 
IP                     : 208.67.222.222
Name                   : OPENDNS-NET-1
RegisteredOrganization : OpenDNS, LLC
City                   : San Francisco
StartAddress           : 208.67.216.0
EndAddress             : 208.67.223.255
NetBlocks              : 208.67.216.0/21
Updated                : 3/2/2012 8:03:18 AM
.NOTES
NAME        :  Get-MyWhoIs
VERSION     :  1.0   
LAST UPDATED:  4/3/2015
AUTHOR      :  Jeff Hicks (@JeffHicks)
 
Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/
 
  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
.LINK
Invoke-RestMethod
.INPUTS
[string]
.OUTPUTS
[string] or [pscustomobject]
#>
 
[cmdletbinding()]
Param (
[parameter(Position=0,Mandatory,HelpMessage="Enter an IPv4 Address.",
ValueFromPipeline,ValueFromPipelineByPropertyName)]
[Alias("Address")]
[ValidatePattern("^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")]
[string]$IP,
 
[Parameter(Helpmessage="Show complete WhoIs information.")]
[switch]$Full
)
 
Begin {
    Write-Verbose "Starting $($MyInvocation.Mycommand)"  
    $baseURL = 'http://whois.arin.net/rest'
    #default is XML anyway
    $header = @{"Accept"="application/xml"}
 
} #begin
 
Process {
    $url = "$baseUrl/ip/$ip"
    $r = Invoke-Restmethod $url -Headers $header
 
    Write-verbose ($r.net | out-string)
    if ($Full) {
    $propHash=[ordered]@{
        IP = $ip
        Name = $r.net.name
        RegisteredOrganization = $r.net.orgRef.name
        City = (Invoke-RestMethod $r.net.orgRef.'#text').org.city
        StartAddress = $r.net.startAddress
        EndAddress = $r.net.endAddress
        NetBlocks = $r.net.netBlocks.netBlock | foreach {"$($_.startaddress)/$($_.cidrLength)"}
        Updated = $r.net.updateDate -as [datetime]   
        }
        [pscustomobject]$propHash
    }
    else {
        #write just the name
        $r.net.orgRef.Name
    }
      
} #Process
 
End {
    Write-Verbose "Ending $($MyInvocation.Mycommand)"
} #end 
} #end Get-WhoIs


[array]$search = Search-Bing -keyword "torrent" -number_of_result 100000

$message_step_1 = "Web site query finished..."
write-host $message_step_1

# Extract the domain name from the url and create abn array
$search_result = @("Link,domain,ip,city,description")
$search_result += @(
                   foreach($s in $search){
                   $link = $s.lien
                   $description = $s.description
                   $domain = ([System.Uri]$link).Host
                   $ip_address = (Resolve-DnsName -Name $domain).IP4address
                   $ip_address = $ip_address[0]
                   $city = try{(Get-MyWhoIs -IP $ip_address -full -ErrorAction stop).city}catch{$city = "BUG"}

                  if($ip_address.Length -gt 4){
                   $value = $link + "," + $domain + "," + $ip_address + "," + $city + "," + $description
                   $value
                   }
                   }
                   )

# Convert to CSV
$search_result = $search_result | convertfrom-csv

# Exclude the domain name doublon
$search_result = $search_result | sort domain -unique

$search_result | ft
            
            $search_result | Group-Object -Property CITY | SELECT-OBJECT Count,name

            $env:temp