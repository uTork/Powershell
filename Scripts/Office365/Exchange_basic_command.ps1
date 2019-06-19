Get-Mailbox -ResultSize unlimited #Lists all the mailboxes in the tenant
Get-DistributionGroup #List all the distribution groups and mail-enabled security groups in the tenant
Get-DistributionGroupMember -Identity "Sales" #Lists the members within the sales Distribution group

#The following is a handy one for finding an alias that seems to keep eluding you!
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
