## Script Migrate DHCP Reservation to another server
## Module DHCP Server
## Need domain admin right


$dhcp_server_scource = Get-DhcpServerv4Reservation -ScopeId 10.72.64.0 -ComputerName Server-1


foreach($res in $dhcp_server_scource){

$ip_reservation = $res.IPAddress
$scope = "10.72.64.0"
$mac = $res.ClientId
$name = $res.name
$desc = $res.description
$type = $res.type
$computer = "Server-2"


Add-DhcpServerv4Reservation -ClientId $mac -IPAddress $ip_reservation -ScopeId $scope -ComputerName $computer -Description $desc -Name $name -Type Both -ErrorAction SilentlyContinue


}
