# Dotfiles and Development Environment 

WSL NixOs, Neovim, Zsh, Commandbox, Windows Terminal, Powershell, Cmd, VsCode. 

1. Install chocolatey and scoop
2. scoop install git
3. scoop bucket add extras
4. scoop install neovim
5. scoop install komorebi
6. Install zLocation (equivelant to zoxide)
   - `Install-Module ZLocation -Scope CurrentUser; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserAllHosts`
   - use `z` like you would `cd` and it will keep track of all your visited paths
1. install oh-my-posh, neovim
   - `choco install neovim oh-my-posh`
1. git clone this repo into ~\.dotfiles
2. `winget search Microsoft.PowerShell`
3. `winget install --id Microsoft.PowerShell.Preview --source winget`
4. Launch Windows Terminal
5. Add Powershell 7 profile and make it the default profile
6. Make the defaults profile "Run this profile as Administrator"
7. TODO: FIGURE OUT HOW TO LAUNCH Windows Terminal as managed window in Komorebi, by default it doesn't fall into the organized grid. I THINK BECAUSE komorebi.json is not set yet??????
1. Symlink the Powershell Config (aliases, oh-my-posh, zoxide)
   - New-Item -Path 'C:\Users\daniel.mejia\OneDrive - Psomas\Documents\PowerShell\Microsoft.PowerShell_profile.ps1' -ItemType SymbolicLink -Value 'C:\Users\daniel.mejia\.dotfiles\Microsoft.PowerShell_profile.ps1'
1. Symlink the WHKD Config (global keybindings)
   - New-Item -Path 'C:\Users\daniel.mejia\.config\whkdrc' -ItemType SymbolicLink -Value 'C:\Users\daniel.mejia\.dotfiles\whkdrc'
1. Install/Enable WSL 2 
2. Download installer from https://github.com/nix-community/NixOS-WSL
3. `wsl --import <name-your-os> .\NixOS\ nixos-wsl.tar.gz --version 2`
4. Use powershell alias `nup` to enter distro `wsl -d <name-your-os>`
5. Follow instructions from https://github.com/webmandman/nixos-wsl-starter
    - Original repo comes with lunarvim, remove from home.nix config. 
6. 


## Powershell

-- .dotfiles/Microsoft.Powershell_profile.ps1

This config files contains powershell aliases, oh-my-posh prompt, and zoxide (which has issues remembering my directories)



-----------------------------------------------------------------
Everything below this line is my old way of setting up my dev env 
-----------------------------------------------------------------

# Development Environment Configuration

## Dotfiles

This folder will contain all configuration files for vscode, neovim, and commandbox, plus shell scripts to set shortcuts, aliases, commands.

**Commandbox**

1. * install script for commandbox bleeding edge
2. * download and set environment variables for Psomas
3. * run the recipe "essentials.boxr" 
	a. aliases
	b. install global packages:
		1. cfconfig
		2. dotenv
		3. hostupdater
		4. 
4. * install script for symbolic links 
	1. dotfiles/neovim/ -> ~/.../"neovim install path"
		a. 
	2. commandbox@latest -> ~/.Commandbox 
	3. development branch for commandbox -> ~/.Commandbox
5. Projects
	1. * install script for psomas command "potree"
	2. * install script for oh-my-bsh
	3. * install script for projectweb
	4. * install script for psomas tasks
	5. * install script for api
	6. * install script for intra
6. * install script for WSL2
7. * install script vscode extensions "code --install-extension ..."
	a. look into creating a bundle extension pack. 
8. 

## OS Support

* all configurations and scripts will support windows 10 and Ubuntu and MacOS, maybe even NixOS.


## Ubuntu (running total 50 mins)

** Install Ubuntu on WSL2 **

[Manual Install Docs](https://docs.microsoft.com/en-us/windows/wsl/install-manual) or

Any new installation will attempt to delete previous installations. Those files can not be in use - restart OS could do the trick.

1. Powershell script: `Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing`
2. Add-AppPackage .\Ubuntu.appx
3. Or double-click the .appx file and it will launch a gui installer.

** Apt Package Manager **

Update the packages list `sudo apt update` everytime before installing a new package or atleast once a day. Most popular packages update on a daily basis.

To reimage or wipe all data from Ubuntu image reset the app from Add/Remove Programs.

** Installing All Tools **

1. `sudo apt update` to update local packages list and endpoints.
2. `sudo apt install git-all`
3. `git clone https://github.com/webmandman/dotfiles`
4. `sudo apt-get install fonts-powerline`
5. `sudo apt install zsh`
6. `zsh --version`
7. `chsh -s $(which zsh)`
8. `git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh`
9. `ln -s ~/dotfiles/.zshrc ~/.zshrc`
10. `sudo apt install tmux`
11. `ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf`
12. `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
13.	`tmux source ~/.tmux.conf`
14. `export EDITOR="nvim"`
15. Install Neovim, then edit the git config(next step)
16. `git config -e`, and change url to  'https://username:passwordtoken@github.com....'

** Installing Commandbox **

Get avialable versions: `curl https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json`

TODO: create shell script, same logic as installcommandbox.ps1 in dotfiles. Follow this tutorial (Shell Scripting)[https://www.shellscript.sh/]. ETA: 1 day.

1. `curl -O https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.5.0-alpha/commandbox-bin-5.5.0-alpha.zip`
2. `unzip commandbox-bin-5.5.0-alpha.zip -d commandbox-be`
3. `sudo mv commandbox-be/box /usr/local/bin`
4. `sudo apt install openjdk-11-jdk`
	- 250bm+ with all dependencies

** Building Neovim Nightly **

(Building Neovim Docs)[https://github.com/neovim/neovim/wiki/Building-Neovim]

1. `sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen`
2. `git clone https://github.com/neovim/neovim`
3. `cd neovim`
4. `make CMAKE_BUILD_TYPE=Release`. 
	- Error 'rename failed - permission denied' - restarting Ubuntu should do it. 
	- Build Type Options: Release, Debug, RelWithDebInfo
	- Warning: Build Type was set as Release, however, :checkhealth says its Debug. Build command output shows this subcommand: `cd /home/udm/neovim/.deps && /usr/bin/cmake -E touch .third-party && cd build && cmake -G 'Ninja' -DCMAKE_BUILD_TYPE=Release`
5. Verify: `./build/bin/nvim --version | grep ^Build`
6. Install: `make CMAKE_INSTALL_PREFIX=$HOME/local/nvim install`
7. Added to PATH via .zshrc(end of file)
	- Perhaps consider default install location (/usr/local/bin) and skip 'make INSTALL PREFIX'
8. Plug plugin manager: `sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
9. `ln -s -d ~/dotfiles/nvim ~/.config/nvim
10. startup neovim, and `:PlugInstall`, then finally restart neovim.

Updating Neovim

1. `make distclean` - deletes .deps and build
2. `git pull`
3. Continue with step 4 above.

** Useful commands **

1. PATH, remove entry from end of path: `PATH=$(echo "$PATH" | sed -e 's/:~\/local\/nvim\/bin$//')`
2. Symlink command format: ln -s TARGET LINK_NAME 
3.

# Windows #

** Useful Commands **

1. Symlink command format: `New-Item -Path C:\LinkDir -ItemType SymbolicLink -Value F:\RealDir`

** IIS SSL/TLS **

Scan computer to see current settings:

1. `choco install sslscan`
2. `sslscan <WEB_SERVER_IP>`

Make TLS Changes

1. `choco install iiscryptocli`
2. `iiscryptocli /backup servertlsbackup`
3. `iiscryptocli /template best`
4. restart computer




