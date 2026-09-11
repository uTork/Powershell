Get-Mailbox -ResultSize unlimited # يسرد جميع صناديق البريد في المستأجر
Get-DistributionGroup # يسرد جميع مجموعات التوزيع ومجموعات الأمان الممكنة للبريد في المستأجر
Get-DistributionGroupMember -Identity "Sales" # يسرد أعضاء مجموعة التوزيع Sales

# فيما يلي أمر مفيد للعثور على اسم مستعار يصعب العثور عليه!
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
