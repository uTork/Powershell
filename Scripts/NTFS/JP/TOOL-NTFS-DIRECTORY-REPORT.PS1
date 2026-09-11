# フォルダー一覧にリンクされた AD グループを Excel レポートに出力
# 必要なモジュール | NTFSSecurity | Import-Excel


$share = "\\Server\Share"
$report_file = "C:\report\report_folder.xlsx"

$folder_list = Get-ChildItem -Path $share -Directory


foreach($folder in $folder_list){

$folder_fullname = $folder.fullname
$worsheetname = $folder.name

Get-NTFSAccess -Path $folder_fullname | Select-Object Name,Account,AccessRights | Export-Excel -Path $report_file -WorksheetName $worsheetname -TableName $worsheetname -TableStyle Medium9 -AutoSize

}
