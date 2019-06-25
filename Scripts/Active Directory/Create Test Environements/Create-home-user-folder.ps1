# Home user folder creation

$user_list = (get-aduser -filter * -property * -SearchBase "OU=ispowershell,DC=ispowershell,DC=net").samaccountname


$user_list | foreach{
                    
                    $home_user = "c:\home\$_"

                    new-item -Path $home_user

                    Set-NTFSOwner -Account $_ -Path $home_user
                    Add-NTFSAccess -Path $home_user -Account $_ -AccessRights FullControl



                    }
