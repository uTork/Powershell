function  Merge-TwoArray{

param(
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [Array]$Array1,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [string]$Array1Property,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [Array]$Array2,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [string]$Array2Property,
       [switch]$Table,
       [string]$CSVPath

)
<#
.SYNOPSIS
Merge Two Array into only one.
.DESCRIPTION
This is used to merge Two Array. Each array need to have a primary property to be join.(Ex: Username)
.PARAMETER Array1
The name of the first Array you want to merge
.PARAMETER $Array1Property
The primary property of the Array1
.PARAMETER Array2
The name of the first Array you want to merge
.PARAMETER $Array2Property
The primary property of the Array2
.PARAMETER Table
Output the result into a Table Format
.PARAMETER $CSVPath
The path of the CSV to export (Ex: "c:\power\csv.txt")
.EXAMPLE 
Merge two array from CSV file and output Final Array. The first array contain "USER" and the second Array "SAMACCOUNTNAME". 
The name is different but contain the same username(data).
Merge-TwoArray -Array1 $array1 -array1Property "User" -Array2 $array2 -array2Property "Samaccountname"
.EXAMPLE
Merge two array from CSV file and output Table Format
Merge-TwoArray -Array1 $array1 -array1Property "User" -Array2 $array2 -array2Property "Samaccountname" -Table
.EXAMPLE
Merge two array from CSV file and export to CSV
Merge-TwoArray -Array1 $array1 -array1Property "User" -Array2 $array2 -array2Property "Samaccountname" -CSVPath "C:\power\report.csv"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>


# Setup the datasource 1
[array]$array1_properties_list = $array1 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"}
$array1_properties_name = $array1_properties_list.name | where-object {$_ -ne $Array1Property}


# Setup the datasource 2
[array]$array2_properties_list = $array2 | Get-Member | Where-Object{$_.MemberType -eq "NoteProperty"} | Where-Object {$_.name -ne $Array2Property}
$array2_properties_name = $array2_properties_list.name | where-object {$_ -ne $Array2Property}

$final_array = @()
$final_array = foreach($A1 in $array1){
                                        
                                        # Create Ps Object
                                        $obj = New-Object PSObject
                                          
                                        $primary_property_array1 = $A1."$array1Property"

                                        # Primary Key 1 of the final Array
                                        $Array1_pro_1_PrimaryKey = $primary_property_array1
                                       
                                                                foreach($propname in $array1_properties_name){
                                                                                                                # Create variable of the Array1
                                                                                                                New-Variable -Name "Array1_pro_$propname" -Value $A1."$propname" -force

                                                                                                               }
                

                                                                foreach($A2 in $array2){

                                                                                        $primary_property_array2 = $A2."$array2Property"

                                                                                       

                                                                                        if($primary_property_array2 -eq $primary_property_array1 ){

                                                                                        foreach($propname in $array2_properties_name){
                                                                                                                                        # Create variable of the Array2
                                                                                                                                        New-Variable -Name "Array2_pro_$propname" -Value $A2."$propname" -Force

                                                                                                                                      }
                                                                                        
                                                                                        # Create Variable List from the two array
                                                                                        $var_list = get-variable | where-object {$_.name -like "Array1_pro_*"}
                                                                                        $var_list += get-variable | where-object {$_.name -like "Array2_pro_*"} 

                                                                                        # Create Object property from the variable list
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
