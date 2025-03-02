# PowerShell Script to Clean Up Unnecessary Files and Free Up Storage

# Run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    exit
}

Write-Host "Starting system cleanup..." -ForegroundColor Cyan

# Delete Temp Files
Write-Host "Cleaning temporary files..." -ForegroundColor Yellow
Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue

# Clear Recycle Bin
Write-Host "Emptying Recycle Bin..." -ForegroundColor Yellow
$RecycleBin = New-Object -ComObject Shell.Application
$RecycleBin.Namespace(10).Items() | ForEach-Object { $_.InvokeVerb("delete") }

# Delete Windows Update Cache
Write-Host "Cleaning Windows Update Cache..." -ForegroundColor Yellow
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue

# Delete Windows Error Logs
Write-Host "Cleaning Windows Error Logs..." -ForegroundColor Yellow
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*" -Force -Recurse -ErrorAction SilentlyContinue

# Clear Prefetch Files (Non-Critical)
Write-Host "Cleaning Prefetch files..." -ForegroundColor Yellow
Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue

# Disk Cleanup using Windows Storage Sense
Write-Host "Running Disk Cleanup..." -ForegroundColor Yellow
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait

Write-Host "System cleanup completed successfully!" -ForegroundColor Green
