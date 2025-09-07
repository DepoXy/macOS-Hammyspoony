#!/usr/bin/env bash
# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/macOS-Hammyspoony#🥄
# License: MIT

# Copyright (c) © 2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE: Apply these `defaults` changes so that Application drop-down
# menu items (that the user sees IRL) match the (GUI-less) Hammyspoony
# eventtap bindings set by init.lua.
#
# - REFER: This script is called from a DepoXy script of the same name:
#     https://github.com/DepoXy/depoxy/blob/release/bin/onboarder/slather-defaults.sh
#   Which is local if you have DepoXy installed:
#     ~/.depoxy/ambers/bin/onboarder/slather-defaults.sh

# SAVVY: Note you cannot add additional bindings here; these bindings
# only affect what macOS reports in the menu dropdowns.
#
# - REFER: Use 'accelerator-map' to change keyboard bindings
#
#     https://wiki.gnucash.org/wiki/Keyboard_Shortcuts
#
#   - You can add keybindings, or remap existing keybindings.
#
#   - MAYBE: We could port the Hammerspoon eventttap and remove
#     this `defaults` script if we used 'accelerator-map' instead.
#
#   - CXREF: See DepoXy changes, as well as default map that ships with the app:
#
#     ~/.depoxy/ambers/home/Library/Application Support/GnuCash/accelerator-map
#
#     /Applications/Gnucash.app/Contents/Resources/share/gnucash/ui/accelerator-map-osx

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# COPYD: From adjacent DepoXy project:
#   ~/.kit/mOS/macOS-onboarder/bin/slather-defaults.sh
CRUMB_APP_SHORTCUTS="Keyboard: Keyboard Shortcuts...: App Shortcuts"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

app_shortcuts_customize_gnucash() {
  app_shortcuts_customize_gnucash_menu_gnucash
  app_shortcuts_customize_gnucash_menu_file
  app_shortcuts_customize_gnucash_menu_edit
  app_shortcuts_customize_gnucash_menu_view
  app_shortcuts_customize_gnucash_menu_actions
  app_shortcuts_customize_gnucash_menu_business
  app_shortcuts_customize_gnucash_menu_reports
  app_shortcuts_customize_gnucash_menu_tools
  app_shortcuts_customize_gnucash_menu_windows
  app_shortcuts_customize_gnucash_menu_help

  app_shortcuts_customize_gnucash_all
}

# So weird they don't spell it "GnuCash" in the menus (or the appname, Gnucash.app).
app_shortcuts_customize_gnucash_menu_gnucash() {
  # ISOFF/2024-10-05: <Cmd-Q> is not *that* difficult to press (it's not as
  # annoying as, e.g., <Cmd-C>), and author is at least slowly relenting on
  # the <Cmd-Q> -> <Ctrl-Q> remapping.
  # - One issue is, while the author has similar cut-copy-paste remappings,
  #   e.g., <Cmd-C> -> <Ctrl-C>, those are done using Karabiner Elements and
  #   apply to all apps — so they never *don't* work.
  #   - The <Cmd-Q> -> <Ctrl-Q> remapping, on the other hand, is done for
  #     individual applications. And I don't always remember which apps
  #     don't have it. And sometimes a built-in app, or a new app, will run
  #     for some reason, and you'll have to press <Cmd-Q> anyway.
  #
  #  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Gnucash > Quit Gnucash”: Cmd-Q → Ctrl-Q"
  :
}

app_shortcuts_customize_gnucash_menu_file() {
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > New File”: Cmd-N → Ctrl-N"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Open...”: Cmd-O → Ctrl-O"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Save”: Cmd-S → Ctrl-S"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Save As...”: Shift-Cmd-S → Shift-Ctrl-S"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Print...”: Cmd-P → Ctrl-P"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Print Setup”: Shift-Cmd-P → Shift-Ctrl-P"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “File > Close”: Cmd-W → Ctrl-W"
}

app_shortcuts_customize_gnucash_menu_edit() {
  # Skip (set by KE): Cut, Copy, Paste
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Edit > Edit Account”: Cmd-E → Ctrl-E"
  # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Edit > Delete Account”: Backspace → ???"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Edit > Find Account”: Cmd-I → Ctrl-I"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Edit > Find...”: Cmd-F → Ctrl-F"
}

app_shortcuts_customize_gnucash_menu_view() {
  # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “View > Show All Tabs”: Shift-Cmd-\ → ???"
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “View > Refresh”: Cmd-R → Ctrl-R"
  # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “View > Enter Full Screen”: Globe-F → impossible!"
}

app_shortcuts_customize_gnucash_menu_actions() {
  echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Actions > Transfer...”: Cmd-T → Ctrl-T"
}

app_shortcuts_customize_gnucash_menu_business() {
  : # None
}

app_shortcuts_customize_gnucash_menu_reports() {
  : # None
}

app_shortcuts_customize_gnucash_menu_tools() {
  : # None
}

app_shortcuts_customize_gnucash_menu_windows() {
  : # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Windows > Show Previous Tab”: Shift-Ctrl-Right → ???"
  : # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Windows > Show Next Tab”: Ctrl-Right → ???"
}

app_shortcuts_customize_gnucash_menu_help() {
  : # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Help > Tutorial and Concepts Guide”: Ctrl-Cmd-H → ???"
  : # echo "${CRUMB_APP_SHORTCUTS}: Gnucash.app: “Help > Contents”: F1 → ???"
}

app_shortcuts_customize_gnucash_all() {
  # The list order matches the menu order (and echo order you see above).
  # - HSTRY/2024-08-06: Preserved because this is first time I originated
  #   defaults in code, as opposed to adding the keys via System Settings
  #   and then copying `defaults read`.
  defaults write org.gnucash.Gnucash NSUserKeyEquivalents '{
    "New File" = "^n";
    "Open..." = "^o";
    "Save" = "^s";
    "Save As..." = "^$s";
    "Print..." = "^p";
    "Print Setup" = "^$p";
    "Close" = "^w";
    "Edit Account" = "^e";
    "Find Account" = "^i";
    "Find..." = "^f";
    "Refresh" = "^r";
    "Transfer..." = "^t";
  }'
  # What `defaults read org.gnucash.Gnucash NSUserKeyEquivalents` reports:
  #   Close = "^w";
  #   "Edit Account" = "^e";
  #   "Find Account" = "^i";
  #   "Find..." = "^f";
  #   "New File" = "^n";
  #   "Open..." = "^o";
  #   "Print Setup" = "^$p";
  #   "Print..." = "^p";
  #   # "Quit Gnucash" = "^q";
  #   Refresh = "^r";
  #   Save = "^s";
  #   "Save As..." = "^$s";
  #   "Transfer..." = "^t";
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

slather_macos_defaults_hammyspoony() {
  local dry_run=false

  # ***

  while [ "$1" != '' ]; do
    case $1 in
    --dry-run)
      dry_run=true
      shift
      ;;
    *) shift ;;
    esac
  done

  # ***

  if ${dry_run}; then
    fake_it
  fi

  # ***

  app_shortcuts_customize_gnucash
}

# ***

fake_it() {
  fg_skyblue() { printf "\033[38;2;135;175;255m"; }
  attr_reset() { printf "\033[0m"; }
  highlight() { printf "%s" "$(fg_skyblue)$1$(attr_reset)"; }

  defaults() {
    echo "  $(highlight "defaults") $@"
  }
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

clear_traps() {
  trap - EXIT INT
}

set_traps() {
  trap -- trap_exit EXIT
  trap -- trap_int INT
}

exit_0() {
  clear_traps

  exit 0
}

exit_1() {
  clear_traps

  exit 1
}

trap_exit() {
  clear_traps

  # USAGE: Alert on unexpected error path, so you can add happy path.
  >&2 echo "ALERT: "$(basename -- "$0")" exited abnormally!"
  >&2 echo "- Hint: Enable \`set -x\` and run again..."

  exit 2
}

trap_int() {
  clear_traps

  exit 3
}

# ***

main() {
  set -e

  set_traps

  slather_macos_defaults_hammyspoony "$@"

  clear_traps
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
  # Being executed.
  main "$@"
fi
