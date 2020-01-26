#!/usr/bin/env bash
set -x

# Update all macOS packages
sudo softwareupdate -i -a

# Check if homebrew is already installed
# This also install xcode command line tools
if test ! "$(command -v brew)"
then
    # Install Homebrew without prompting for user confirmation.
    # See: https://github.com/Homebrew/install/pull/139
    CI=true ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew analytics off
brew update
brew upgrade

# Add Cask
brew tap caskroom/cask

# Add drivers.
brew tap caskroom/drivers

# Add services
brew tap homebrew/services

# Install Mac App Store CLI and upgrade all apps.
brew install mas
mas upgrade

# Install XQuartz to support Linux-based GUI Apps.
brew cask install xquartz

# Install common packages
for PACKAGE in $COMMON_SERVER_PACKAGES
do
   brew install "$PACKAGE"
done
for PACKAGE in $COMMON_DESKTOP_PACKAGES
do
   brew install "$PACKAGE"
done
brew install ack
brew install aspell
brew install curl
brew link --force curl
brew install dockutil
brew install exiftool
brew install faad2
brew install ffmpeg
brew install ghostscript
brew install mozjpeg
brew install openssl
brew install osxutils
brew install pinentry-mac
brew install prettyping
brew install pstree
brew install python
brew install rmlint
brew install rclone
brew install ssh-copy-id
brew install tldr
brew install watch
brew install webkit2png

# htop-osx requires root privileges to correctly display all running processes.
sudo chown root:wheel "$(brew --prefix)/bin/htop"
sudo chmod u+s "$(brew --prefix)/bin/htop"

# Install binary apps from homebrew.
for PACKAGE in $COMMON_BIN_PACKAGES
do
   brew cask install "$PACKAGE"
done
brew cask install adguard
brew cask install aerial
brew cask install balenaetcher
brew cask install bisq
brew cask install caldigit-thunderbolt-charging
brew cask install caprine
brew cask install dropbox
brew cask install dupeguru
brew cask install fork
brew cask install ftdi-vcp-driver
brew cask install gitup
brew cask install google-drive-file-stream
brew cask install iina
brew cask install java
brew cask install keybase
brew cask install libreoffice
brew cask install macdown
brew cask install musicbrainz-picard
brew cask install netnewswire
brew cask install spectacle
brew cask install telegram-desktop
brew cask install tor-browser
brew cask install transmission
brew cask install tunnelblick

# Remove Pages and GarageBand.
sudo rm -rf /Applications/GarageBand.app
sudo rm -rf /Applications/Pages.app

# Install Numbers and Keynotes
mas lucky "Keynote"
mas lucky "Numbers"

# Install 1Password.
mas lucky "1Password 7"
open -a "1Password 7"
# Activate Safari extention.
# Source: https://github.com/kdeldycke/kevin-deldycke-blog/blob/master/content/posts/macos-commands.md
pluginkit -e use -i com.agilebits.onepassword7.1PasswordSafariAppExtension

# Open apps so I'll not forget to login
open -a Dropbox
open -a adguard

# Install Spark.
mas lucky "Spark - Email App by Readdle"

# Install QuickLooks plugins
# Source: https://github.com/sindresorhus/quick-look-plugins
brew cask install epubquicklook
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlstephen
brew cask install qlvideo
brew cask install quicklook-json
brew cask install suspicious-package
qlmanage -r

# Install more recent versions of some macOS tools.
brew install gnu-tar
brew install gnu-sed
brew install grep
brew install openssh

# Add extra filesystem support.
brew cask install osxfuse
brew install ext2fuse
brew install ext4fuse
brew install ntfs-3g

# Install and configure Google Cloud Storage bucket mount point.
brew install gcsfuse
mkdir -p "${HOME}/gcs"
GOOGLE_APPLICATION_CREDENTIALS=~/.google-cloud-auth.json gcsfuse --implicit-dirs backup-imac-restic ./gcs
# Mount doesn't work as macOS doesn't let us register a new filesystem plugin.
# See: https://github.com/GoogleCloudPlatform/gcsfuse/issues/188
# sudo ln -s /usr/local/sbin/mount_gcsfuse /sbin/
# mount -t gcsfuse -o rw,user,keyfile="${HOME}/.google-cloud-auth.json" backup-imac-restic "${HOME}/gcs"

# Install restic for backups.
brew install restic

# Set Safari as the default browser.
brew install duti
duti -s com.apple.Safari http
# See: http://stackoverflow.com/a/25622557

# Install Popcorn Time.
rm -rf /Applications/Popcorn-Time.app
wget -O - "https://get.popcorntime.sh/repo/build/Popcorn-Time-0.3.10-Mac.zip" | tar -xz --directory /Applications -f -

# Install and configure bitbar.
brew cask install bitbar
defaults write com.matryer.BitBar pluginsDirectory "~/.bitbar"
wget -O "${HOME}/.bitbar/btc.17m.sh" https://github.com/matryer/bitbar-plugins/raw/master/Cryptocurrency/Bitcoin/bitstamp.net/last.10s.sh
sed -i "s/Bitstamp: /Ƀ/" "${HOME}/.bitbar/btc.17m.sh"
wget -O "${HOME}/.bitbar/disk.13m.sh" https://github.com/matryer/bitbar-plugins/raw/master/System/mdf.1m.sh
wget -O "${HOME}/.bitbar/meta_package_manager.7h.py" https://github.com/kdeldycke/meta-package-manager/raw/develop/meta_package_manager/bitbar/meta_package_manager.7h.py
wget -O "${HOME}/.bitbar/brew-services.7m.rb" https://github.com/matryer/bitbar-plugins/raw/master/Dev/Homebrew/brew-services.10m.rb
chmod +x ${HOME}/.bitbar/*.{sh,py,rb}
open -a BitBar

# Open Tor Browser once to create a default profile.
open --wait-apps -a "Tor Browser"
# Show TorBrowser bookmark toolbar.
TB_CONFIG_DIR=$(find "${HOME}/Library/Application Support/TorBrowser-Data/Browser" -maxdepth 1 -iname "*.default")
sed -i "s/\"PersonalToolbar\":{\"collapsed\":\"true\"}/\"PersonalToolbar\":{\"collapsed\":\"false\"}/" "$TB_CONFIG_DIR/xulstore.json"
# Set TorBrowser bookmarks in toolbar.
# Source: https://yro.slashdot.org/story/16/06/08/151245/kickasstorrents-enters-the-dark-web-adds-official-tor-address
BOOKMARKS="
http://piratebayztemzmv.onion,PirateBay,nnypemktnpya,dvzeeooowsgx
"
TB_BOOKMARK_DB="$TB_CONFIG_DIR/places.sqlite"
# Remove all bookmarks from the toolbar.
sqlite3 -echo -header -column "$TB_BOOKMARK_DB" "DELETE FROM moz_bookmarks WHERE parent=(SELECT id FROM moz_bookmarks WHERE guid='toolbar_____'); SELECT * FROM moz_bookmarks;"
# Add bookmarks one by one.
for BM_INFO in $BOOKMARKS
do
    BM_URL=$(echo $BM_INFO | cut -d',' -f1)
    BM_TITLE=$(echo $BM_INFO | cut -d',' -f2)
    BM_GUID1=$(echo $BM_INFO | cut -d',' -f3)
    BM_GUID2=$(echo $BM_INFO | cut -d',' -f4)
    sqlite3 -echo -header -column "$TB_BOOKMARK_DB" "INSERT OR REPLACE INTO moz_places(url, hidden, guid, foreign_count) VALUES('$BM_URL', 0, '$BM_GUID1', 1); INSERT OR REPLACE INTO moz_bookmarks(type, fk, parent, title, guid) VALUES(1, (SELECT id FROM moz_places WHERE guid='$BM_GUID1'), (SELECT id FROM moz_bookmarks WHERE guid='toolbar_____'), '$BM_TITLE', '$BM_GUID2');"
done
sqlite3 -echo -header -column "$TB_BOOKMARK_DB" "SELECT * FROM moz_bookmarks; SELECT * FROM moz_places;"

# Force installation of uBlock origin
wget https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi -O "$TB_CONFIG_DIR/extensions/uBlock0@raymondhill.net.xpi"

# Clean things up.
brew cleanup
brew services cleanup