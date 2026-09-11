$unit = "ispowershell"

# Créer l'unité d'organisation racine
New-ADOrganizationalUnit -Name $unit

# Chemin pour la nouvelle unité d'organisation de second niveau
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# Créer l'unité d'organisation de second niveau
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
