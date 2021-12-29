# This script is to copy the local profile to a USB DRive
# You have to run it with Administrator privilege


$FoldersToCopy = @(
    'Desktop'
    'Favorites'
    'Documents'
    'Pictures'
    )

$FlashDrive = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType = 2' |
    Out-GridView -OutputMode Single -Title 'Select destination drive...'

$profile = Get-Childitem -Path "C:\users\" | Out-GridView -OutputMode Single -Title 'Select the user profile...'

$username = ($profile).name
$profile_path = ($profile).FullName

if( -not $FlashDrive ){
    Write-Warning 'No drive selected.'
    exit
    }

$save_folder = "$env:COMPUTERNAME\" + "$username"

$DestinationRoot = Join-Path -Path $FlashDrive.DeviceID -ChildPath $save_folder

foreach( $Folder in $FoldersToCopy ){
    $Source      = Join-Path -Path $profile_path -ChildPath $Folder
    $Destination = Join-Path -Path $DestinationRoot -ChildPath $Folder

    if( -not ( Test-Path -Path $Source -PathType Container ) ){
        Write-Warning "Could not find path`t$Source"
        continue
        }

    if( -not ( Test-Path -Path $Destination -PathType Container ) ){
        $null = New-Item -ItemType Directory -Path $Destination
        }

    Robocopy.exe $Source $Destination /E /IS /NP /NFL /R:1
    }
