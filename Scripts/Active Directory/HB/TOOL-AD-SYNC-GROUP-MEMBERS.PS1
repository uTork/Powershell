function Sync-ADGroupMembers {
<#
.SYNOPSIS

הסקריפט נוצר כדי לסנכרן את חברי קבוצת domain users לקבוצת Active Directory אחרת.
הפונקציה משמשת במשימה מתוזמנת שרצה כל 15 דקות. כאשר משתמש מתווסף לקבוצת
"domain users" לדוגמה. המשתמש מסונכרן כאשר המשימה המתוזמנת רצה.

.DESCRIPTION
מסנכרן את חברי קבוצת המקור לקבוצת היעד. חברי הרמה הראשונה של קבוצת המקור בלבד.
.PARAMETER SOURCE
קבוצת מקור Active Directory
.PARAMETER DESTINATION
קבוצת יעד Active Directory
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

# חילוץ חברי קבוצת המקור למשתנה
$membres_source = Get-ADGroup $SOURCE | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}

if($membres_source -ne $null){

# חילוץ חברי היעד להשוואה
$membres_destination = Get-ADGroup $DESTINATION | Get-ADGroupMember | Where-Object {$_.objectClass -eq "user"}


if($membres_destination -ne $null){
                                    # השוואת קבוצות וחילוץ ההפרש בין המשתמשים
                                    $compare = (Compare-Object -ReferenceObject $membres_source -DifferenceObject $membres_destination | where-object {$_.sideindicator -eq "<="}).inputobject


                                    # הוספת משתמשי ההפרש ליעד
                                    foreach($membre in $compare){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }
                                    }else{
                                    
                                    # הוספת כל משתמשי המקור לקבוצת היעד
                                    foreach($membre in $membres_source){

                                    get-adgroup -Identity $DESTINATION | Add-ADGroupMember -Members $membre

                                    }

                                    }
                                    }
                                    }
