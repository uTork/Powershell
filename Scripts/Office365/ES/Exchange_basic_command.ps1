Get-Mailbox -ResultSize unlimited # Enumera todos los buzones del inquilino
Get-DistributionGroup # Enumera todos los grupos de distribución y de seguridad con correo del inquilino
Get-DistributionGroupMember -Identity "Sales" # Enumera los miembros del grupo de distribución Sales

# Lo siguiente es útil para encontrar un alias que parece escapársele!
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
