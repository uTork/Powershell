# User creation

$name_list = import-csv -path "C:\download\name.txt" -Encoding UTF8

$city_list = @(
               "Jonquiere"
               "Chicoutimi"
               "Alma"
               "Roberval"
               "Arvida"
               "Montreal"
               "Toronto"
               "Shipshaw"
               "Ottawa"
               "New York"
               "Los Angeles"
               )

$Compagny_list = @(
                   "Nortel"
                   "Microsoft"
                   "Apple"
                   "La poutine a Pauline"
                   "McDonalds"
                   "Cisco"
                   "IsPowerShell"
                   )


$Country_list = @(
                  "Canada"
                  "United-States"
                  "Liban"
                  "China"
                  "India"
                  )

$department_list = @(
                "IT"
                "Administration"
                "Maintenance"
                "Worker"
                )

$CreationDate = (get-date).DateTime


$manager_list = @(
                  "Sebastien Maltais"
                  "Elvis Gratton"
                  "King Kave"
                  "Manon Dutronc"
                  "Bob Stoic"
                  "Eric Clapton"
                  "Jimmy Hendrix"
                  )

$path_list = (Get-ADOrganizationalUnit -filter * | where-object {$_.DistinguishedName -like "*OU=ispowershell,DC=ispowershell,DC=net" -and $_.DistinguishedName -ne "OU=ispowershell,DC=ispowershell,DC=net"}).DistinguishedName

$name_list | foreach{

                    #ConvertTo-SecureString "Welcome1" -AsPlainText -Force
                    $firstname = $_.firstname
                    $surname = $_.surname
                    $name = $firstname
                    $expirationDate = (get-date).AddYears(-1)
                    $defaultPassword = ConvertTo-SecureString "Welcome1" -AsPlainText -Force
                    $cannotchangepass = $false
                    $changepasslogon = $true
                    $city = get-random $city_list
                    $Compagny = get-random $Compagny_list
                    $country = get-random $Country_list
                    $department = get-random $department_list
                    $description = "The user is created the $creationdate"
                    $displayname = "$name $surname"
                    $emailaddress = "$name.$surname@ispowershell.com"
                    $employeeID = get-random
                    $enabled = $true
                    $homepage = "http://www.facebook.com/ispowershell"
                    $passwordneverexpire = $false
                    $path = get-random $path_list
                    $samaccount = "$name.$surname"
                    $surname = $surname
                    $userPrincipalName = "$name.$surname@ispowershell.com"



                    try{
                    New-ADUser -Name $name -AccountExpirationDate $expirationDate
                    #-AccountExpirationDate $expirationDate -AccountPassword $defaultPassword -ChangePasswordAtLogon $changepasslogon -City $city -Company $Compagny -Country $country -Department $department -DisplayName $displayname  -EmailAddress $emailaddress  -Enabled $enabled  -Description $description -EmployeeID $employeeID -HomePage $homepage -PasswordNeverExpires $passwordneverexpire  -Path $path -SamAccountName $samaccount  -Surname $surname -UserPrincipalName $userPrincipalName -ErrorAction Stop

	                }
	                Catch
	                {
		            $ErrorMessage = $_.Exception.Message
		            $FailedItem = $_.Exception.ItemName
                    $FailedItem
                    $ErrorMessage

	}



}

