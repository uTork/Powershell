$user_list = get-aduser -filter * -SearchBase "OU=ispowershell,DC=ispowershell,DC=net"


$user_list | foreach{

                    $username = $_.samaccountname
                    $smtp_address = "$username" + "@octavie.onmicrosoft.com"
                     

Set-ADUser -Identity $_ -Replace @{'ProxyAddresses'="SMTP:$smtp_address"}
Set-ADUser -Identity $_ -EmailAddress $smtp_address

}
