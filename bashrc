#!/bin/bash

function xdots_setup() {
    # Make sure everything's clear
    xdots_teardown

    # Make symlinks to all conf_* directories in xdots
    for f in `ls -d $HOME/xdots/conf_* | sed 's/^.*conf_\(.*\)/\1/g' | sed 's/\/$//'`; do
	ln -s "$HOME/xdots/conf_$f" "$HOME/$f"
    done

    # Make sure this script is sourced on startup
    (echo; echo ". $HOME/xdots/bashrc #xdots_gen") >> "$HOME/.bashrc"

    source "$HOME/.bashrc"
}

function xdots_teardown() {
    # undo the effects of xdots_setup
    for f in `ls -d $HOME/xdots/conf_* | sed 's/^.*conf_\(.*\)/\1/g'`; do
	rm -rf "$HOME/$f"
    done
    sed -i 's/^.*#xdots_gen.*$//g' "$HOME/.bashrc"
}

function xdots_update {
    if [ -d "$HOME/xdots/.git" ]; then
	"You probably don't want to do that."
    else
	xdots_download_src="`cat $HOME/xdots/xdots_download`"
	xdots_teardown
	rm -r $HOME/xdots
	bash -c "$xdots_download_src"
    fi
}

if [ -d "$HOME/.bashrc.d" ]; then
  source "$HOME/.bashrc.d/util"

  # Place for random scripts
  PATH="$HOME/.scripts:$PATH"

  # Place for random bash code to be sourced
  source_dir_recursively "$HOME/.bashrc.d"
fi
