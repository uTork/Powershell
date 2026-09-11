# Synchronise AD with Azure after a change in AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # Delta sync

Start-ADSyncSyncCycle -PolicyType Initial # Full Sync