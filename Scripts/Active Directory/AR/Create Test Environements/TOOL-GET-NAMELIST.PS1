function Get-NameList{
<#
.SYNOPSIS

تم إنشاء هذه الدالة لإنشاء بيئة اختبار Active Directory. يمكنها إنشاء ملايين المستخدمين أو ببساطة مائة.
تأتي الأسماء من موقع الأسماء http://names.mongabay.com

.DESCRIPTION
مولّد قائمة الأسماء

.PARAMETER NUMBER
عدد المستخدمين الذين تريد إنشاءهم

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



# التحقق من تثبيت وحدة ImportExcel
Function Get-MyModule{
Param([string]$name)
if(-not(Get-Module -name $name))
{
if(Get-Module -ListAvailable |
Where-Object { $_.name -eq $name })
{
Import-Module -Name $name
$true
} #نهاية إذا كانت الوحدة متاحة ثم الاستيراد
else { $false } #الوحدة غير متاحة
} # نهاية إذا لم تكن هناك وحدة
else { $true } #الوحدة محمّلة بالفعل
} 
$message1 = "Install the ImportExcel module from Powershell Gallery............."
$importexcel = get-mymodule -name "importexcel"
if($importexcel -eq $false){clear;write-output $message1;break}


# روابط ألقاب العائلة
$surname_link = @(
                  "http://names.mongabay.com/most_common_surnames.htm"
                  "http://names.mongabay.com/most_common_surnames1.htm"
                  "http://names.mongabay.com/most_common_surnames2.htm"
                  "http://names.mongabay.com/most_common_surnames5.htm"
                  "http://names.mongabay.com/most_common_surnames8.htm"
                  "http://names.mongabay.com/most_common_surnames12.htm"
                  "http://names.mongabay.com/most_common_surnames16.htm"
                  )

# روابط الأسماء الذكورية
$male_link = @(
               "http://names.mongabay.com/male_names.htm"
               "http://names.mongabay.com/male_names3.htm"
               "http://names.mongabay.com/male_names6.htm"
               "http://names.mongabay.com/male_names9.htm"
               )

# روابط الأسماء الأنثوية
$female_link = @(
                 "https://names.mongabay.com/female_names.htm"
                 "https://names.mongabay.com/female_names1.htm"
                 "https://names.mongabay.com/female_names2.htm"
                 "https://names.mongabay.com/female_names3.htm"
                 )


# استخراج جداول HTML بأمر Get-HtmlTable من وحدة ImportExcel
$surname_list = (@($surname_link |%{Get-HtmlTable -url $_})).surname
$male_list = (@($male_link |%{Get-HtmlTable -url $_})).name
$female_list = (@($female_link |%{Get-HtmlTable -url $_})).name


# عدد المستخدمين مقسوم على 2. لإنشاء نفس العدد من الإناث والذكور
$number_divide = $number /2

# إنشاء قائمة الأسماء
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
# عرض كائن powershell
$name_list
}
