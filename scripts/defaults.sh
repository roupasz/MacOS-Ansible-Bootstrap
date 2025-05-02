###################################################################
#Script Name    :
#Description    :
#Args           :
#Author         :
#Site           :
###################################################################

#!/bin/bash

export PATH="/usr/local/bin:/opt/homebrew/bin/:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin:$PATH"
SCRIPT_NAME=`basename $0`
LOCKFILE="/tmp/${SCRIPT_NAME}.lock"
[ -f ${LOCKFILE} ] && logger "$0 already running......" && echo "Already running..." && exit 1
date >  "${LOCKFILE}"

PROG="$(basename $0 .sh)"
PID="$$"
#LOGFILE="$(dirname $0)/${PROG}.log"
LOGFILE="/tmp/${PROG}.log"
# In case script uses SCRIPTPATH, enable line which is path agnostic, example speedtest.sh
SCRIPTPATH="$(dirname "$(realpath "$0")")"

log() {
        echo "$(date) ${PROG}[${PID}] $@" | tee -a ${LOGFILE}
}

fatal() {
        log "Fatal error, ${@}, exit ${RES}"
        #cleanup
        exit ${RES}
}

cleanup() {
        log "Cleanup.."
        [ -f ${LOCKFILE} ] && rm -f "${LOCKFILE}"
}

trap cleanup EXIT

### REALSTART SCRIPT #########################################################

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

###############################################################################
# General UI/UX                                                               #
###############################################################################

    # Display battery percentage
    # ref. https://github.com/todd-dsm/mac-ops/issues/39#issuecomment-962459353
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true

    # Enable the automatic update check
    #defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

    # Check for software updates daily, not just once per week
    #defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

    # Automatically download newly available updates in background
    #defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

    # Install System data files & security updates
    #defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

    # Automatically download apps purchased on other Macs
    #defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

###############################################################################
# NSGGLOBALDOMAIN                                                             #
###############################################################################

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Always show scrollbars.
    #defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

    # Use “natural” (Lion-style) scrolling.
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Disable press-and-hold for keys in favor of key repeat.
    #defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# NSGGLOBALDOMAIN_NS                                                          #
###############################################################################


    # Save to disk (not to iCloud) by default.
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    # Disable typing automatic capitalization.
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable typingautomatic period substition a.k.a. "smart stops".
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0

    # Disable typing automatic dash substitution e.g. "smart dashes".
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable typing automatic quote substitution a.k.a. "smart quotes".
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable typing automatic spelling correction a.k.a. "auto-correct".
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Expand save panel by default.
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

    # Speed up window resize time.
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

###############################################################################
# TRACKPAD                                                                    #
###############################################################################

    # Enable tap to click (Trackpad), also for login menu.
    #defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    #defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    #defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    #sudo defaults write com.apple.AppleMultitouchTrackpad Clicking 1

###############################################################################
# FINDER                                                                      #
###############################################################################

    # Show all files.
    defaults write com.apple.finder AppleShowAllFiles YES

    # Show all extensions.
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    #defaults write com.apple.finder FXPreferredGroupBy -string "Name"
    #defaults write com.apple.finder FXArrangeGroupViewBy -string "Name"

    # Always open everything in Finder's list view
    defaults write com.apple.Finder FXPreferredViewStyle  -string "clmv" && killall Finder

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Disable the warning before emptying the Trash
    #defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Enabling the “Remove items from the Trash after 30 days”
    defaults write com.apple.finder FXRemoveOldTrashItems -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

###############################################################################
# FLAGS                                                                       #
###############################################################################

    # Show the ~/Library folder.
    chflags nohidden ~/Library

###############################################################################
# TEXTEDIT                                                                    #
###############################################################################

    # Use Plain Text instead of Rich Text
    defaults write com.apple.TextEdit RichText -bool false

###############################################################################
# SCREEN SAVER                                                                #
###############################################################################

    # Require password immediately after sleep or screen saver begins.
    #defaults write com.apple.screensaver askForPassword -int 1
    #defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# ITERM2                                                                      #
###############################################################################

    #
    # Additional defaults settings can be found in `.chezmoiscripts/macos/run_once_04-install-iterm2.sh.tmpl`
    #

    # Don’t display the annoying prompt when quitting iTerm
    #defaults write com.googlecode.iterm2 PromptOnQuit -bool false

    # Specify the preferences directory
    # TODO add function scriptpath so as to run each time from same path
    # In addition to changes to config-repo which are also commented out
    #defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm2"

    # Set the custom fonder to load preferences
    # In addition to changes to config-repo which are also commented out
    #defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

    # Disable tip of the day
    defaults write com.googlecode.iterm2 NoSyncTipsDisabled -bool true

    # Install the Solarized Dark theme for iTerm
    #open "${HOME}/init/Solarized Dark.itermcolors"

###############################################################################
# ACTIVITY MONITOR                                                            #
###############################################################################

    # Show the main window when launching Activity Monitor
    #defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Visualize CPU usage in the Activity Monitor Dock icon
    #defaults write com.apple.ActivityMonitor IconType -int 5

    # Show all processes in Activity Monitor
    #defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    #defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    #defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# STARTUP APPLICATIONS                                                        #
###############################################################################

function open_applications() {
    # List of application paths
    local app_paths=(
        "/Applications/Rectangle.app"
        "/Applications/KeepingYouAwake.app"
    )
    for app_path in "${app_paths[@]}"; do
        if [ -e "${app_path}" ]; then
            open -g "${app_path}"
        fi
    done
}


function main() {

    open_applications
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi

### Please do not write below this line.
#/bin/rm -f "${LOCKFILE}"
exit

