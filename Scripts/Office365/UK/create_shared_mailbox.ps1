# Створити спільну поштову скриньку

$mailboxName = "Grocery Staff Shared mailbox"
$mailboxAlias = "GSSM"
$smtpaddress = "$mailboxAlias@octavie.onmicrosoft.com"

# Створення поштової скриньки
New-Mailbox -Name $mailboxName -Alias $mailboxAlias -Shared -PrimarySMTPAddress $smtpaddress 

# Встановити квоти поштової скриньки
Set-Mailbox $mailboxAlias -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

# Користувач спільної поштової скриньки
$mailbox_users = @(
            "ABRAHAM.BROWN"
            "ABRAM.DAVIS"
            "ADAM.WILSON"
            "ADRIAN.THOMAS"
            "AHMAD.WHITE"
            )

# Встановити дозволи
$mailbox_users | foreach{Add-MailboxPermission $mailboxName -User $_ -AccessRights FullAccess -AutoMapping $true}
