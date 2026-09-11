# Create shared mailbox

$mailboxName = "Grocery Staff Shared mailbox"
$mailboxAlias = "GSSM"
$smtpaddress = "$mailboxAlias@octavie.onmicrosoft.com"

# Mailbox Creation
New-Mailbox -Name $mailboxName -Alias $mailboxAlias -Shared -PrimarySMTPAddress $smtpaddress 

# Set the mailbox quotas
Set-Mailbox $mailboxAlias -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

# Shared Mailbox User
$mailbox_users = @(
            "ABRAHAM.BROWN"
            "ABRAM.DAVIS"
            "ADAM.WILSON"
            "ADRIAN.THOMAS"
            "AHMAD.WHITE"
            )

# Set the permission
$mailbox_users | foreach{Add-MailboxPermission $mailboxName -User $_ -AccessRights FullAccess -AutoMapping $true}
