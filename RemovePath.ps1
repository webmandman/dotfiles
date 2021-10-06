
# Add install folder to PATH
$currentpath = [System.Environment]::GetEnvironmentVariable('PATH','Machine')
$BEpath = $currentpath + "C:\Development\Tools\Commandbox\BE"
$STABLEpath = $currentpath + "C:\Development\Tools\Commandbox\STABLE"
Write-Host $BEpath
# TODO: create script that will switch my 'box' PATH to stable or BE
$editedpath = ($currentpath.Split(';') | 
	Where-Object { $_.trimEnd('\') -ne 'C:\Program Files\Alacritty' }) -join ';'
Write-Host $editedpath

