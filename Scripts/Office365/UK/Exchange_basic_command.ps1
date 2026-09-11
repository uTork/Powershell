Get-Mailbox -ResultSize unlimited # Перелічує всі поштові скриньки в клієнті
Get-DistributionGroup # Перелічує всі групи розсилки та групи безпеки з поштою в клієнті
Get-DistributionGroupMember -Identity "Sales" # Перелічує членів групи розсилки Sales

# Нижче корисна команда для пошуку псевдоніма, який важко знайти!
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
