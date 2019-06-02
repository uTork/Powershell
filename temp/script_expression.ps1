
$csv_import = import-csv -Path C:\Users\test\OneDrive\Script\CSV\list.txt


$property_list = ($csv_import | get-member | where-object {$_.MemberType -eq "NoteProperty"}).name

# Create the property for the select-object
$expression_list = $property_list | foreach{

                                            if($_ -eq "email"){$newname = "C_$_";$value = "@{expression={" + '$_.'  + $_ + '}; label="' + $newname + '"}';$value}
                                            if($_ -ne "email"){$value = "@{expression={" + '$_.' + $_ + '}; label="' + $_ + '"}';$value}
                        
                                            }

$expression_join = $expression_list -join ","

# not working as expected
$csv_import | Select-object $expression_join

#Working Without Variable
$csv_import | Select-object @{expression={$_.email}; label="C_email"},@{expression={$_.name}; label="name"}
 
