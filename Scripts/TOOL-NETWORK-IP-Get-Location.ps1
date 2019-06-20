function Get-GeoLocation{
<#
.SYNOPSIS
Get geolocation of an ip address
.DESCRIPTION
Use the free api from IPSTACK to resolve the location of ip address
.PARAMETER IP
The ip address to resolve.
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>

param([string]$IP)

# free api key from ipstack https://ipstack.com/product
$api_key = "487ba0148ea691ed95652c53f217f0b3"

# Api address
$api = "http://api.ipstack.com/" + $ip + "?access_key=$api_key"

$query = Invoke-RestMethod -Uri $api
$query
}
