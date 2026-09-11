$unit = "ispowershell"

# إنشاء الوحدة التنظيمية الجذرية
New-ADOrganizationalUnit -Name $unit

# المسار للوحدة التنظيمية الجديدة من المستوى الثاني
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# إنشاء وحدة تنظيمية من المستوى الثاني
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
