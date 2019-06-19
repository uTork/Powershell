# Synchronise the ad with azure after change in AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # Delta sync

Start-ADSyncSyncCycle -PolicyType Initial # Full Sync