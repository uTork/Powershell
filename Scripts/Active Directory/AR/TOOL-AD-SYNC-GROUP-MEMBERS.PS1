function Sync-ADGroupMembers {
<#
.SYNOPSIS

تم إنشاء هذا البرنامج النصي لمزامنة أعضاء مجموعة domain users مع مجموعة Active Directory أخرى.
تُستخدم الدالة في مهمة مجدولة تعمل كل 15 دقيقة. عندما يُضاف مستخدم إلى مجموعة
"domain users" على سبيل المثال. تتم المزامنة عند تنفيذ المهمة المجدولة.

.DESCRIPTION
يزامن أعضاء المجموعة المصدر مع مجموعة الوجهة. أعضاء المستوى الأول من المجموعة المصدر فقط.
.PARAMETER SOURCE
مجموعة مصدر Active Directory
.PARAMETER DESTINATION
مجموعة وجهة Active Directory
.LINK
Sebastien Maltais
sebastien_maltais@hotmail.com
GIT: https://github.com/uTork/Powershell/
LinkedIn: https://www.linkedin.com/in/sebastienmaltais/
FaceBook: http://www.facebook.com/isPowerShell
#>

PARAM(
      [string]$SOURCE,
      [string]$DESTINATION
      )

# استخراج أعضاء المصدر إلى متغير
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# استخراج أعضاء الوجهة للمقارنة
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # مقارنة المجموعات والحصول على فرق المستخدمين
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # إضافة فرق المستخدمين إلى الوجهة
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # إضافة جميع مستخدمي المصدر إلى مجموعة الوجهة
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
