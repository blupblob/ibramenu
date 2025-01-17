#!/bin/bash

######################################################################
# Title   : IBRAMENU
# By      : DiscDuck
# License : General Public License GPL-3.0-or-later
# Another fine product brought to you by IBRACORP™
######################################################################

# Include ibrafunc for all the awesome functions
source /opt/ibracorp/ibramenu/ibrafunc.sh

# Functions

# Declare and fill the array
build_menu () {
  for file in *; do
    menu_choice=("${menu_choice[@]}" "$file")
  done
}

# Build and display Menu
menu_from_array () {
  declare -a menu_choice
  PS3="Enter 1-$#, B for going back up a level, I for Information or X for Exit: "
  select item
  do
    case $REPLY in
      x|X)
        echo "Exiting..."
        break
        ;;
      b|B)
        if [ "$PWD/" = $menu_entry_point ]
        then
          read -p "Already at Top Menu. Press any key to continue..."
          break
        else
          cd ..
          break
        fi
        ;;
      i|I)
        ibrainfo
        break
        ;;
      [1-$#])
        if [ "${item:0:7}" = "Submenu" ]
        then
          cd "$item/"
          break
        else
          execute_script
          break
        fi
        ;;
      *)
        echo "Not a valid choice"
        ;;
    esac
  done
}

# Execute the script from the folder
execute_script () {
  msgbox "$item"
  cd "$item"
  readme
  if [ $? = 0 ]
  then
    script_command="./$item.sh"
    "$script_command"
    read -p "Press any key to continue..."
  fi
  cd ..
}

# Define Variables
if [ $1 ]
then
  menu_entry_point="$1"
else
  menu_entry_point="/opt/ibracorp/ibramenu/MenuOptions/"
fi
cd "$menu_entry_point"

# Check Disclaimer
disclaimer

# Check Environment
environment_check

# IBRAMOTD
ibramotd

# Menu
until [ $REPLY = x ] || [ $REPLY = X ]; do
  ibralogo
  checkupdate
  unset menu_choice
  build_menu
  menu_from_array "${menu_choice[@]}"
done