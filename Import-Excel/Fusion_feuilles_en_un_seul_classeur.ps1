################################################################################
################################################################################
################################################################################
################################### EXCEL ######################################
################################################################################
################################################################################
################################################################################

#### Fusion de plusieurs feuilles en un seul classeur
###

### Classeur final
$classeur = "C:\power\Classeur.xlsx"

### Dossier contenant les feuilles excel
$dossier_des_feuilles = "C:\power\excel_feuilles\"

### Liste des fichiers excel avec le chemin complet
$list_feuilles_excel = (Get-ChildItem -Path $dossier_des_feuilles).FullName


### Traitement de chaques feuilles et ajout au classeur
foreach($feuilles in $list_feuilles_excel){

         ### Détecte le nom de la feuille
         $nom_de_la_feuille = (Get-ExcelsheetInfo -Path $feuilles).name

         ### Importe la feuille a jouté au classeur
         $import_de_la_feuille = Import-Excel -path $feuilles

         ### Format du classeur
        $style_tableau = "Medium9"
        $nom_du_tableau = $nom_de_la_feuille + "_table"

        ### ajout de la feuille au classeur
        $import_de_la_feuille | Export-Excel -Path $classeur -WorksheetName $nom_de_la_feuille -FreezeTopRow -AutoSize -TableStyle $style_tableau -TableName $nom_du_tableau


}