# Script to change the server ip address on all servers reachable by ping on a domain
# Right to execute the script: Domain admins | Administrator | Local server administrator (You have to execute powershell ise with this account)
# Powershell Module needed | Active Directory
# TIPS: You have to enbale powershell remoting for your computer into a GPO to allow your computer to modify the settings
# TIPS: If the remote server wont support powershell 5.1 you get an error and you have to do the change manually.
# Author: Sebastien Maltais Twitter: @seb_maltais


# Server list of the Active Directory Domain
$servers = (Get-ADComputer -Filter * -Properties * | Where-Object {$_.operatingsystem -like "*server*"}).name




foreach($srv in $servers){

#ping test to test the connectivity of the server
$ping = Test-Connection -ComputerName $srv -Count 2 -Quiet

if($ping -eq $true){

# Display the server into the output
$srv

# Launch the proxy remotely on the computer
Invoke-Command -ComputerName $srv {


# Function to get the proxy settings of the remote computer
function Get-InternetProxy
 { 

    $proxies = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -ErrorAction SilentlyContinue).proxyServer

    if ($proxies)
    {
        if ($proxies -ilike "*=*")
        {
            $proxies -replace "=","://" -split(';') | Select-Object -First 1 -ErrorAction SilentlyContinue
        }

        else
        {
            "http://" + $proxies
        }
    }    
}

# Old proxy to change for the new one
$old_proxy = "http://10.10.2.3:8080"
# New proxy to set on the computer
$new_proxy = "10.20.33.66:8080"


$proxy = Get-InternetProxy

if($proxy -eq $old_proxy -or $proxy -eq $null){


# Set the new proxy o0n the remove computer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $new_proxy

#enable the new proxy on the remote computer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1

}

# Get the new proxy configuration after the change or the proxy already set without the change
Get-InternetProxy

}

}

}
