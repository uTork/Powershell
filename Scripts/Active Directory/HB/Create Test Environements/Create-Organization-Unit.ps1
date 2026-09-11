$unit = "ispowershell"

# יצירת יחידה ארגונית שורשית
New-ADOrganizationalUnit -Name $unit

# נתיב ליחידה הארגונית החדשה ברמה השנייה
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# יצירת יחידה ארגונית ברמה השנייה
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
