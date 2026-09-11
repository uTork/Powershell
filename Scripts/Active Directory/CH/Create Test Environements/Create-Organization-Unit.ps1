$unit = "ispowershell"

# 创建根组织单位
New-ADOrganizationalUnit -Name $unit

# 新的二级组织单位的路径
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# 创建二级组织单位
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
