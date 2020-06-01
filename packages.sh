#!/usr/bin/env zsh
set -x

# Packages installed from Brew.
BREW_PACKAGES="
ack
aspell
broot
colordiff
colortail
coreutils
curl
dmg2img
dockutil
duti
exiftool
ext2fuse
ext4fuse
faac
faad2
fd
fdupes
ffmpeg
findutils
flac
fzf
ghostscript
git
git-delta
git-extras
gnu-sed
gnu-tar
gpg
graphviz
grc
grep
htop
httpie
id3v2
imagemagick
jnettop
jq
lame
legit
mozjpeg
neovim
ntfs-3g
openssh
openssl
optipng
osxutils
p7zip
pdftk-java
pinentry-mac
pngcrush
prettyping
pstree
python
rclone
recode
rename
ripgrep
rmlint
shellcheck
shntool
spoof-mac
ssh-copy-id
testdisk
tldr
tree
unrar
watch
webkit2png
wget
x264
youtube-dl
zsh
"

# Packages to install by the way of Brew's casks.
CASK_PACKAGES="
adguard
aerial
amethyst
balenaetcher
bisq
caldigit-thunderbolt-charging
caprine
dropbox
dupeguru
electrum
font-sourcecodepro-nerd-font
fork
ftdi-vcp-driver
gimp
google-drive-file-stream
iina
java
keybase
libreoffice
macdown
mullvadvpn
musicbrainz-picard
netnewswire
osxfuse
prey
signal
subsurface
telegram-desktop
tor-browser
transmission
zoomus
"

# Python packages to install from PyPi.
PYTHON_PACKAGES="
gmvault
jupyter
meta-package-manager
neovim
pgcli
poetry
pycodestyle
pydocstyle
pygments
pylint
pytest
pytest-cov
pytest-sugar
setuptools
tox
wheel
yapf
"
