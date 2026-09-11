# مزامنة AD مع Azure بعد تغيير في AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # مزامنة دلتا

Start-ADSyncSyncCycle -PolicyType Initial # مزامنة كاملة