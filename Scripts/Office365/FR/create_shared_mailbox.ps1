# Créer une boîte aux lettres partagée

$mailboxName = "Grocery Staff Shared mailbox"
$mailboxAlias = "GSSM"
$smtpaddress = "$mailboxAlias@octavie.onmicrosoft.com"

# Création de la boîte aux lettres
New-Mailbox -Name $mailboxName -Alias $mailboxAlias -Shared -PrimarySMTPAddress $smtpaddress 

# Définir les quotas de la boîte aux lettres
Set-Mailbox $mailboxAlias -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

# Utilisateur de la boîte aux lettres partagée
$mailbox_users = @(
            "ABRAHAM.BROWN"
            "ABRAM.DAVIS"
            "ADAM.WILSON"
            "ADRIAN.THOMAS"
            "AHMAD.WHITE"
            )

# Définir les permissions
$mailbox_users | foreach{Add-MailboxPermission $mailboxName -User $_ -AccessRights FullAccess -AutoMapping $true}
