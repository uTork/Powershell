$unit = "ispowershell"

# Create the root organization unit
New-ADOrganizationalUnit -Name $unit

# Path for the new second level organization unit
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# Create second level Organization Unit
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
