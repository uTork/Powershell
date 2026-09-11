# Синхронізувати AD з Azure після зміни в AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # Дельта-синхронізація

Start-ADSyncSyncCycle -PolicyType Initial # Повна синхронізація