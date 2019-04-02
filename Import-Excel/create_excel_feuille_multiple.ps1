################################################################################
################################################################################
################################################################################
################################### EXCEL ######################################
################################################################################
################################################################################
################################################################################

### Dossiers
    
    $chiens_dossier = "c:\power\excel\chiens\" ### Chiens
    $chats_dossier = "c:\power\excel\chats\" ### Chats
    $oiseaux_dossier = "c:\power\excel\oiseaux\" ### Oiseaux
    $tamia_dossier = "c:\power\excel\oiseaux\" ### Tamia
    $vaches_dossier = "c:\power\excel\vaches\" ### Vache

### Les listes des fichiers contenue dans chaques dossiers.
        
    $chiens_liste = (Get-ChildItem -Path $chiens_dossier).FullName
    $chats_liste = (Get-ChildItem -Path $chats_dossier).FullName
    $oiseaux_liste = (Get-ChildItem -Path $oiseaux_dossier).FullName
    $tamia_liste = (Get-ChildItem -Path $tamia_dossier).FullName
    $vaches_liste = (Get-ChildItem -Path $vaches_dossier).FullName



### Creation de l'array chien pour la création du Excel

$array_chien = @()

    foreach($chien in $chiens_liste){

        $chien_property = Get-ItemProperty -path $chien
        $chien_photo_name = $chien_property.Name
        $chien_photo_grosseur = [math]::Round($chien_property.Length/1mb,2)
        $chien_photo_creation_date = $chien_property.CreationTime
        $chien_photo_dossier = $chien_property.Directory

        ### Creation des objets Powershell
        $obj_chien = New-Object PSObject
            
        Add-Member -InputObject $obj_chien -MemberType NoteProperty -Name "Nom du fichier" -Value $chien_photo_name -force
        Add-Member -InputObject $obj_chien -MemberType NoteProperty -Name "Taille(MB)" -Value $chien_photo_grosseur -force
        Add-Member -InputObject $obj_chien -MemberType NoteProperty -Name "Date" -Value $chien_photo_creation_date -force
        Add-Member -InputObject $obj_chien -MemberType NoteProperty -Name "Dossier" -Value $chien_photo_dossier -force

        ### Ajout des objet au tableau
        $array_chien += $obj_chien


    }

### Creation de l'array chat pour la création du Excel

$array_chat = @()

    foreach($chat in $chats_liste ){

        $chat_property = Get-ItemProperty -path $chat
        $chat_photo_name = $chat_property.Name
        $chat_photo_grosseur = [math]::Round($chat_property.Length/1mb,2)
        $chat_photo_creation_date = $chat_property.CreationTime
        $chat_photo_dossier = $chat_property.Directory

        ### Creation des objets Powershell
        $obj_chat = New-Object PSObject
            
        Add-Member -InputObject $obj_chat -MemberType NoteProperty -Name "Nom du fichier" -Value $chat_photo_name -force
        Add-Member -InputObject $obj_chat -MemberType NoteProperty -Name "Taille(MB)" -Value $chat_photo_grosseur -force
        Add-Member -InputObject $obj_chat -MemberType NoteProperty -Name "Date" -Value $chat_photo_creation_date -force
        Add-Member -InputObject $obj_chat -MemberType NoteProperty -Name "Dossier" -Value $chat_photo_dossier -force

        ### Ajout des objet au tableau
        $array_chat += $obj_chat


    }

### Creation de l'array oiseau pour la création du Excel

$array_oiseau = @()

    foreach($oiseau in $oiseaux_liste ){

        $oiseau_property = Get-ItemProperty -path $oiseau
        $oiseau_photo_name = $oiseau_property.Name
        $oiseau_photo_grosseur = [math]::Round($oiseau_property.Length/1mb,2)
        $oiseau_photo_creation_date = $oiseau_property.CreationTime
        $oiseau_photo_dossier = $oiseau_property.Directory

        ### Creation des objets Powershell
        $obj_oiseau = New-Object PSObject
            
        Add-Member -InputObject $obj_oiseau -MemberType NoteProperty -Name "Nom du fichier" -Value $oiseau_photo_name -force
        Add-Member -InputObject $obj_oiseau -MemberType NoteProperty -Name "Taille(MB)" -Value $oiseau_photo_grosseur -force
        Add-Member -InputObject $obj_oiseau -MemberType NoteProperty -Name "Date" -Value $oiseau_photo_creation_date -force
        Add-Member -InputObject $obj_oiseau -MemberType NoteProperty -Name "Dossier" -Value $oiseau_photo_dossier -force

        ### Ajout des objet au tableau
        $array_oiseau += $obj_oiseau


    }


### Creation de l'array tamia pour la création du Excel

$array_tamia = @()

    foreach($tamia in $tamia_liste){

        $tamia_property = Get-ItemProperty -path $tamia
        $tamia_photo_name = $oiseau_property.Name
        $tamia_photo_grosseur = [math]::Round($tamia_property.Length/1mb,2)
        $tamia_photo_creation_date = $tamia_property.CreationTime
        $tamia_photo_dossier = $tamia_property.Directory

        ### Creation des objets Powershell
        $obj_tamia = New-Object PSObject
            
        Add-Member -InputObject $obj_tamia -MemberType NoteProperty -Name "Nom du fichier" -Value $tamia_photo_name -force
        Add-Member -InputObject $obj_tamia -MemberType NoteProperty -Name "Taille(MB)" -Value $tamia_photo_grosseur -force
        Add-Member -InputObject $obj_tamia -MemberType NoteProperty -Name "Date" -Value $tamia_photo_creation_date -force
        Add-Member -InputObject $obj_tamia -MemberType NoteProperty -Name "Dossier" -Value $tamia_photo_dossier -force

        ### Ajout des objet au tableau
        $array_tamia += $obj_oiseau


    }



### Creation de l'array vache pour la création du Excel

$array_vache = @()

    foreach($vache in $vaches_liste){

        $vache_property = Get-ItemProperty -path $vache
        $vache_photo_name = $vache_property.Name
        $vache_photo_grosseur = [math]::Round($vache_property.Length/1mb,2)
        $vache_photo_creation_date = $vache_property.CreationTime
        $vache_photo_dossier = $vache_property.Directory

        ### Creation des objets Powershell
        $obj_vache = New-Object PSObject
            
        Add-Member -InputObject $obj_vache -MemberType NoteProperty -Name "Nom du fichier" -Value $vache_photo_name -force
        Add-Member -InputObject $obj_vache -MemberType NoteProperty -Name "Taille(MB)" -Value $vache_photo_grosseur -force
        Add-Member -InputObject $obj_vache -MemberType NoteProperty -Name "Date" -Value $vache_photo_creation_date -force
        Add-Member -InputObject $obj_vache -MemberType NoteProperty -Name "Dossier" -Value $vache_photo_dossier -force

        ### Ajout des objet au tableau
        $array_vache += $obj_vache


    }

### Fichier de sortit excel
$ichier_excel_final = "C:\power\excel\listes_animaux.xlsx"

### Transformation des tableaux en EXCEL dans le même fichier avec des feuilles différente.

$array_chien | Export-Excel -path $ichier_excel_final -WorksheetName "Chiens" -Append -AutoSize -FreezeFirstColumn -TableName "canin" -TableStyle Medium10
$array_chat | Export-Excel -path $ichier_excel_final -WorksheetName "Chats" -Append -AutoSize -FreezeFirstColumn -TableName "felin" -TableStyle Dark5
$array_oiseau | Export-Excel -path $ichier_excel_final -WorksheetName "Oiseaux" -Append -AutoSize -FreezeFirstColumn -TableName "coco" -TableStyle Light15
$array_tamia | Export-Excel -path $ichier_excel_final -WorksheetName "Tamia" -Append -AutoSize -FreezeFirstColumn -TableName "tamia" -TableStyle Light11
$array_vache | Export-Excel -path $ichier_excel_final -WorksheetName "Vache" -Append -AutoSize -FreezeFirstColumn -TableName "herbi" -TableStyle Medium10


