# connect to the remote server PSSESSION

$computer = "192.168.0.169"
$password = ConvertTo-SecureString "Pikachu888!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("administrator",$password)

Enter-PSSession -ComputerName $computer -Credential $cred
