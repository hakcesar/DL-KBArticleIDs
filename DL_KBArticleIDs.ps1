# Check if the user is running the script as administrator

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator"
    Exit
}

# Install or update the PSWindowsUpdate module
Write-Host "Installing/Updating PSWindowsUpdate module..."
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate -Force


# Run Get-WindowsUpdate to retrieve avaialable updates
$avaialableUpdates = Get-WindowsUpdate


# Check if there are KB Article IDs available to download and install
if ($avaialableUpdates.Count) -eq 0 {
    Write-Host "No KBArticleID(s) are available to download."
} else {
    Write-Host "The following KBArticleID(s) are available:"
    $avaialableUpdates | ForEach-Object {
        Write-Host "$($_.Title) (KB$($_.KBArticleID))"
    }

    #Extract KB Article Ids from the output
    $KBArticleIDs = $avaialableUpdates.KBArticleID

    # Confirm with the user if they want to install the updates
    $installChoice = Read-Host "Do you wnt to install these KBArticleIDs? (Y/N)"
    if ($installChoice -eq "Y") {
        Write-Host "Installing KBArticleID(s)..."
        $KBArticleIDs | ForEach-Object {
            Install-WindowsUpdate -KBArticleID $_
            Write-Host "Installed KB$_"
        }
        Write-Host "KBArticleID(s) installed."
    } else {
        Write-Host "KBArticleID(s) were not installed"
    }


}

