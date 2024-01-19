#Requires -RunAsAdministrator

## 
## set appropiate rights to run powershell commands and install rights
##
Set-ExecutionPolicy Bypass -Scope Process -Force; 

##
## Install Commandbox ########################################################
##

# set the version we want
# the ortus repo json has two options: latestVersion and stableVersion
$v = "stableVersion"

# set installation folder variables
$toolspath = "C:\Development\Tools\"
$installpath = $toolspath + "Commandbox\"
$downloadpath = $installpath + "downloads\"
$basezipurl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/"
# this json contains build updates and tells us which is latest stable
# or latest bleeding edge version
$repoUrl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json"

## Create the folders ##

# installation folder 
if( -Not (Test-Path -LiteralPath $installpath ){
	New-Item -Path $toolspath -Name "Commandbox" -ItemType "directory"
}
# Initial download folder
if( -Not (Test-Path -LiteralPath $downloadpath) ){
	New-Item -Path $installpath -Name "downloads" -ItemType "directory"
}


# Get requested version number and set full URL path
$request = Invoke-WebRequest $repoUrl | ConvertFrom-Json
$query = $request | Select -expand versioning 
$versionID = $query.$v
$zipfilename = "commandbox-jre-win64-" + $versionID + ".zip"
$downloadUrl = $basezipurl + $versionID + "/" + $zipfilename

## Start Commandbox Download ##
echo "Downloading..."
# without $progressPreference the download will actually take a lot longer. 
# set silentlyContinue to remove the progress bar which slows the download.
$global:ProgressPreference = "silentlyContinue"
# download zip to downloads folders
Invoke-WebRequest -Uri $downloadUrl -OutFile ($downloadpath + $zipfilename)

echo "Done" 
echo "$zipfilename" 
echo "Opening and Extracting..."

## Install Commandbox (unzip) ##
Expand-Archive -LiteralPath ($downloadpath + $zipfilename) -DestinationPath ($installpath + $v) -Force
# reset back to Continue so that other commands use the default progress bar
$global:ProgressPreference = "Continue"
echo "Done"

# TODO: Delete zip archive

## Edit PATH ##

# Get current PATH
$PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")

# set a previous version in order to know which one to remove from PATH
$previousVersion = $stableVer
if( $v -eq $stableVer){
	$previousVersion = $latestVer
}

# Remove previously set version from PATH
$editedpath = ($PATH.Split(";") | 
	Where-Object { $_.trimEnd("\") -ne ($installpath + $previousVersion) }) -join ";"

# Add stable or be path
$NEWPATH = $editedpath + $installpath + $v
[System.Environment]::SetEnvironmentVariable("PATH", $NEWPATH, "Machine")

##
## Install Commandbox Essentials #############################################
##

# set the box executable full path
$box  = $installpath + $v + "\box.exe"
# setup the recipe
$cmds = "config set command.aliases.git='!git';"
$cmds += "config set command.aliases.add='!git add --all';"
$cmds = $cmds + "config set command.aliases.commit='!git commit -m';"
$cmds = $cmds + "config set command.aliases.push='!git push';"
$cmds = $cmds + "config set command.aliases.pull='!git pull';"
$cmds = $cmds + "install commandbox-cfconfig, commandbox-dotenv, commandbox-hostupdater;"
# install essentials
Invoke-Expression "$box recipe $cmds"
