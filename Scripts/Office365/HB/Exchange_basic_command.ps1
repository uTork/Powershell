Get-Mailbox -ResultSize unlimited # מציג את כל תיבות הדואר בדייר
Get-DistributionGroup # מציג את כל קבוצות ההפצה וקבוצות האבטחה המופעלות לדוא"ל בדייר
Get-DistributionGroupMember -Identity "Sales" # מציג את החברים בקבוצת ההפצה Sales

# להלן פקודה שימושית לאיתור כינוי שנעלם מכם!
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
