#!/bin/bash

osascript -e "set Volume 0" # Set volume to 0
date=$(date '+%Y-%m-%d')
appName=school-mac-setup

################################################################################
# Load Script Settings
################################################################################

if [ ! -f $HOME/.config/diwesser/school-mac-setup.conf ] ; then
    curl -sS -O \
        https://raw.githubusercontent.com/DIWesser/school-mac-setup/default.conf
    mkdir -p '$HOME/.config/diwesser/'
    mv default.conf ~/.config/diwesser/school-mac-setup.conf
fi
settings=$HOME/.config/diwesser/school-mac-setup.conf

# grep line for variable. Extracts everything between first and second ':'
# Trims whitspace from both ends.
# Regex matches start of line excluding whitespace.
    ############################################################################
    # Chrome Extensions
    ############################################################################
    chromeHttpsEverywhere=$(grep -iw '^\s*chromeHttpsEverywhere:' |
        $settings | cut -d: -f2 | xargs)
    chromeVimium=$(grep -iw '^\s*chromeVimium:' |
        $settings | cut -d: -f2 | xargs)
    chromeUblockOrigin=$(grep -iw '^\s*chromeUblockOrigin:' |
        $settings | cut -d: -f2 | xargs)
    chromeMercuryReader=$(grep -iw '^\s*chromeMercuryReader:' |
        $settings | cut -d: -f2 | xargs)
    chromeTabModifier=$(grep -iw '^\s*chromeTabModifier:' |
        $settings | cut -d: -f2 | xargs)
    chromeGrammarly=$(grep -iw '^\s*chromeGrammarly:' |
        $settings | cut -d: -f2 | xargs)
    chromeTransparentPixel=$(grep -iw '^\s*chromeTransparentPixel:' |
        $settings | cut -d: -f2 | xargs)
    chromeNewTabRedirect=$(grep -iw '^\s*chromeNewTabRedirect:' |
        $settings | cut -d: -f2 | xargs)

################################################################################
# Running Things
################################################################################

# Get Mac Dotfiles
    echo "Installing dotfiles"
    # .bash_profile
        curl -sS -O https://raw.githubusercontent.com/DIWesser/dotfiles/master/.bashrc
        mv .bashrc ~/.bash_profile
        echo ".bash_profile installed"
    # .vimrc
        curl -sS -O https://raw.githubusercontent.com/DIWesser/dotfiles/master/.vimrc
        mv .vimrc ~/.vimrc
        echo ".vimrc installed"

# Check if you have done this before
#if [[ ~/Library/Application\ Support/com.diwesser.school-mac-setup/lastrun >= $logDate ]] ; then
    # Install apps from thumb drive
    # iTerm

    # Install apps from websites
        echo "Installing iTerm2"
        # Get version number from homebrew
        itermVersion=$(curl -sS \
            https://raw.githubusercontent.com/caskroom/homebrew-cask/master/Casks/iterm2.rb |
            grep "version '" | cut -d "'" -f2 | tr "." _)
        # Download DMG
        curl -sS -o iTerm.zip -L https://iterm2.com/downloads/stable/iTerm2-$itermVersion.zip
        # Unzip
        unzip iTerm.zip
        # Copy to ~/Applications
        mv iTerm.app ~/Applications/iTerm.app
        # Remove DMG
        rm -r iTerm.zip
        echo "iTerm Installed"

    # KeePassXC
        echo "Installing KeePassXC"
        # Get version number from homebrew
        keepassxcVersion=$(curl -sS \
            https://raw.githubusercontent.com/caskroom/homebrew-cask/master/Casks/keepassxc.rb |
            grep "version " | cut -d "'" -f2)
        # Download DMG
        curl -sS -o KeePassXC.dmg -L \
            https://github.com/keepassxreboot/keepassxc/releases/download/$keepassxcVersion/KeePassXC-$keepassxcVersion.dmg
        # Mount DMG
        hdiutil mount KeePassXC.dmg
        # Copy to ~/Applications
        cp -r /Volumes/KeePassXC/KeePassXC.app ~/Applications/KeePassXC.app
        # Unmount DMG
        hdiutil unmount /Volumes/KeePassXC
        # Remove DMG
        rm KeePassXC.dmg
        echo KeePassXC Installed""

    # Typora
        echo "Installing Typora"
        # Download DMG
        curl -sS -O https://typora.io/download/Typora.dmg
        # Mount DMG
        hdiutil mount Typora.dmg
        # Copy ~/Applications
        cp -r /Volumes/Typora/Typora.app ~/Applications/Typora.app
        # Unmount Typora DMG
        hdiutil unmount /Volumes/Typora
        # Remove DMG
        rm Typora.dmg
        echo "Typora Installed"

    # Log run date
#    echo "$logDate" > ~/Library/Application\ Support/com.diwesser.school-mac-setup/lastrun
#fi
# Change default browser to Chrome

# Require password after sleep or screensaver
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

# Finder
    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Show all file extensions
    /usr/bin/defaults write com.apple.finder AppleShowAllExtensions -bool YES
    # Show/hide icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    # Default finder location
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
    #defaults write com.apple.finder NewWindowTargetPath -string "file://Volumes/TO\ GO/"

# Dock
    # Clear Dock
    defaults write com.apple.dock static-only -bool true
    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Maximize autodisplay/hide speed of Dock
    defaults write com.apple.dock autohide-time-modifier -int 0
    # Automatically hide and show the Menu Bar
    defaults write NSGlobalDomain _HIHideMenuBar -bool true
    # Dark Dock
    defaults write NSGlobalDomain AppleInterfaceStyle Dark

# Misc.
    # Use plain text mode for new TextEdit documents
    defaults write com.apple.TextEdit RichText -int 0
    # Open and save files as UTF-8 in TextEdit
    defaults write com.apple.TextEdit PlainTextEncoding -int 4
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

killall Dock
killall Finder

# Open extension web pages
    if [ -z "$chromeHttpsEverywhere" ] ; then                 # HTTPS Everywhere
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/gcbommkclmclpchllfjekcdonpmejbdp
    fi
    if [ -z "$chromeVimium" ] ; then                          # Vimium
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/dbepggeogbaibhgnhhndojpepiihcmeb
    fi
    if [ -z "$chromeUblockOrigin" ] ; then                    # uBlock Origin
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/cjpalhdlnbpafiamejdnhcphjbkeiagm
    if [ -z "$chromeMercuryReader" ]                          # Mercury Reader
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/oknpjjbmpnndlpmnhmekjpocelpnlfdi
    fi
    if [ -z "$chromeTabModifier" ]                            # Tab Modifier
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/hcbgadmbdkiilgpifjgcakjehmafcjai
    fi
    if [ -z "$chromeGrammarly" ]                              # Grammarly
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/kbfnbcaeplbcioakkpcpgfkobkghlhen
    fi
    if [ -z "$chromeTransparentPixel" ]                       # Transparent Pixel
        open -a "Google Chrome" \
        https://upload.wikimedia.org/wikipedia/commons/c/ca/1x1.png
    fi
    if [ -z "$chromeNewTabRedirect" ]                         # New Tab Redirect
        open -a "Google Chrome" \
        https://chrome.google.com/webstore/detail/icpgjfneehieebagbmdbhnlpiopdcmna
    fi

# Open Workspace
open /Volumes/To\ GO/DIW\ database.kdbx

# JOUR 2702
if [[ $(whoami) = dn* && $(date '+%A') == Monday ]] ; then
    class="JOUR 2701"
    classNotes="/Volumes/TO GO/$date $class.md"

    # Create and open notes
    touch "$classNotes" # make note file
    echo "$date  " >> "$classNotes"
    echo "$class  " >> "$classNotes"
    sleep 1 # Make sure new file will be found
    open -a Typora "$classNotes"
fi
# Computer Science
if [[ $(whoami) = w* ]] ; then
    open -a "iTerm"
    open -a "Google Chrome" https://dal.brightspace.com/d2l/login
fi

echo "Installation complete. Restart terminal windows to use .bash_profile."
