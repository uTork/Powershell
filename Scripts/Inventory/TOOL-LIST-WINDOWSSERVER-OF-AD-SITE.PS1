# List Windows Server 

function Get-ComputerSite($ComputerName)
{
   $site = nltest /server:$ComputerName /dsgetsite 2>$null
   if($LASTEXITCODE -eq 0){ $site[0] }
}
 

$servers = (get-adcomputer -Filter * -Properties * | where-object {$_.operatingsystem -like "*server*"}).name

$servers | foreach{


                   $site = Get-ComputerSite $_
                   $ping = Test-Connection -ComputerName $_ -Count 1 -Quiet
                   if($ping -eq $true){                  
                   if($site -eq "Israel Head Office"){
                                      $_  
                                      }
                                      }
                  }
