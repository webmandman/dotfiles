# this script must be run as Administrator
#
#
$repoUrl = 'https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json'
$request = Invoke-WebRequest $repoUrl | ConvertFrom-Json
$query = $request | Select -expand versioning | Select latestVersion
$latestVersion = $query[0].latestVersion

$url = 'https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/'+ $latestVersion +'/commandbox-jre-win64-'+ $latestVersion +'.zip'
$sha256 = 'a741f617ddddf50eba6bd78ba28caff867a676faac451e3428229054e1a473ff'
$dest = 'C:\users\daniel.mejia\downloads\box.zip'

$zipfile = 'C:\users\daniel.mejia\downloads\' + $(Split-Path -Path $url -Leaf)
# destination folder needs to exist.
# TODO: if folder does not exist then mkdir
# TODO: Choose a default installation folder or use environment variable
# or script argument that overrides default folder.
$extractpath = 'C:\users\daniel.mejia\downloads\commandbox-install\'

echo "Downloading..."
# without $progressPreference the download will actually take a lot longer. 
# set silentlyContinue to remove the progress bar which slows the download.
$global:ProgressPreference = 'silentlyContinue'
Invoke-WebRequest -Uri $url -OutFile $zipfile
echo "Done"
echo ""
echo "Opening and Extracting..."
Expand-Archive -LiteralPath $zipfile -Destinationpath $extractpath -Force
# reset back to Continue so that other commands use the default progress bar
$global:ProgressPreference = 'Continue'
echo "Done"

# TODO: create a uninstall script
#
# TODO: create install script for stable

$BEfolder = "C:\Development\Tools\Commandbox\BE"
$STABLEfolder = "C:\Development\Tools\Commandbox\STABLE"

# Get current path
$currentpath = [System.Environment]::GetEnvironmentVariable('PATH','Machine')
# Remove stable or be path
$editedpath = ($currentpath.Split(';') | 
	Where-Object { $_.trimEnd('\') -ne $STABLEfolder }) -join ';'

# Add stable or be path
$newpath = $editedpath + $BEfolder
[System.Environment]::SetEnvironmentVariable('PATH', $newpath, 'Machine')

