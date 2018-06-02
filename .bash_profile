#!/bin/bash

# Since .bash_profile overrides .profile, execute .profile when it exists.
if [ -f ~/.profile ]; then
    . ~/.profile
fi

# On macOS, shells are launched as login shells which makes bash skip executing
# .bashrc so execute it here:
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
