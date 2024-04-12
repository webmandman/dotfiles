write-output '~\.dotfiles\Microsoft.Powershell_profile.ps1 loaded'

# Set-Alias play 'cd C:\Development\playground'
# Set-Alias intra 'cd C:\Development\Sites\psomas-intranet'
# Set-Alias api 'cd C:\Development\Sites\psomas-api'
# Set-Alias nup 'wsl -d NixOS'
# Set-Alias ndown 'wsl -t NixOS'

oh-my-posh init pwsh --config 'C:\Users\daniel.mejia\AppData\Local\Programs\oh-my-posh\themes\star.omp.json' | Invoke-Expression

# TODO: delete this application then remove this line
# $Env:KOMOREBI_CONFIG_HOME = 'C:\Users\LGUG2Z\.config\komorebi'

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Import-Module ZLocation

# Komorebi restart custom command
function kstart(){
  # $komorebi = Get-Process komorebi
  # Remove-Variable komorebi

  if ( (get-Process komorebi -ea silentlycontinue) -ne $null ) { 
    komorebic stop
    echo "komorebic stopped..."
  }

  komorebic start --whkd
  echo "komorebic started..."
}

# Open nvim to edit whkd hotkeys

function editkeys(){
  nvim "$env:USERPROFILE\.config\whkdrc"
}

function editnvim(){
  nvim "$env:USERPROFILE\AppData\Local\nvim\init.lua"
}

function editdotfiles(){
  nvim "$env:USERPROFILE\.dotfiles\README.md" +"au UIEnter * ++once :Telescope find_files"
}

function keys(){
  $keysasciipath = "$env:USERPROFILE\.dotfiles\keysascii.txt"
  Get-Content -raw $keysasciipath | Write-Host
}
