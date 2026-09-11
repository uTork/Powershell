# AD の変更後に AD を Azure と同期

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # 差分同期

Start-ADSyncSyncCycle -PolicyType Initial # 完全同期