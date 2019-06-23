# copy file and folder to remote pssession

$computer = "192.168.0.169"
$password = ConvertTo-SecureString "Pikachu888!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("administrator",$password)


$TargetSession = New-PSSession -ComputerName $computer -Credential $cred

Copy-Item -ToSession $TargetSession -Path "C:\power\users.txt" -Destination "C:\log" -Recurse
