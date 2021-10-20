##Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# comma separated list of packages to install
$Packages = 'git.install'

#Install Packages
ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

#Install Commandbox
$commandboxhome = "C:/Commandbox/"
$commandboxurl = "https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.4.2/commandbox-jre-win64-5.4.2.zip"
Invoke-WebRequest -Uri $commandboxurl -OutFile ($commandboxhome + "src.zip")
Expand-Archive -LiteralPath ($commandboxhome + "src.zip") -DestinationPath $commandboxhome -Force
Remove-Item ($commandboxhome + "src.zip")
$PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine")
$NEWPATH = $PATH + $commandbox 
[System.Environment]::SetEnvironmentVariable("PATH", $NEWPATH, "Machine")
"-commandbox_home=$commandboxhome" | Out-File ($commandboxhome + "commandbox.properties")

#Install Commandbox Dependencies
#TODO: Service Manager ?
C:\commandbox\box.exe install commandbox-cfconfig, commandbox-dotenv, commandbox-hostupdater

#Import config settings (cfconfig)
#TODO: How do you import settings if server has been started before
#cd E:\sites\intra.psomas.com 
#C:\commandbox\box.exe cfconfig import serverconfig.json
#cd E:\sites\api.psomas.com
#C:\commandbox\box.exe cfconfig import serverconfig.json

#Clone Intranet
git clone https://psomas@bitbucket.org/psomaswebteam/psomas-intranet.git E:\sites\intra.psomas.com

#Clone Api
git clone https://psomas@bitbucket.org/psomaswebteam/intranet-api.git E:\sites\api.psomas.com

#TODO: convert web.rewrites.xml server rules for undertow (native feature - predicate)

#TODO: load environment variales

#TODO: cfconfig import serverconfig.json

#TODO: passwords for DB datasources, 
# rotating db passwords? 

#Create/Start site via service manager
#service manager will use settings from server.json
cd E:\sites\intra.psomas.com
C:\commandbox\box.exe server start

cd E:\sites\api.psomas.com
C:\commandbox\box.exe server start

