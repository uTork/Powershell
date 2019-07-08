# Test dhcp server reservation

$scope = "10.0.0.0"

$server_dhcp = "172.16.10.50"

$dhcp = Get-DhcpServerv4Reservation -ScopeId $scope -ComputerName $server_dhcp

$dhcp_state = $dhcp | foreach{

                $ip = $_.IPAddress.IPAddressToString
                $name = $_.name
                $description = $_.description
                $macaddress = $_.ClientId
                $DHCPTYPE = $_.type

                $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet

                if($ping -eq $true){$State = "online"}else{$state = "offline"}

                                    [pscustomobject]@{

                                                      State = $State
                                                      "Ip Address" = $ip
                                                      Name = $Description
                                                      Description = $Description
                                                      MacAddress = $macaddress
                                                      DHCPType = $DHCPTYPE

                                                      }    

                                    }

$dhcp_state | export-csv -path C:\w\txt.txt -Encoding UTF8 -Force
