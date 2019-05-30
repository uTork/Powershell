# Array1 CSV

$array1 = import-csv -path C:\Users\test\OneDrive\Script\Merge-Array\fsrm_quota_report.txt

[string]$Array1Property = "User"

# Array 2 CSV

$array2 = import-csv -path C:\Users\test\OneDrive\Script\Merge-Array\Exchange_MailBox_report.txt

$Array2Property = "Samaccountname"


[array]$array1_property_list = $array1 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"}
$array1_property_name = $array1_property_list.name | where-object {$_ -ne $Array1Property}


# Setup the datasource 2
[array]$array2_property_list = $array2 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"} | Where-Object {$_.name -ne $Array2Property}
$array2_property_name = $array2_property_list.name | where-object {$_ -ne $Array2Property}


foreach($A1 in $array1_property_list){
      
        $primary_property_array1 = $A1.$Array1Property

        foreach($propname in $array1_property_name){

                Set-Variable -Name "Array1_property_$propname" -Value $A1.$propname

                }
                

                    foreach($A2 in $array2_property_list){

                            $primary_property_array2 = $A2.$Array1Property

                                   foreach($propname in $array2_property_name){

                                    Set-Variable -Name "Array2_property_$propname" -Value $A2."$propname"

                                   }


                   }
                   } 
