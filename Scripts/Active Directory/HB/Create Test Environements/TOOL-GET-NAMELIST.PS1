function Get-NameList{
<#
.SYNOPSIS

פונקציה זו נוצרה ליצירת סביבת בדיקה של Active Directory. היא יכולה ליצור מיליוני משתמשים או פשוט מאה.
השמות מגיעים מאתר השמות http://names.mongabay.com

.DESCRIPTION
מחולל רשימת שמות

.PARAMETER NUMBER
מספר המשתמשים שברצונך ליצור

.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

[CmdletBinding()]

param(
      [string]$Number
     )



# אימות התקנת מודול ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #סוף אם המודול זמין אז ייבא
else { $false } #מודול לא זמין
} # סוף אם אין מודול
else { $true } #מודול כבר טעון
} 
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# קישורי שמות משפחה
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# קישורי שמות זכר
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# קישורי שמות נקבה
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# חילוץ טבלאות HTML עם הפקודה Get-HtmlTable ממודול ImportExcel
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# מספר המשתמשים מחולק ב-2. ליצירת מספר שווה של נשים וגברים
$number_divide = $number /2

# יצירת רשימת השמות
$name_list = @(
                1..$Number | foreach{
                    $surname = Get-Random $surname_list
                    $male = get-random $male_list
                    $female = get-random $female_list

                    if($_ -lt $number_divide){$name = $male}else{$name = $female}
                    
                    [pscustomobject]@{
                                      "Name" = $name
                                      "Surname" = $surname
                                     }

                    }
                )
# הצגת אובייקט ה-powershell
$name_list
}
