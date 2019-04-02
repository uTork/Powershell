##########################################################################
##########################################################################
############################## NTFSSecurity ##############################
##########################################################################
##########################################################################

###################################################################################################################
### Description: Script de reprise après sinistre. Permet de remettre les permissions NTFS sur les dossier home   #
################ des utilisateurs. Le dossier utilisateur doit avoir le même nom que le nom d'utilisateur dans    # 
################ active directory. Le script prend le nom du dossier pour le convertir en nom d'utilisateur.      #
###################################################################################################################

### Dossier contenant les dossiers ou les fichiers
$dossier_a_restaurer = "c:\data\"

### Liste des dossiers à restaurer les permission NTFS.
$liste_dossiers = Get-ChildItem -path $dossier_a_restaurer 

### Boucle qui traite dossier par dossier dans la liste des dossiers 
foreach($dossier in $liste_dossiers){
    
    ### nom d'utilisateur extrait du nom du dossier
    $utilisateur =   $dossier.name
    ### Chemin complet du dossier 
    $dossier_path =  $dossier.fullname

    ### Ajoute l'utilisateur comme propriétaire de son dossier utilisateur
    Set-NTFSOwner -Account $utilisateur -Path $dossier_path

    ### Ajout de la permission FULL CONTROL a l'utlisateur
    Add-NTFSAccess –Account $utilisateur –path $dossier_path –AccessRights FullControl
}