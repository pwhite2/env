#!/bin/bash

# Give the option to exit before overwriting ~/.aliases
if [ -f ~/.aliases ]; then
echo "~/.aliases already exists...."
read -r -p "Are you sure you want to OVERWRITE your ~/.aliases file? [y/N] " response
    case $response in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Exiting configuration script - environment has not been modified"
            exit 0
            ;;
    esac
fi

# Look into .rcrc file to see if it can abstract some of this stuf away...
DOTFILE_HOME=~/src/env/dotfiles
alias dotfiles='cd $DOTFILE_HOME'
alias lsrc='lsrc -d $DOTFILE_HOME'
alias mkrc='mkrc -d $DOTFILE_HOME'
alias rcdn='rcdn -d $DOTFILE_HOME'
alias rcup='rcup -d $DOTFILE_HOME'

# Replace grep with the silver searcher or ack-grep, if available...
AG=`ag --version`
ACK=`ack --version`
GREP=

if [[ -n "$AG" ]]; then
    GREP="ag"
elif [[ -n "$ACK" ]]; then
    GREP="ack --nogroup"
fi

if [[ -n "$GREP" ]]; then
    echo "# Alias grep depending on available options" > ~/.aliases
    echo "alias grep='$GREP'" >> ~/.aliases
    echo "" >> ~/.aliases
fi

# Create ~/.aliases with base platform-independent aliases
cat base_aliases git_aliases >> ~/.aliases

# TODO: Give the option to choose specific modules to include in ~/.aliases...
# Define platform-specific aliases...
if [[ `uname` == "Darwin" ]]; then
    echo "Configuring environment for Mac OS..."
    #rcup -tag base mac
    # FIXME: Warn user that we're about to clobber their ~/.aliases file and give them the option to abort
    cat mac_aliases >> ~/.aliases
elif [[ `uname` == "Linx" ]]; then
    echo "Configuring environment for Linux..."
    #rcup -tag base linux
    # FIXME: Warn user that we're about to clobber their ~/.aliases file and give them the option to abort
    cat linux_aliases >> ~/.aliases
else
    echo "Unknown OS, excluding OS-specific aliases..."
fi

# Define remaining non-OS-specific aliases...
# cat servio_aliases >> ~/.aliases
