#Requires -RunAsAdministrator

## set appropiate rights to run powershell commands and admin install rights
Set-ExecutionPolicy Bypass -Scope Process -Force; 

# set the version based on default or argument passed in
param ($v="latest")

$installpath = "C:\Development\Tools\Commandbox\"
$downloadpath = $installpath + "downloads\"
$basezipurl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/"
$repoUrl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json"

if( -Not (Test-Path -LiteralPath $downloadpath) ){
	New-Item -Path $installpath -Name "downloads" -ItemType "directory"
}
if( -Not (Test-Path -LiteralPath ($installpath + "stable") ) ){
	New-Item -Path $installpath -Name "stable" -ItemType "directory"
}
if( -Not (Test-Path -LiteralPath ($installpath + "latest") ) ){
	New-Item -Path $installpath -Name "latest" -ItemType "directory"
}

if( $v -ne "latest" -and $v -ne "stable"){
	Write-Host $v + " is not an option. Only 'latest' or 'stable'"
	Exit 0
}

$previous = "stable"
$type = "latestVersion"
if( $v -eq "stable" ){
	$previous = "latest"
	$type = $v + "Version"
}

# Get requested version number
$request = Invoke-WebRequest $repoUrl | ConvertFrom-Json
$query = $request | Select -expand versioning 
$version = $query.$type
$zipfilename = "commandbox-jre-win64-" + $version + ".zip"
$downloadUrl = $basezipurl + $version + "/" + $zipfilename

echo "Downloading..."
# without $progressPreference the download will actually take a lot longer. 
# set silentlyContinue to remove the progress bar which slows the download.
$global:ProgressPreference = "silentlyContinue"
Invoke-WebRequest -Uri $downloadUrl -OutFile ($downloadpath + $zipfilename)

echo "Done" 
echo "$zipfilename" 
echo "Opening and Extracting..."

Expand-Archive -LiteralPath ($downloadpath + $zipfilename) -DestinationPath ($installpath + $v) -Force
# reset back to Continue so that other commands use the default progress bar
$global:ProgressPreference = "Continue"
echo "Done"

