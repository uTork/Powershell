# 共有メールボックスの作成

$mailboxName = "Grocery Staff Shared mailbox"
$mailboxAlias = "GSSM"
$smtpaddress = "$mailboxAlias@octavie.onmicrosoft.com"

# メールボックスの作成
New-Mailbox -Name $mailboxName -Alias $mailboxAlias -Shared -PrimarySMTPAddress $smtpaddress 

# メールボックスのクォータを設定
Set-Mailbox $mailboxAlias -ProhibitSendReceiveQuota 5GB -ProhibitSendQuota 4.75GB -IssueWarningQuota 4.5GB

# 共有メールボックスのユーザー
$mailbox_users = @(
            "ABRAHAM.BROWN"
            "ABRAM.DAVIS"
            "ADAM.WILSON"
            "ADRIAN.THOMAS"
            "AHMAD.WHITE"
            )

# アクセス許可を設定
$mailbox_users | foreach{Add-MailboxPermission $mailboxName -User $_ -AccessRights FullAccess -AutoMapping $true}
