# Not working for the moment. Nest step in Part 3

# Array1 CSV

$array1 = import-csv -path C:\Users\test\OneDrive\Script\Merge-Array\fsrm_quota_report.txt

[string]$Array1Properties = "User"

# Array 2 CSV

$array2 = import-csv -path C:\Users\test\OneDrive\Script\Merge-Array\Exchange_MailBox_report.txt



function Merge-Array{

param(
       [string]$Array1,
       [string]$array1Property,
       [string]$Array2,
       [string]$array2Property,
       [switch]$Table,
       [string]$CSVPath

)

# Setup Data Source 1
[array]$array1_properties_list = $array1 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"}
$array1_properties_name = $array1_property_list.name | where-object {$_ -ne $Array1Property}


# Setup the datasource 2
[array]$array2_properties_list = $array2 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"} | Where-Object {$_.name -ne $Array2Property}
$array2_properties_name = $array2_properties_list.name | where-object {$_ -ne $Array2Property}

$final_array = @()
$final_array = foreach($A1 in $array1){
                                        
                                        # Create Ps Object
                                        $obj = New-Object PSObject
                                          
                                        $primary_property_array1 = $A1."$Array1Properties"
                                        $Array1_pro_1_PrimaryKey = $primary_property_array1

                                                                foreach($propname in $array1_properties_name){

                                                                                                                New-Variable -Name "Array1_pro_$propname" -Value $A1."$propname" -force

                                                                                                               }
                

                                                                foreach($A2 in $array2){

                                                                                        $primary_property_array2 = $A2."$Array2Properties"

                                                                                       

                                                                                        if($primary_property_array2-eq $primary_property_array1 ){

                                                                                        foreach($propname in $array2_properties_name){

                                   
                                                                                                                                        New-Variable -Name "Array2_pro_$propname" -Value $A2."$propname" -Force



                                                                                                                                        }

                                                                                        $var_list = get-variable | where-object {$_.name -like "Array1_pro_*"}
                                                                                        $var_list += get-variable | where-object {$_.name -like "Array2_pro_*"} 

                                                                                        $var_list | foreach{
                                                                                                            $Properties_name = $_.Name
                                                                                                            $Properties_name = $Properties_name -replace "Array1_pro_",""
                                                                                                            $Properties_name = $Properties_name -replace "Array2_pro_"
                                                                                                            $Properties_value = $_.value
                                                                                                            # add property to the object
                                                                                                            $obj | Add-Member -type NoteProperty -Name $Properties_name -Value $Properties_value -force
                    
                                                                                                            }
                                                                                                                            $obj
                                                                                                                            $var_list | Remove-Variable

                                                                                                                }
                   }
                   
                   
                   }

# Export CSV
if ($CSVPath -ne ""){

$final_array | convertto-csv | convertfrom-csv | export-csv -Path $CSVPath -NoTypeInformation -Encoding UTF8

}

# Out-put final array in a table
if ($Table -eq $true){

$final_array | convertto-csv | convertfrom-csv | Format-Table

}

# Out-put Psobject
if ($Table -ne $true -and $CSVPath -eq ""){

$final_array | convertto-csv | convertfrom-csv

}






}

Merge-Array -Array1 $array1 -array1Property "User" -Array2 $array2 -array2Property "Samaccountname"
