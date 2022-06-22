#Requires -RunAsAdministrator

## 
## set appropiate rights to run powershell commands and admin install rights
##
Set-ExecutionPolicy Bypass -Scope Process -Force; 

$box  = "C:\Development\Tools\Commandbox\box.exe"
$cmds = "config set command.aliases.git='!git';"
$cmds += "config set command.aliases.add='!git add --all';"
$cmds = $cmds + "config set command.aliases.commit='!git commit -m';"
$cmds = $cmds + "config set command.aliases.push='!git push';"
$cmds = $cmds + "config set command.aliases.pull='!git pull';"
$cmds = $cmds + "install commandbox-cfconfig, commandbox-dotenv, commandbox-hostupdater;"
#Invoke-Expression "$box recipe `"$cmds`""
echo "$box recipe `"$cmds`""
