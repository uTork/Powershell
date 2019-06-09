# User creation

$name_list = import-csv -path "C:\download\name.txt" -Encoding UTF8

$name_list = $name_list | sort-object firstname,surname -unique

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

$Company_list = @(
                   "Nortel"
                   "Microsoft"
                   "Apple"
                   "La poutine a Pauline"
                   "McDonalds"
                   "Cisco"
                   "IsPowerShell"
                   )

$department_list = @(
                     "IT"
                     "Administration"
                     "Maintenance"
                     "Worker"
                    )


$CreationDate = (get-date).DateTime


$path_list = (Get-ADOrganizationalUnit -filter * | where-object {$_.DistinguishedName -like "*OU=ispowershell,DC=ispowershell,DC=net" -and $_.DistinguishedName -ne "OU=ispowershell,DC=ispowershell,DC=net"}).DistinguishedName

# User Creation
$name_list | foreach{

                    $firstname = $_.firstname
                    $surname = $_.surname
                    $name = $firstname
                    [datetime]$expirationDate = (get-date).AddYears(1)
                    $defaultPassword = ConvertTo-SecureString "Welcome1" -AsPlainText -Force
                    $cannotchangepass = $false
                    $changepasslogon = $true
                    $city = get-random $city_list
                    $Compagny = get-random $Company_list
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
                    New-ADUser -Name $name -AccountExpirationDate $expirationDate -Path $path -AccountPassword $defaultPassword -ChangePasswordAtLogon $changepasslogon -City $city -Company $Compagny  -Department $department -DisplayName $displayname -EmailAddress $emailaddress -Enabled $enabled  -Description $description -EmployeeID $employeeID -HomePage $homepage -PasswordNeverExpires $passwordneverexpire -SamAccountName $samaccount  -Surname $surname -UserPrincipalName $userPrincipalName -ErrorAction Stop
                    $message = "The user $displayname is created!"
                    Write-Output $message
	                }
	                Catch
	                {
		            $ErrorMessage = $_.Exception.Message
		            $FailedItem = $_.Exception.ItemName
                    $FailedItem
                    $ErrorMessage

	}



}

# Group Creation
$user = get-aduser -filter * -Properties *
$date_created = get-date
$user | foreach{
                $city = $_.city
                $city = $city -replace " ","_"
                $samaccountname = $_.samaccountname
                $groupname = "GRP_" + $city + "_Global"
                $path = get-random $path_list
                $group = $null
                $test = try{get-adgroup  -Identity $groupname -ErrorAction stop}catch{$group = "notexist"}

                if($group -eq "notexist"){New-ADGroup -DisplayName $groupname -GroupScope Global -Description "Created the $date_created" -SamAccountName $groupname -Name $groupname -Path $path ;Add-ADGroupMember -Identity $groupname -Members $samaccountname;$message = "The group $groupname is created and the $samaccountname is added to the group $groupname";Write-Output $message}else{
                Add-ADGroupMember -Identity $groupname -Members $samaccountname;$message = "The user $samaccountname is added to the group $groupname";Write-Output $message}
                }



