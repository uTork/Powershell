# Synchroniser AD avec Azure après une modification dans AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # Synchronisation delta

Start-ADSyncSyncCycle -PolicyType Initial # Synchronisation complète