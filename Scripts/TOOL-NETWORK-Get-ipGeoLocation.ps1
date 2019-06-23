function Get-ipGeoLocation{
<#
.SYNOPSIS
Get geolocation of an ip address. You need an FREE API Key from IPSTACK https://ipstack.com/product
.DESCRIPTION
Use the free api from IPSTACK to resolve the location of ip address
.PARAMETER IP
The ip address to resolve.
.PARAMETER APIKEY
 FREE API Key from IPSTACK https://ipstack.com/product
.isPowershell
Open the isPowerShell Wiki with example on the function
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param([string]$IP,
      [string]$APIKEY,
      [switch]$isPowerShell
     )

if($isPowerShell -eq $true){start-process "https://github.com/uTork/Powershell/wiki/Function-%7C-Get-IPGeoLocation";break}

# Api address
$api = "http://api.ipstack.com/" + $ip + "?access_key=$APIKEY"

# Query IPSTACK server
$query = Invoke-RestMethod -Uri $api

# output the object ip location
$query
}
