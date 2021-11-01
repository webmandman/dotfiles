# set the version based on default or argument passed in
param ($v="latest")

if( $v -ne "latest" -and $v -ne "stable"){
	Write-Host $v + " is not an option. Only 'latest' or 'stable'"
	Exit 0
}

$type = "latestVersion"
if( $v -eq "stable" ){
	$type = $v + "Version"
}

# Get requested version number
$repoUrl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json"
$request = Invoke-WebRequest $repoUrl | ConvertFrom-Json
$query = $request | Select -expand versioning 
$version = $query.$type

Write-Host $version
