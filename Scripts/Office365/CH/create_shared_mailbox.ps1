# 创建共享邮箱

$mailboxName = "Grocery Staff Shared mailbox"
$mailboxAlias = "GSSM"
$smtpaddress = "$mailboxAlias@octavie.onmicrosoft.com"

# 邮箱创建
New-Mailbox -Name $mailboxName -Alias $mailboxAlias -Shared -PrimarySMTPAddress $smtpaddress 

# 设置邮箱配额
Set-Mailbox $mailboxAlias -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

# 共享邮箱用户
$mailbox_users = @(
            "ABRAHAM.BROWN"
            "ABRAM.DAVIS"
            "ADAM.WILSON"
            "ADRIAN.THOMAS"
            "AHMAD.WHITE"
            )

# 设置权限
$mailbox_users | foreach{Add-MailboxPermission $mailboxName -User $_ -AccessRights FullAccess -AutoMapping $true}
