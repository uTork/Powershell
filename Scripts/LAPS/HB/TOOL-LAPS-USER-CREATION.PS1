# סקריפט התחברות LAPS
# סקריפט זה הוא סקריפט התחברות ליצירת משתמש Admin עבור LAPS
# ה-GPO מונע יצירת משתמש עם סיסמה; הסקריפט יוצר את המשתמש אם אינו קיים במחשב
# יש להוסיף סקריפט זה ל-GPO כסקריפט התחברות
# הסיסמה משתנה על ידי שירות LAPS לאחר היצירה. הסיסמה זמנית.
# לאחר היצירה המשתמש מתווסף לקבוצת המנהלים המקומית


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
