function  Compare-TwoArray{

param(
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [Array]$Array1,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [string]$Array1Property,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [Array]$Array2,
       [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] [string]$Array2Property
     )
<#
.SYNOPSIS
Compare Two array before merging with the command Merge-TwoArray
.DESCRIPTION
The script run in two phase.
1- Analyze primary property value and report not present value in each array.
2- Detect property conflict. You have to rename it before the merging. Two property with the same name cannot coexist in a merging scenario.
.PARAMETER Array1
The name of the first Array you want to compare
.PARAMETER Array1Property
The primary property of the Array1
.PARAMETER Array2
The name of the first Array you want to compare
.PARAMETER Array2Property
The primary property of the Array2
.EXAMPLE 
Compare two array
Merge-TwoArray -Array1 $array1 -array1Property "User" -Array2 $array2 -array2Property "Samaccountname"
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
#>

# Set the primary property variable
$array1PropertyList = $array1."$array1property"
$array2PropertyList = $array2."$array2property"

# Compare Value of the two primary key to find difference. The difference is ignored when merged with merge-twoarray
$compare_property_list = Compare-Object -ReferenceObject $array1PropertyList -DifferenceObject $array2PropertyList
# Sort the compare result by array order
$compare_property_list = $compare_property_list | Sort-Object -Property SideIndicator

clear
Write-Host
Write-Host
$message = "[Compare-TwoArray is Running]"
Write-Host $message -ForegroundColor Magenta
Write-Host
Write-Host
$message = "Launch: Primary property match: [Array1: $array1property] = [Array2: $array2property]"
Write-Host $message -ForegroundColor Green
$line = "--------------------------------------------------------------------------------------------------------------------------------"
Write-Host $line -ForegroundColor Green

# Extract primary property value different
$compare_property_list | foreach{
                                 $object_name = $_.InputObject
                                 $object_indicator = $_.sideindicator

                                 if($object_indicator -eq "<="){$message = "Array1: $object_name is not present in Array2 and will be ignored";Write-Host $message -ForegroundColor Green}
                                 if($object_indicator -eq "=>"){$message = "Array2: $object_name is not present in Array1 and will be ignored";Write-Host $message -ForegroundColor Green}
                                 }
Write-Host $line -ForegroundColor Green

# Create a list of all properties of the array and Exclude the primary property from this list
[array]$Array1propertieslist = ($array1 | get-member | Where-Object {$_.membertype -eq "noteproperty"} | Where-Object {$_.name -ne $array1property}).name
[array]$Array2propertieslist = ($array2 | get-member | Where-Object {$_.membertype -eq "noteproperty"} | Where-Object {$_.name -ne $array2property}).name

#Compare All Properties of the Array. Alert when conflict appear.
Write-Host
$message = "Launch: Properties conflict detection"
Write-Host $message -ForegroundColor Red
Write-Host $line -ForegroundColor Red

$compare_property_list = (Compare-Object -ReferenceObject $Array1propertieslist -DifferenceObject $Array2propertieslist -IncludeEqual | Where-Object {$_.SideIndicator -eq "=="}).InputObject

$compare_property_list | foreach{$message = "Error: The property $_ is in conflict. Rename it in one of the two array and run Compare-TwoArray again"
                                 write-host $message -ForegroundColor Red
                                 }

Write-Host $line -ForegroundColor Red
Write-Host
$message = "If you dont have any conflict Error. You can merge these array. Lets do it!"
Write-Host $message -ForegroundColor cyan
}

                                 
