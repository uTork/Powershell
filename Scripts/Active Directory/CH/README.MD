### TOOL-AD-SET-ADUSERTSPROFILE.PS1
此函数可将 Active Directory 组成员用户的终端服务器配置文件路径进行更改。此函数将用于计划任务。

### Reboot-Computer.PS1 (DEV)
根据 Active Directory 中的关键字重启服务器列表

### TOOL-AD-SYNC-GROUP-MEMBERS.PS1
此脚本用于将 domain users 组的成员同步到另一个 Active Directory 组。该函数用于每 15 分钟运行一次的计划任务。例如，当用户被添加到 "domain users" 组时，计划任务执行时会同步该用户。

### TOOL-AD-USER-INACTIVE.PS1 (DEV)
在 Active Directory 中搜索非活动用户

### TOOL-AD-REMOVE-DISABLED-USERS-FROM-ALL-GROUP.PS1
从所有 Active Directory 组中移除已禁用的用户。

### TOOL-AD-SET-COMPUTER-DESCRIPTION.PS1
从 Excel 工作表设置 Active Directory 中计算机对象的描述。

### TOOL-GPUPDATE-REMOTE.PS1
在 Active Directory 列出的远程计算机上静默运行 GPUPDATE。

### Batch_user_creation_basic
从 CSV 文件批量创建 Active Directory 用户。

### Create Test Environements
用于创建 Active Directory 测试环境的工具：组织单位、用户、组、主文件夹和姓名列表。
