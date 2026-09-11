$unit = "ispowershell"

# Створити кореневий організаційний підрозділ
New-ADOrganizationalUnit -Name $unit

# Шлях для нового організаційного підрозділу другого рівня
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# Створити організаційний підрозділ другого рівня
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
