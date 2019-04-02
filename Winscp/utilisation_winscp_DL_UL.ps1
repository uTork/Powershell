##################################################################
##################################################################
######################## WINSCP ##################################
##################################################################
##################################################################

### Date formatter pour le nom du fichier journaux
$date_log = (get-date).tostring("ddMMyyyy")

### Journaux/log de la session
$log = "c:\power\log_" + $date_log + ".txt"

### Dossier de telechargement
$download = "C:\power\download\"

### Dossier de televersement
$upload = "C:\power\upload\"

### Serveur SFTP
$srv = "192.168.174.134"

### Port de communication TCP/IP
$port = "22"

### Nom d'utilisateur et mot de passe
$utilisateur = "test"                                                                                              
$motdepasse = ConvertTo-SecureString "password" -AsPlainText -Force                                                 
$credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $utilisateur, $motdepasse

### Mode de connexion au FTP 
$ftpmode = "passive"

### Cle SHH d'encryption de l'hote -- Elle ce trouve trouve dans les propriétés de la connexion dans le GUI de  WINSCP
### SSHHOSTKEYFINGERPRINT
$sshkeyfingerprint = "ssh-ed25519 256 dXJkkP6V2VVmyfy1TxYQlbQsrhXbbayq/cws8jwMz2Q="

### Protocole utiliser SFTP
$protocole = "SFTP"


### Options session. Contient les informations de connexion
$session_options = New-WinSCPSessionOption -HostName $srv -Credential $credential -FtpMode $ftpmode -PortNumber $port -Protocol $protocole -SshHostKeyFingerprint $sshkeyfingerprint 

### Connexion active au serveur SFTP
$connexion = New-WinSCPSession -SessionOption $session_options -SessionLogPath $log


##################################################################
### Transfert les fichiers du dossier upload vers le serveur SFTP#
##################################################################

$liste_fichiers = (Get-ChildItem -path $upload -Recurse).fullname

foreach($fichier in $liste_fichiers){


Send-WinSCPItem -LocalPath $fichier -WinSCPSession $connexion


}

####################################################################
### Fin du transfert des fichiers vers le serveur FTP              #
####################################################################

####################################################################
### Téléchargement de fichiers à partir du serveur SFTP            #
####################################################################

$liste_telechargement = (Get-WinSCPChildItem -WinSCPSession $connexion).FullName

foreach($DL in $liste_telechargement){

Receive-WinSCPItem -RemotePath $DL -WinSCPSession $connexion -LocalPath $download

}

####################################################################
### FIN Téléchargement de fichiers à partir du serveur SFTP        #
####################################################################



### Fermeture de la connexion au serveur FTP
Remove-WinSCPSession $connexion