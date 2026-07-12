# Ensure that remote version on Onedrive has these two lines
# Use local version maintained by chezmoi in $HOME
#. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$MaximumHistoryCount = 10000
function gcir ()
{
    Get-ChildItem | Sort-Object -Property LastWriteTime | Select-Object -Last 15
}
function pmid_extract ()
{
    (Select-String 'PMID:\s*\d+' .\siru.txt -All).Matches.Value | Sort-Object -Unique
}
function pmid_count ()
{
    (Select-String 'PMID:\s*\d+' .\siru.txt -All).Matches.Value | Sort-Object -Unique | Measure-Object -Line
}
function ssho {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Target,

        [Parameter(Mandatory=$false)]
        [string]$User = "root"
    )

    # 1. Expand the user home directory path properly for Windows OpenSSH
    local:sshKey = "$env:USERPROFILE\.ssh\id_ed25519"

    # 2. Smart Target handling: If you just type a number (e.g., 1), 
    # it auto-completes to your travel router subnet 172.20.20.1
    if ($Target -match '^\d+$') {
        $Target = "172.20.20.$Target"
    }

    # 3. Check if an explicit username was passed (e.g., admin@192.168.1.1)
    if ($Target -contains "@") {
        $connectionString = $Target
    } else {
        $connectionString = "${User}@${Target}"
    }

    # 4. Execute the command clean and fast
    ssh -i $sshKey `
        -o StrictHostKeyChecking=no `
        -o UserKnownHostsFile=NUL `
        -o GSSAPIAuthentication=no `
        $connectionString
}

Import-Module PSFzf
# This line registers and activates the default keyboard integrations
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
