write-output '~\.dotfiles\Microsoft.Powershell_profile.ps1 loaded'

# terminal prompt feature and themes
oh-my-posh init pwsh --config '~\.dotfiles\oh-my-posh.themes\velvet.omp.json' | Invoke-Expression

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
  # refresh display_index_preferences first so komorebi reads the current monitor layout
  kmonitors

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
  # Get monitor info straight from WMI so this works even when komorebi isn't running.
  # WmiMonitorID.InstanceName already matches komorebi's device_id casing exactly,
  # e.g. "DISPLAY\DELA27C\4&18a747&1&UID8263_0" -> "DELA27C-4&18a747&1&UID8263".
  try {
    $ids  = @(Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID -ErrorAction Stop)
    $conn = @(Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorConnectionParams -ErrorAction Stop)
  }
  catch {
    Write-Host "Error: Failed to query monitor information from WMI: $_" -ForegroundColor Red
    return
  }

  if ($ids.Count -eq 0) {
    Write-Host "Error: No active monitors found." -ForegroundColor Red
    return
  }

  # Map each monitor's InstanceName -> VideoOutputTechnology.
  # The internal/integrated laptop panel reports 0x80000000 (2147483648).
  $internalTech = 2147483648
  $techByInstance = @{}
  foreach ($c in $conn) { $techByInstance[$c.InstanceName] = $c.VideoOutputTechnology }

  $monitors = foreach ($id in $ids) {
    # Convert "DISPLAY\<hwid>\<instance>_0" -> "<hwid>-<instance>" (komorebi format).
    $parts = $id.InstanceName.Split([char]0x5C)   # split on backslash
    $tail  = $parts[2]
    $u     = $tail.LastIndexOf('_')
    if ($u -ge 0) { $tail = $tail.Substring(0, $u) }
    $deviceId = $parts[1] + '-' + $tail

    # Decode the EDID friendly name (array of UTF-16 code units, null-padded).
    $name = ($id.UserFriendlyName | Where-Object { $_ -ne 0 } | ForEach-Object { [char]$_ }) -join ''

    [pscustomobject]@{
      DeviceId   = $deviceId
      Name       = $name
      IsInternal = ($techByInstance[$id.InstanceName] -eq $internalTech)
    }
  }

  $laptop    = $monitors | Where-Object { $_.IsInternal } | Select-Object -First 1
  $externals = @($monitors | Where-Object { -not $_.IsInternal })

  $laptopDeviceId   = if ($laptop) { $laptop.DeviceId } else { $null }
  $externalDeviceId = if ($externals.Count -gt 0) { $externals[0].DeviceId } else { $null }

  # Display found monitors
  Write-Host "`nFound monitors:" -ForegroundColor Cyan
  foreach ($monitor in $monitors) {
    $type = if ($monitor.IsInternal) { "Laptop" } else { "External" }
    Write-Host "  $type - Device ID: $($monitor.DeviceId)" -ForegroundColor White
    Write-Host "      Name: $($monitor.Name)" -ForegroundColor Gray
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

function dirh(){
  Get-ChildItem -Force @args
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

function cc(){
  claude
}

function ccd(){
  claude --dangerously-skip-permissions
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
