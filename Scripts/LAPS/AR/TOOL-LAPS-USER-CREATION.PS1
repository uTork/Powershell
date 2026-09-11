# برنامج تسجيل الدخول LAPS
# هذا برنامج نصي لتسجيل الدخول لإنشاء مستخدم Admin لـ LAPS
# تمنع سياسة المجموعة إنشاء مستخدم بكلمة مرور؛ ينشئ هذا البرنامج المستخدم إن لم يكن موجودًا على الكمبيوتر
# يجب إضافة هذا البرنامج النصي إلى GPO كبرنامج تسجيل دخول
# يتم تغيير كلمة المرور بواسطة خدمة LAPS بعد الإنشاء. كلمة المرور مؤقتة.
# بعد الإنشاء يُضاف المستخدم إلى مجموعة المسؤولين المحلية


$LAPS_User = "AdminLAPS"

$password_text = "!/%/$?$%%?%?&FSDAFDFASFD"
$password = convertto-securestring $password_text -asplaintext -force
$local_user = get-localuser


if($local_user.name -notcontains $LAPS_User){

New-LocalUser -Name $LAPS_User -Password $password
Add-LocalGroupMember -Group "Administrators" -Member $LAPS_User

}
