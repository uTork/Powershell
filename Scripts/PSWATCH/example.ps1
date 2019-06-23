############################################################################
############################################################################
################################# PSWATCH ##################################
############################################################################
############################################################################

### Chargement du module PSWATCH
Import-Module pswatch

#### Surveillance du dossier C:\POWER sur mon disque C:. Cela permet d'auditer un dossier la creation,supression, modification de fichier dans un dossier.
watch -includeChanged -includeCreated -includeDeleted -includeRenamed -includeSubdirectories -location c:\power
