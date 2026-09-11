# סנכרון AD עם Azure לאחר שינוי ב-AD

Import-Module ADSync

Start-ADSyncSyncCycle -PolicyType Delta # סנכרון דלתא

Start-ADSyncSyncCycle -PolicyType Initial # סנכרון מלא