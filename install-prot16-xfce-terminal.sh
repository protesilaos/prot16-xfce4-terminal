#!/bin/sh

# Install the Prot16 colour schemes for Xfce4 terminal
# NOTE This script requires sudo privileges to copy files into the /usr/ directory
# NOTE The /usr/ directory makes the files available to all users

    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Set global variables
gh_repo="prot16-xfce4-terminal"
gh_desc="Prot16 themes"
temp_repo=/tmp/$gh_repo/$gh_repo-master

# Some colours for echo output
greenfg=`tput setaf 2`
bluefg=`tput setaf 4`
magentafg=`tput setaf 5`
colourreset=`tput sgr0`

# Retrieve the latest git archive
echo "${greenfg}=> Getting the latest version from GitHub ...${colourreset}"
wget -O "/tmp/$gh_repo.tar.gz" \
  https://github.com/protesilaos/$gh_repo/archive/master.tar.gz

# Decompress the archive
echo "${greenfg}=> Unpacking archive ...${colourreset}"

# Check if staging directory already exists
# NOTE this should only be the case if user attempts multiple installs
if [ -e "/tmp/$gh_repo" ]; then
    rm -rf /tmp/$gh_repo
fi

# Make staging directory
mkdir /tmp/$gh_repo
tar -xzf "/tmp/$gh_repo.tar.gz" -C /tmp/$gh_repo

# Delete existing prot16 repo
echo "${magentafg}=> Deleting any old instance of the $gh_desc ...${colourreset}"

# NOTE The `rm -f` option is for skipping non existing files
for item in $(ls ${temp_repo})
do
    if [ -e "$item" ]; then
        sudo rm -f /usr/share/xfce4/terminal/colorschemes/$item
        sudo rm -f $HOME/.local/share/xfce4/terminal/colorschemes/$item
    else
        echo "No old files to remove"
    fi
done

Prepare installation
echo "${greenfg}=> Installing ...${colourreset}"

for theme in $(ls ${temp_repo} | find ${temp_repo} -name '*.theme')
do
    sudo cp --no-preserve=mode,ownership -rf \
    $theme /usr/share/xfce4/terminal/colorschemes/
done

# Remove temporary setup
echo "${magentafg}=> Clearing cache ...${colourreset}"
rm -rf "/tmp/$gh_repo.tar.gz"
rm -rf "/tmp/$gh_repo-master"
echo "${greenfg}=> Done!${colourreset}"
echo "${bluefg}In an open Xfce4 Terminal, navigate to Preferences > Colours. The themes should be available in the Presets section.${colourreset}"
echo "${bluefg}For more about Prot16 see https://protesilaos.com/schemes${colourreset}"
