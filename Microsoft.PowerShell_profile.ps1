write-output '~\.dotfiles\Microsoft.Powershell_profile.ps1 loaded'

# terminal prompt feature and themes
oh-my-posh init pwsh --config 'C:\Users\daniel.mejia\.dotfiles\oh-my-posh.themes\velvet.omp.json' | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# NOTE use z as you would the cd command. it remembers every folder you "cd" into and prioritizes by which folders you use more.
Import-Module ZLocation

# Komorebi stop 
function kstop(){
  komorebic stop --whkd

  Stop-Process -Name "komorebi-bar"
}
# Komorebi restart custom command
function kstart(){
  komorebic start --whkd
  
  $barconfigpath = "$env:USERPROFILE\.dotfiles\komorebi.bar.json"
  Start-Process -FilePath "komorebi-bar" -ArgumentList @(
    '--config',
    $barconfigpath
  ) -WindowStyle Hidden

  $laptopbarconfigpath = "$env:USERPROFILE\.dotfiles\komorebi.bar.laptop.json"
  Start-Process -FilePath "komorebi-bar" -ArgumentList @(
    '--config',
    $laptopbarconfigpath
  ) -WindowStyle Hidden

  echo "komorebic and whkd started...only run once after restarting pc, or make sure all processes for whkd and komorebic are stopped before starting up again. Use custom function 'kstop' in pwsh to stop both processes."
}

function kultra([int] $monitor = 0, [int] $workspace = 0) {
  komorebic workspace-layout $monitor $workspace ultrawide-vertical-stack
}

function kmonitors(){  
  # Get monitor information from komorebic
  try {
    $monitorInfoJson = komorebic monitor-information
    if (-not $monitorInfoJson) {
      Write-Host "Error: Failed to get monitor information from komorebic." -ForegroundColor Red
      return
    }
    $monitors = $monitorInfoJson | ConvertFrom-Json
  }
  catch {
    Write-Host "Error: Failed to get monitor information: $_" -ForegroundColor Red
    return
  }
  
  # First monitor in array is always the laptop
  $laptopMonitor = $monitors[0]
  $laptopDeviceId = $laptopMonitor.device_id
  
  # Second monitor (if exists) is the first external monitor
  $externalDeviceId = $null
  if ($monitors.Count -gt 1) {
    $externalMonitor = $monitors[1]
    $externalDeviceId = $externalMonitor.device_id
  }
  
  # Display found monitors
  Write-Host "`nFound monitors:" -ForegroundColor Cyan
  for ($i = 0; $i -lt $monitors.Count; $i++) {
    $monitor = $monitors[$i]
    $type = if ($i -eq 0) { "Laptop" } else { "External" }
    Write-Host "  [$i] $type - Device ID: $($monitor.device_id)" -ForegroundColor White
    Write-Host "      Name: $($monitor.name), Device: $($monitor.device)" -ForegroundColor Gray
  }
  
  # Show what will be set
  Write-Host "`nProposed changes to display_index_preferences:" -ForegroundColor Cyan
  if ($externalDeviceId) {
    Write-Host "  Index 0 (External): $externalDeviceId" -ForegroundColor Yellow
  } else {
    Write-Host "  Index 0 (External): <no external monitor found>" -ForegroundColor Yellow
  }
  Write-Host "  Index 1 (Laptop): $laptopDeviceId" -ForegroundColor Yellow
  
  # Ask for confirmation
  Write-Host "`nApply these changes? (Y/N): " -ForegroundColor Cyan -NoNewline
  $response = Read-Host
  
  if ($response -notmatch '^[Yy]') {
    Write-Host "Changes cancelled." -ForegroundColor Yellow
    return
  }
  
  # Read komorebi.json
  $configPath = "$env:USERPROFILE\.dotfiles\komorebi.json"
  $configContent = Get-Content -Path $configPath -Raw | ConvertFrom-Json
  
  # Update display_index_preferences
  if ($externalDeviceId) {
    $configContent.display_index_preferences."0" = $externalDeviceId
  }
  $configContent.display_index_preferences."1" = $laptopDeviceId
  
  # Write back to file with proper formatting
  $configContent | ConvertTo-Json -Depth 100 | Set-Content -Path $configPath
  
  Write-Host "`nSuccessfully updated display_index_preferences!" -ForegroundColor Green
  Write-Host "  0 (External): $externalDeviceId"
  Write-Host "  1 (Laptop): $laptopDeviceId"
}

function play(){
  cd C:\Development\Playground\
}

function sites(){
  cd C:\Development\Sites\
}

function api(){
  cd C:\Development\Sites\psomas-api 
}

function intra(){
  cd C:\Development\Sites\psomas-intranet 
}

function tools(){
  cd C:\Development\Tools\
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
  C:\Development\Tools\boxlang\jdk\21\bin\java.exe -jar C:\Development\Tools\boxlang\lib\boxlang-1.0.0-all.jar
}

function cftranspile {
  C:\Development\Tools\boxlang\jdk\21\bin\java.exe -cp C:\Development\Tools\boxlang\lib\boxlang-1.0.0-all.jar ortus.boxlang.compiler.CFTranspiler 
}

function Git-StatusWithDates {
    git status -s | ForEach-Object {
        # Use regex to extract mode and filename
        if ($_ -match '^(..)\s+(.+)$') {
            $mode = $matches[1].Trim()
            $file = $matches[2].Trim('"')  # remove quotes if present

            # Test if file exists and get date
            if (Test-Path $file) {
                $date = (Get-Item $file).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                Write-Output "$mode $date $file"
            } else {
                Write-Output "$mode <file not found> $file"
            }
        }
    }
}


$Env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.dotfiles"