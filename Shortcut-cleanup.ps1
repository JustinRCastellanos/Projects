﻿# Define directories where shortcuts might be located
$desktopFolder = [System.Environment]::GetFolderPath('Desktop')
$startMenuFolder = [System.Environment]::GetFolderPath('StartMenu')

# Combine directories into an array to check both locations
$directoriesToCheck = @($desktopFolder, $startMenuFolder)

# Get a list of all shortcut files (.lnk) in these directories
$shortcutFiles = Get-ChildItem -Path $directoriesToCheck -Recurse -Filter *.lnk

# Loop through each shortcut
foreach ($shortcut in $shortcutFiles) {
    try {
        # Get the target path of the shortcut
        $shortcutTarget = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcut.FullName).TargetPath
        
        # Check if the target file does not exist
        if (-not (Test-Path $shortcutTarget)) {
            Write-Host "Deleting shortcut: $($shortcut.FullName)"
            Remove-Item $shortcut.FullName -Force
        }
    } catch {
        Write-Host "Error processing shortcut: $($shortcut.FullName)"
    }
}