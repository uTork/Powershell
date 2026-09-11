$unit = "ispowershell"

# Crear la unidad organizativa raíz
New-ADOrganizationalUnit -Name $unit

# Ruta para la nueva unidad organizativa de segundo nivel
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# Crear unidad organizativa de segundo nivel
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
