# AD 变更后将 AD 与 Azure 同步

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # 增量同步

Start-ADSyncSyncCycle -PolicyType Initial # 完全同步