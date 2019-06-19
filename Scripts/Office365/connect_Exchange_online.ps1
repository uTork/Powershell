$user = "sebastien.maltais@octavie.onmicrosoft.com"
$password = ConvertTo-SecureString "8888Pikac6hu!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ($user,$password)


$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Remove-PSSession $Session
