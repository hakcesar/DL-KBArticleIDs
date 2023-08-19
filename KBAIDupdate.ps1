# KBAID UPDATE - PowerShell version 1.0

# Set console colors
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"
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


# Check if the user is running the script as administrator

$isAdmin = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Prompt user for admin credentials
    Start-Process powershell.exe "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    exit
}

# Install or update the PSWindowsUpdate module
Write-Host "Installing/Updating PSWindowsUpdate module and NuGet package provider..."
Install-PackageProvider -Name NuGet -Force

# Install the NuGet package provider
Install-PackageProvider -Name NuGet -Force
# NuGet is a package manager for software libraries used in various programming languages, 
# including PowerShell. It allows you to easily discover, install, and manage libraries,
# modules, and tools needed for development and automation. In this script, we're using the
# NuGet package provider to manage the installation of the PSWindowsUpdate module.
# Learn more about NuGet at: https://www.nuget.org/

# Install or update the PSWindowsUpdate module
Write-Host "Installing/Updating PSWindowsUpdate module..."
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate -Force
# The PSWindowsUpdate module is a PowerShell module that provides cmdlets to interact
# with the Windows Update service on Windows systems. It allows you to manage and install
# Windows updates from PowerShell scripts and commands. In this script, we're using the
# PSWindowsUpdate module to automate the installation of Windows updates. Learn more about
# the PSWindowsUpdate module at: https://www.powershellgallery.com/packages/PSWindowsUpdate/

# Run Get-WindowsUpdate to retrieve available updates
$availableUpdates = Get-WindowsUpdate

# Check if there are KB Article IDs available to download and install
if ($availableUpdates.Count -eq 0) {
    Write-Host "No KBArticleID(s) are available to download."
} else {
    Write-Host "The following KBArticleID(s) are available:"

    $colorizedOutput = $availableUpdates | ForEach-Object {
        $kbArticleID = "KB$($_.KBArticleID)" -replace "KB(\d+)", { Write-Host ("KB" + $matches[1]) -ForegroundColor Yellow -NoNewline; return ("KB" + $matches[1]) }
        "$($_.Title) ($kbArticleID)"
    }

    Write-Host $colorizedOutput

    # Extract KB Article Ids from the output
    $KBArticleIDs = $availableUpdates.KBArticleID

    # Confirm with the user if they want to install the updates
    $installChoice = Read-Host "Do you want to install these KBArticleIDs? (Y/N)"
    if ($installChoice -eq "Y") {
        Write-Host "Installing KBArticleID(s)..."
        $KBArticleIDs | ForEach-Object {
            Install-WindowsUpdate -KBArticleID $_
            Write-Host "Installed KB$_"
        }
        Write-Host "KBArticleID(s) installed."
    } else {
        Write-Host "KBArticleID(s) were not installed."
    }
}

