############################################################################
############################################################################
################################# PSWATCH ##################################
############################################################################
############################################################################

#installation du module

### Telechargement à partir du repository du developpeur
iex ((new-object net.webclient).DownloadString("http://bit.ly/Install-PsWatch"))

### pour executer le module dans vos scripts. Vous devez importé le module au début du script.

Import-Module pswatch
