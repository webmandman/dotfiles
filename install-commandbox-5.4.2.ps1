#Install Commandbox
$commandboxhome = "C:\Commandbox\"
mkdir $commandboxhome
$commandboxurl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.4.2/commandbox-jre-win64-5.4.2.zip"
$global:ProgressPreference = "silentlyContinue"
Invoke-WebRequest -Uri $commandboxurl -OutFile ($commandboxhome + "src.zip")
Expand-Archive -LiteralPath ($commandboxhome + "src.zip") -DestinationPath $commandboxhome -Force
$global:ProgressPreference = "Continue"
Remove-Item ($commandboxhome + "src.zip")
$PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")
$NEWPATH = $PATH + $commandbox 
[System.Environment]::SetEnvironmentVariable("PATH", $NEWPATH, "Machine")
"-commandbox_home=C:/Commandbox" | Out-File ($commandboxhome + "commandbox.properties")
