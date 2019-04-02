################################################################################
################################################################################
####################### Création de dossier utilisateur ########################
################################################################################
########################################################################################################
### Description: La création de dossier est basé sur le nom d'utilisateur active directory de l'usager #
################ le dossier est alors créé à la racine du partage réseau et les permission NTFS sont   #
################ mise exlusivement pour l'usager.                                                      #
########################################################################################################
### Note: Le script dépend du module Active Directory et NTFSSecurity                                  #
########################################################################################################

### Nom du partage réseau ou l'on crée les dossiers utilisateurs. Les permisions doivent être configurer avant l'éxécution du script.
$partage = "\\server\data$\"

### Liste les usagers qui devient le nom du dossier dans le partage du serveur
$list_dossiers = (get-aduser -Filter * -Properties *).SamAccountName


### Boucle qui traite la liste, crée le dossier de l'usager et met les permissions ntfs sur le dossier de l'usager
foreach($dossier in $list_dossiers){

            ### creation du dossier
                ###dossier
                $dossier_path = $partage + $dossier
                ### Commande de création du dossier et validation des erreurs.
                try{New-Item -Path $dossier_path -ItemType container -ErrorAction Stop | Out-Null}catch{$value = "Le dossier $dossier n'a pas été créé. ERREUR";write-output $value}
                ### Mets le propriétaire NTFS sur le dossier
                Set-NTFSOwner -Account $dossier -Path $dossier_path
                ### Mets la permission FULL Controle à l'usager
                Add-NTFSAccess -Path $dossier_path -Account $dossier -AccessRights FullControl

}
