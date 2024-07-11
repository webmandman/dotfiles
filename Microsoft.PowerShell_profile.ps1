write-output '~\.dotfiles\Microsoft.Powershell_profile.ps1 loaded'

# terminal prompt feature and themes
oh-my-posh init pwsh --config 'C:\Users\daniel.mejia\AppData\Local\Programs\oh-my-posh\themes\star.omp.json' | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# NOTE No more set-alias used here since ZLocation module handles shortcuts for everything
Import-Module ZLocation

# Komorebi stop 
function kstop(){
  stop-process -name:whkd
  stop-process -name:whkd
  stop-process -name:komorebi
  stop-process -name:komorebi
}
# Komorebi restart custom command
function kstart(){
  komorebic start --whkd
  echo "komorebic and whkd started...only run once after restarting pc, or make sure all processes for whkd and komorebic are stopped before starting up again. Use custom function 'kstop' in pwsh to stop both processes."
}

function kultra([int] $monitor = 0, [int] $workspace = 0) {
  komorebic workspace-layout $monitor $workspace ultrawide-vertical-stack
}

function editdotfiles(){
  nvim "$env:USERPROFILE\.dotfiles\README.md" +"au UIEnter * ++once :Telescope find_files"
}

function keys(){
  $keysasciipath = "$env:USERPROFILE\.dotfiles\keysascii.txt"
  Get-Content -raw $keysasciipath | Write-Host
}

function gs(){
  git status
}

function gitc {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
  git status
  git add .
  git commit -a -m "$message"
  git push 
}

function bl {
  C:\Development\Tools\boxlang\jdk\jdk\bin\java.exe -jar C:\Development\Tools\boxlang\lib\boxlang-1.0.0-all.jar
}
