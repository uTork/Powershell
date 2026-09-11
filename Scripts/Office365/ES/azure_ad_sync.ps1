# Sincronizar AD con Azure tras un cambio en AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # Sincronización delta

Start-ADSyncSyncCycle -PolicyType Initial # Sincronización completa