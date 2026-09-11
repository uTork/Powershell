Get-Mailbox -ResultSize unlimited # 列出租户中的所有邮箱
Get-DistributionGroup # 列出租户中的所有通讯组和启用邮件的安全组
Get-DistributionGroupMember -Identity "Sales" # 列出 Sales 通讯组中的成员

# 下面这条命令便于查找难以找到的别名！
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
