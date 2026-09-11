Get-Mailbox -ResultSize unlimited # Liste toutes les boîtes aux lettres du locataire
Get-DistributionGroup # Liste tous les groupes de distribution et groupes de sécurité à messagerie du locataire
Get-DistributionGroupMember -Identity "Sales" # Liste les membres du groupe de distribution Sales

# Voici une commande pratique pour trouver un alias qui vous échappe !
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:me@peachtechnologies.co.uk'} | Format-List Identity, EmailAddresses
