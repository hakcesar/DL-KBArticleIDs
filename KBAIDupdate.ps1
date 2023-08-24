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


# Install NuGet using PackageManagement
Install-PackageProvider -Name NuGet -Force
Write-Host "NuGet provider installed."

# Install PSWindowsUpdate module using NuGet provider
Install-Module -Name PSWindowsUpdate -Force
Write-Host "PSWindowsUpdate module installed."

# Import PSWindowsUpdate module
Import-Module PSWindowsUpdate

# Request available updates
Get-WUList | Format-Table ComputerName, Status, KB, Size, Title

# Get the list of available updates
$updates = Get-WUList

# Prompt the user to select an update
Write-Host "Please select an update to download and install:"
$selectedUpdate = Read-Host

# Download and install the selected update
Install-WUUpdate -KBArticleID $selectedUpdate
