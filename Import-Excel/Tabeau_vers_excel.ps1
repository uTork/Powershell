################################################################################
################################################################################
################################################################################
################################### EXCEL ######################################
################################################################################
################################################################################
################################################################################


### Creation de l'array
$array = @()

### MEt la variable à $null
$temp = $null

while($temp -lt "20"){

 ### Pondération de la variable à quaque passage dans la boucle.
 $temp = $count++

 ### Pause pour attendre le prochaine passage de la boucle
 Start-Sleep -Seconds 1

 ### Chargement des process de l'ordinateur en mémoire pour l'exemple
 $process_list = get-process

    ###loop des process
        foreach($process in $process_list){

            ### Creation des variables
            $proc_name = $process.processname
            $cpu = $process.TotalProcessorTime
            $mem = [math]::Round($process.VirtualMemorySize/1mb,2)


        
            ### Creation des objets Powershell
            $obj = New-Object PSObject
            
            Add-Member -InputObject $obj -MemberType NoteProperty -Name "Process Name" -Value $proc_name -force
            Add-Member -InputObject $obj -MemberType NoteProperty -Name "Temp processor" -Value $cpu -force
            Add-Member -InputObject $obj -MemberType NoteProperty -Name "Memoire(MB)" -Value $mem -force

            ### Ajout des objet au tableau
            $array += $obj

        }
}

### Fichier EXCEL
$fichier_excel  = "c:\power\excel_process.xlsx"

### Conversion du tableau en fichier excel.

$nom_de_la_feuille = "Process"
$style_tableau = "Medium9"
$nom_du_tableau = "process"
 
### Verse l'array dans le pipe vers import excel
$array | Export-Excel -Path $fichier_excel -WorksheetName $nom_de_la_feuille -FreezeTopRow -AutoSize -TableStyle $style_tableau -TableName $nom_du_tableau