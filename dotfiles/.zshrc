###############################################################################
# Zinit
###############################################################################

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk


###############################################################################
# Zsh Parameters
###############################################################################
# Source: http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell

# Prefer US English and use UTF-8
LANG="en_US"
LC_ALL="en_US.UTF-8"

# Setting history length
HISTSIZE=999999
SAVEHIST=$HISTSIZE

# Make some commands not show up in history
HISTORY_IGNORE='(ls|ll|cd|cd ..|pwd|exit|date|history)'

# Get rid of extra empty space on the right.
# See: https://github.com/romkatv/powerlevel10k#extra-space-without-background-on-the-right-side-of-right-prompt
ZLE_RPROMPT_INDENT=0


###############################################################################
# Zsh Options
###############################################################################
# Source: http://zsh.sourceforge.net/Doc/Release/Options.html

## Changing Directories
# If a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

## Completion
setopt complete_in_word
# Whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

## Expansion and Globbing
# Make globbing (filename generation) un-sensitive to case.
# Bug: zsh-autosuggestions doesn't respect that parameter: https://github.com/zsh-users/zsh-autosuggestions/issues/239
unsetopt case_glob
# In order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob
# Lets files beginning with a . be matched without explicitly specifying the dot.
setopt glob_dots

## History
# Append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history
# Save each command's beginning timestamp and the duration to the history file.
setopt extended_history
# Expire duplicate entries first when trimming history.
setopt hist_expire_dups_first
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list.
setopt hist_ignore_all_dups
# Remove superfluous blanks before recording entry.
setopt hist_reduce_blanks
# Don't execute immediately upon history expansion.
setopt hist_verify
# Import new commands from the history file also in other zsh-session.
setopt share_history

## Input/Output
# Turns on spelling correction for all arguments.
setopt correct_all
# Turns on interactive comments; comments begin with a #.
setopt interactive_comments

## Job Control
# Display PID when suspending processes as well.
setopt long_list_jobs
# Report the status of backgrounds jobs immediately.
setopt notify

## Shell Emulation
# Use zsh style word splitting.
unsetopt sh_word_split

## Zle
# Avoid beeps and visual bells.
unsetopt beep


###############################################################################
# Zsh Plugins
###############################################################################
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light zdharma/zsh-diff-so-fancy

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


###############################################################################
# Prompt
###############################################################################
# Set user & root prompt
export SUDO_PS1='\[\e[31m\]\u\[\e[37m\]:\[\e[33m\]\w\[\e[31m\]\$\[\033[00m\] '

# Do not let homebrew send stats to Google Analytics.
# See: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md#opting-out
export HOMEBREW_NO_ANALYTICS=1


###############################################################################
# Neovim
###############################################################################
# Make Neovim the default editor
export EDITOR="nvim"

alias vim='nvim'
alias vi='nvim'
alias v="nvim"


###############################################################################
# Prepend paths pointing to recent utils from Brew.
###############################################################################
# Source: https://stackoverflow.com/a/9352979
path[1,0]=/usr/local/sbin
path[1,0]=$(brew --prefix coreutils)/libexec/gnubin
path[1,0]=$(brew --prefix grep)/libexec/gnubin
path[1,0]=$(brew --prefix findutils)/libexec/gnubin
path[1,0]=$(brew --prefix gnu-sed)/libexec/gnubin
path[1,0]=$(brew --prefix gnu-tar)/libexec/gnubin
path[1,0]=$(brew --prefix openssh)/bin
path[1,0]=$(brew --prefix curl)/bin
path[1,0]=$(brew --prefix python)/libexec/bin


###############################################################################
# Coloured output, aliases and good defaults.
###############################################################################

# Set default ls color schemes (source: https://github.com/seebi/dircolors-solarized/issues/10 ).
# macOS color translations generated with http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LSCOLORS="gxfxbEaEBxxEhEhBaDaCaD"

# Activate global dir colors if found.
alias dircolors='gdircolors'
if [ -f $HOME/.dircolors ]
then
    eval "$(dircolors -b $HOME/.dircolors)"
else
    eval "$(dircolors -b)"
fi

alias du='du -csh'
alias df='df -h'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff="colordiff -ru"
alias dmesg="dmesg --color"
alias tree='tree -Csh'
alias ccat='pygmentize -g'

alias top="htop"
alias gr='grep -RIi --no-messages'
alias g="git"
alias h="history"
alias q='exit'
alias how="howdoi --color"

function cls {
    # Source: https://stackoverflow.com/a/2198403
    osascript -e 'tell application "System Events" to keystroke "k" using command down'
}
alias c='cls'

# Use GRC for additionnal colorization
GRC=$(which grc)
if [ -n GRC ]; then
    alias colourify='$GRC -es --colour=auto'
    alias as='colourify as'
    #cvs
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias dig='colourify dig'
    alias g++='colourify g++'
    alias gas='colourify gas'
    alias gcc='colourify gcc'
    alias head='colourify head'
    alias ifconfig='colourify ifconfig'
    #irclog
    alias ld='colourify ld'
    #ldap
    #log
    alias ls='colourify ls'
    alias make='colourify make'
    alias mount='colourify mount'
    #mtr
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    #proftpd
    alias ps='colourify ps'
    alias tail='colourify tail'
    alias traceroute='colourify traceroute'
    #wdiff
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    lsflags="--color"
else # macOS `ls`
    lsflags="-G"
fi
alias ll='ls --human-readable --almost-all -l ${lsflags}'
alias ls='ls --human-readable --almost-all --indicator-style=slash ${lsflags}'

# Handy aliases for going up in a directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

export LESS="-eRX"
export LESSOPEN='| pygmentize -g %s'
# Tip from http://sourceforge.net/apps/trac/qlc/wiki/InstallationSubversionLinux#Optionalhelpers
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# Remove spurious find error messages on access restrictions. Keeps find's
# output clean, tidy and easier to read.
# Source: https://apple.stackexchange.com/a/353650
find() {
  { LC_ALL=C command find "$@" 3>&2 2>&1 1>&3 | \
    grep -v -e 'Permission denied' -e 'Operation not permitted' >&3; \
    [ $? = 1 ]; \
  } 3>&2 2>&1
}

# Extract most know archives with one command
extract () {
    if [ -f "$1" ]; then
        case "$1" in
            *.dmg)   hdiutil mount "$1"                ;;
            *.tar)   tar -xvf "$1"                     ;;
            *.zip)   unzip "$1"                        ;;
            *.ZIP)   unzip "$1"                        ;;
            *.pax)   pax -r < "$1"                     ;;
            *.pax.Z) uncompress "$1" --stdout | pax -r ;;
            *.rar)   unrar x "$1"                      ;;
            *.7z)    7z x "$1"                         ;;
            *.xar)   xar -xvf "$1"                     ;;
            *.pkg)   xar -xvf "$1"                     ;;
            # Rely on GNU's tar autodetection. List of recognized suffixes:
            # https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
            *)       tar -axvf "$1"                    ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Opens current directory in apps
alias f='open -a Finder ./'

# Replace netstat command on macOS to find ports used by apps
alias netstat="sudo lsof -i -P"

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Lock the screen
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# Link pinentry and GPG agent together
if test -f $HOME/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
    source $HOME/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --write-env-file $HOME/.gnupg/.gpg-agent-info)
fi


###############################################################################
# Python
###############################################################################

# Don't let Python produce .pyc or .pyo. Left-overs can produce strange side-effects.
export PYTHONDONTWRITEBYTECODE=true

# Python shell auto-completion and history.
export PYTHONSTARTUP="$HOME/.python_startup.py"

# Display DeprecationWarning
#export PYTHONWARNINGS=d

# Set virtualenv home.
export WORKON_HOME=$HOME/.virtualenvs

# Add pip completion.
eval "$(pip completion --zsh)"

# Add pipenv-pipes completion.
# Source: https://pipenv-pipes.readthedocs.io/en/latest/completions.html#bash-zsh
autoload bashcompinit && bashcompinit
_pipenv-pipes_completions() {
    COMPREPLY=($(compgen -W "$(pipes --_completion)" -- "${COMP_WORDS[1]}"))
}
complete -F _pipenv-pipes_completions pipes