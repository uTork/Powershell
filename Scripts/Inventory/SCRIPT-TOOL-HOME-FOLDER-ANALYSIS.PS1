# File Server Analysis

# Needed Module
# install-module NTFSsecurity
# install-module PSFolder Size
# install-module active directory

$home1 = "\\serverfs6\f$\HOME"

$home_folder_path = get-childitem -Path $home1


$home_folder_path | foreach{
                            
                            $fullpath = $_.fullname
                            $name = $_.Name
                            $folder_size = try{Get-FolderSize -FolderName $name -BasePath $fullpath -ErrorAction Stop | select-object -ExpandProperty 'Size(GB)'}catch{$folder_size = "No Access"}
                            if($folder_size -eq $null){$folder_size = "0"}
                            $owner = try{(Get-NTFSOwner -Path $fullpath -ErrorAction Stop).owner}catch{$m = "NO ACCESS";$m}
                            $right = try{(Get-NTFSAccess -Path $fullpath -ErrorAction Stop).owner}catch{$m = "NO ACCESS";$m}
                            $ad = try{(get-aduser -identity $name -Properties * -ErrorAction Stop).name}catch{$m = "NOT IN AD";$m}
                            $last_modification = $_.LastWriteTime

                            [pscustomobject]@{
                                              
                                              Name = $name
                                              "Active Directory" = $ad
                                              Fullpath = $fullpath
                                              "Last Folder Modification" = $last_modification
                                              'Size(GB)' = $folder_size
                                              Owner = $owner
                                              NTFS = $right
                                             
                                             }


                            }
