# KBAID UPDATE - PowerShell version 1.0

# Set console colors
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

# Hi :)
$asciiArt = @"






  _  ______    _    ___ ____     _   _ ____  ____    _  _____ _____ 
 | |/ / __ )  / \  |_ _|  _ \   | | | |  _ \|  _ \  / \|_   _| ____|
 | ' /|  _ \ / _ \  | || | | |  | | | | |_) | | | |/ _ \ | | |  _|  
 | . \| |_) / ___ \ | || |_| |  | |_| |  __/| |_| / ___ \| | | |___ 
 |_|\_\____/_/   \_\___|____/    \___/|_|   |____/_/   \_\_| |_____|
                                                                    


                                                                        


                                                                 

                                                                
                                
"@
Write-Host $asciiArt
Write-Host "Author: hakcesar"
Write-Host "Blog: https://hakcesar.com"
Write-Host ""

# Check if the user has administrative privileges
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Requesting administrative privileges..."

    # Start a new instance of PowerShell with elevated privileges
    $params = @{
        FilePath = "powershell.exe"
        ArgumentList = "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`""
        Verb = "RunAs"
        PassThru = $true
    }
    $process = Start-Process @params

    if ($process) {
        Write-Host "Elevated process started."
    } else {
        Write-Host "Failed to start elevated process."
    }

    exit
}


# Install NuGet using PackageManagement and check for latest version
# NuGet is a package manager for software libraries in multiple languages, including PowerShell. 
# It simplifies library installation, management, and tools for development and automation. This script employs NuGet to install the PSWindowsUpdate module. 
# Learn more: https://www.nuget.org/
Install-PackageProvider -Name NuGet -Force
Write-Host " "
Write-Host "NuGet provider installed."
Write-Host " "

# Install PSWindowsUpdate module using NuGet provider and check for lateset version
# The PSWindowsUpdate module is a PowerShell module for Windows Update management. It offers cmdlets to handle updates via PowerShell. 
# This script automates Windows update installation using the PSWindowsUpdate module. Learn more: https://www.powershellgallery.com/packages/PSWindowsUpdate/
Install-Module -Name PSWindowsUpdate -Force -WarningAction SilentlyContinue
Write-Host "PSWindowsUpdate module installed."

# Import PSWindowsUpdate module
Import-Module PSWindowsUpdate

# Request available updates
Write-Host " "
Write-Host "Fetching available updates..."
Get-WindowsUpdate | Format-Table ComputerName, Status, KB, Size, Title

# Get the list of available updates
$updates = Get-WindowsUpdate

# Prompt the user to enter a KB#
Write-Host "Please enter a KB# to download and install, for multiple KB#s, add a comma and a space:"
$selectedUpdate = Read-Host

# Download and install the selected update
Write-Host " "
Write-Host "Installing $selectedUpdate..."
Get-WindowsUpdate -Install -AcceptAll -KBArticleID $selectedUpdate

# Prompt the user to restart the system
Write-Host " "
$restart = Read-Host "Do you want to restart your system now? (y/n)"

if ($restart -eq "y") {

    Restart-Computer

} else {

    Write-Host "Restart the system at your latest convenience to apply the updates."

}
