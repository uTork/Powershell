# Rapporte l'utilisation d'espace de la totalité des disque du serveur


$remotecomputer = "srv1gig_fs3"

#Creation de la liste des disques dir
$lettre_du_disque = (Get-WmiObject Win32_LogicalDisk -ComputerName $remotecomputer | where-object {$_.DriveType -eq "3"}).deviceid

# Met les variables à zéro pour le calcul
[long]$size = 0
[long]$free = 0

foreach($lettre in $lettre_du_disque){

$disque = Get-WmiObject Win32_LogicalDisk -ComputerName $remotecomputer | where-Object {$_.deviceid -eq $lettre} | Select-Object Size,FreeSpace

[long]$add_size = $disque.Size
[long]$add_free = $disque.FreeSpace


[long]$size = $size + $add_size
[long]$free = $free + $add_free



}

[string]$used = [Math]::Round($size / 1gb - $free / 1gb)

$output = $remotecomputer + " | Disk Usage: " + $used + " GB"

$output
