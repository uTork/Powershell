##########################################################################
##########################################################################
############################## NTFSSecurity ##############################
##########################################################################
##########################################################################

### Dossier contenant les dossiers ou les fichiers
$dossier = "c:\data\"
$dossier_B = "C:\data\dossier_b"

### Liste des compte utilisateur ou groupe AD
$compte_ad_A = @("alec.wyatt","barrett.nunez")
$compte_ad_B = @("bob.graton","elvis.tremblay")

### Commande pour donner les droits MODIFY sur le dossier $dossier
Add-NTFSAccess –Path $dossier –Account $compte_ad_A –AccessRights Modify

### Commande pour donner les droits FULL CONTROL sur le dossier $dossier_B
Add-NTFSAccess –Path $dossier –Account $compte_ad_B –AccessRights FullControl