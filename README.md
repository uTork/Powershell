# ![logo][] PowerShell

##### Bienvenue sur mon GIT PowerShell 5.1
Powershell est un outil supérieur d'automatisation et de configuration multi-plates-formes (Windows, Linux et macOS) qui fonctionne bien avec vos outils existants. Il est optimisé pour traiter des données structurées (JSON, CSV, XML, etc.). 
[logo]: https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg?sanitize=true

#### Le GIT est consacré à des exemples de scripts powershell et d’utilisation de modules.

**Mon Wiki:** [Wiki PowerShell](https://github.com/uTork/PowerShell/wiki)

##### Exemples Modules: 
- Module Active Directory | *Utilisation du module dans différents contexte AD*
- Module Import-Excel | *Création de classeur à partir de sources de donnée, modification et fusion de documents excel.*
- Module Winscp       | *Commande SSH, Transfert par SFTP/FTP de fichiers etc....*
- Module Pswatch      | *Audit de dossier en temp réel. Rapporte la création,supression et modification des fichiers du dossier*
- Module NTFSSecurity | *Gestion des permissions sur le système de fichier NTFS*

##### Repository Microsoft: [ Powershell Gallery](https://www.powershellgallery.com/)

##### Exemples Scripts:
- Creation de dossier HOME(utilisateur) automatiquement basé sur le nom de l'utilisateur



### Télécharger PowerShell

Vous pouvez télécharger powershell pour n'importe laquelle platteforme.

| Supported Platform                         | Downloads (stable)      | Downloads (preview)   | How to Install                |
| -------------------------------------------| ------------------------| ----------------------| ------------------------------|
| [Windows (x64)][corefx-win]                | [.msi][rl-windows-64]   | [.msi][pv-windows-64] | [Instructions][in-windows]    |
| [Windows (x86)][corefx-win]                | [.msi][rl-windows-86]   | [.msi][pv-windows-86] | [Instructions][in-windows]    |
| [Ubuntu 18.04][corefx-linux]               | [.deb][rl-ubuntu18]     | [.deb][pv-ubuntu18]   | [Instructions][in-ubuntu18]   |
| [Ubuntu 16.04][corefx-linux]               | [.deb][rl-ubuntu16]     | [.deb][pv-ubuntu16]   | [Instructions][in-ubuntu16]   |
| [Ubuntu 14.04][corefx-linux]               | [.deb][rl-ubuntu14]     | [.deb][pv-ubuntu14]   | [Instructions][in-ubuntu14]   |
| [Debian 9][corefx-linux]                   | [.deb][rl-debian9]      | [.deb][pv-debian9]    | [Instructions][in-deb9]       |
| [CentOS 7][corefx-linux]                   | [.rpm][rl-centos]       | [.rpm][pv-centos]     | [Instructions][in-centos]     |
| [Red Hat Enterprise Linux 7][corefx-linux] | [.rpm][rl-centos]       | [.rpm][pv-centos]     | [Instructions][in-rhel7]      |
| [openSUSE 42.3][corefx-linux]              | [.rpm][rl-centos]       | [.rpm][pv-centos]     | [Instructions][in-opensuse]   |
| [Fedora 27, Fedora 28][corefx-linux]       | [.rpm][rl-centos]       | [.rpm][pv-centos]     | [Instructions][in-fedora]     |
| [macOS 10.12+][corefx-macos]               | [.pkg][rl-macos]        | [.pkg][pv-macos]      | [Instructions][in-macos]      |
| Docker                                     |                         |                       | [Instructions][in-docker]     |

You can download and install a PowerShell package for any of the following platforms, **which are supported by the community.**

| Platform                 | Downloads (stable)      | Downloads (preview)           | How to Install                |
| -------------------------| ------------------------| ----------------------------- | ------------------------------|
| Arch Linux               |                         |                               | [Instructions][in-archlinux]  |
| Kali Linux               | [.deb][rl-ubuntu16]     | [.deb][pv-ubuntu16]           | [Instructions][in-kali]       |
| Many Linux distributions | [Snapcraft][rl-snap]    | [Snapcraft][pv-snap]          |                               |

You can also download the PowerShell binary archives for Windows, macOS and Linux.

| Platform                            | Downloads (stable)                               | Downloads (preview)                             | How to Install                                 |
| ------------------------------------| ------------------------------------------------ | ------------------------------------------------| -----------------------------------------------|
| Windows                             | [32-bit][rl-winx86-zip]/[64-bit][rl-winx64-zip]  | [32-bit][pv-winx86-zip]/[64-bit][pv-winx64-zip] | [Instructions][in-windows-zip]                 |
| macOS                               | [64-bit][rl-macos-tar]                           | [64-bit][pv-macos-tar]                          | [Instructions][in-tar-macos]                   |
| Linux                               | [64-bit][rl-linux-tar]                           | [64-bit][pv-linux-tar]                          | [Instructions][in-tar-linux]                   |
| Windows (arm) **Experimental**      | [32-bit][rl-winarm]/[64-bit][rl-winarm64]        | [32-bit][pv-winarm]/[64-bit][pv-winarm64]       | [Instructions][in-arm]                         |
| Raspbian (Stretch) **Experimental** | [.tgz][rl-raspbian]                              | [32-bit][pv-arm32]/[64-bit][pv-arm64]           | [Instructions][in-raspbian]                    |

[rl-windows-64]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x64.msi
[rl-windows-86]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x86.msi
[rl-ubuntu18]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell_6.1.2-1.ubuntu.18.04_amd64.deb
[rl-ubuntu16]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell_6.1.2-1.ubuntu.16.04_amd64.deb
[rl-ubuntu14]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell_6.1.2-1.ubuntu.14.04_amd64.deb
[rl-debian9]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell_6.1.2-1.debian.9_amd64.deb
[rl-centos]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell-6.1.2-1.rhel.7.x86_64.rpm
[rl-macos]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell-6.1.2-osx-x64.pkg
[rl-winarm]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-arm32.zip
[rl-winarm64]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-arm64.zip
[rl-winx86-zip]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x86.zip
[rl-winx64-zip]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/PowerShell-6.1.2-win-x64.zip
[rl-macos-tar]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell-6.1.2-osx-x64.tar.gz
[rl-linux-tar]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell-6.1.2-linux-x64.tar.gz
[rl-raspbian]: https://github.com/PowerShell/PowerShell/releases/download/v6.1.2/powershell-6.1.2-linux-arm32.tar.gz
[rl-snap]: https://snapcraft.io/powershell

[pv-windows-64]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-x64.msi
[pv-windows-86]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-x86.msi
[pv-ubuntu18]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-preview_6.2.0-preview.4-1.ubuntu.18.04_amd64.deb
[pv-ubuntu16]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-preview_6.2.0-preview.4-1.ubuntu.16.04_amd64.deb
[pv-ubuntu14]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-preview_6.2.0-preview.4-1.ubuntu.14.04_amd64.deb
[pv-debian9]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-preview_6.2.0-preview.4-1.debian.9_amd64.deb
[pv-centos]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-preview-6.2.0_preview.4-1.rhel.7.x86_64.rpm
[pv-macos]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-6.2.0-preview.4-osx-x64.pkg
[pv-winarm]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-arm32.zip
[pv-winarm64]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-arm64.zip
[pv-winx86-zip]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-x86.zip
[pv-winx64-zip]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/PowerShell-6.2.0-preview.4-win-x64.zip
[pv-macos-tar]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-6.2.0-preview.4-osx-x64.tar.gz
[pv-linux-tar]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-6.2.0-preview.4-linux-x64.tar.gz
[pv-arm32]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-6.2.0-preview.4-linux-arm32.tar.gz
[pv-arm64]: https://github.com/PowerShell/PowerShell/releases/download/v6.2.0-preview.4/powershell-6.2.0-preview.4-linux-arm64.tar.gz
[pv-snap]: https://snapcraft.io/powershell-preview

[in-windows]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-windows?view=powershell-6
[in-ubuntu14]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1404
[in-ubuntu16]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1604
[in-ubuntu18]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#ubuntu-1804
[in-deb9]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#debian-9
[in-centos]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#centos-7
[in-rhel7]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#red-hat-enterprise-linux-rhel-7
[in-opensuse]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#opensuse
[in-fedora]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#fedora
[in-archlinux]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#arch-linux
[in-macos]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-macos?view=powershell-6
[in-docker]: https://github.com/PowerShell/PowerShell-Docker
[in-kali]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#kali
[in-windows-zip]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-windows?view=powershell-6#zip
[in-tar-linux]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#binary-archives
[in-tar-macos]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-macos?view=powershell-6#binary-archives
[in-raspbian]: https://docs.microsoft.com/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6#raspbian
[in-arm]: https://docs.microsoft.com/powershell/scripting/setup/powershell-core-on-arm?view=powershell-6
[corefx-win]:https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1-supported-os.md#windows
[corefx-linux]:https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1-supported-os.md#linux
[corefx-macos]:https://github.com/dotnet/core/blob/master/release-notes/2.1/2.1-supported-os.md#macos

To install a specific version, visit [releases](https://github.com/PowerShell/PowerShell/releases).
