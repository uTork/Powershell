$unit = "ispowershell"

# ルート組織単位を作成
New-ADOrganizationalUnit -Name $unit

# 新しい第2レベルの組織単位のパス
$path = (Get-ADOrganizationalUnit -filter * | where-object {$_.name -eq "ispowershell"}).DistinguishedName

$ou_list = @(
            "Canada"
            "UK"
            "Israel"
            "liban"
            )

# 第2レベルの組織単位を作成
$ou_list | foreach{New-ADOrganizationalUnit -Name $_ -Path $path}
