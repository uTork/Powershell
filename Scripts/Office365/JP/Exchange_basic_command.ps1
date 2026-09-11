Get-Mailbox -ResultSize unlimited # テナント内のすべてのメールボックスを一覧表示
Get-DistributionGroup # テナント内の配布グループとメール対応セキュリティグループをすべて一覧表示
Get-DistributionGroupMember -Identity "Sales" # Sales 配布グループのメンバーを一覧表示

# なかなか見つからないエイリアスを探すのに便利です！
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
