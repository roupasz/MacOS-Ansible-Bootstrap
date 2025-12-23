#!/bin/bash

###################################################################
#Script Name    :
#Description    :
#Args           :
#Author         :
#Site           :
###################################################################

# Exit immediately on errors and enable ERR trap for functions and subshells
set -eE

# Set the system's PATH environment variable to include Homebrew and standard system binary directories
export PATH="/usr/local/bin:/opt/homebrew/bin/:/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/sbin:$PATH"

# --- Global Colors ----------------------------------------------
prefix='\e[1;31m' # error color
suffix='\e[0m'    # error color
RED='\033[0;31m'
PALE_RED='\033[38;5;217m'
GREEN='\033[0;32m'
PALE_GREEN='\033[38;5;121m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PALE_BLUE='\033[38;5;152m'
PALE_YELLOW='\033[38;5;228m'
PALE_ORANGE='\033[38;2;255;200;130m'
PALE_CYAN='\033[38;5;159m'
PALE_PURPLE='\033[38;5;183m'
ALTERNATIVE_PURPLE='\033[38;2;180;140;220m'
PALE_PINK='\033[38;2;255;182;193m'
NC='\033[0m'

log() {
        echo -e "$(date) ${PROG}[${PID}] $@" | tee -a ${LOGFILE}
}

info() {
        echo -e "$(date) ${PROG}[${PID}] ${GREEN}INFO:${NC} $@" | tee -a ${LOGFILE}
}

debug() {
        echo -e "$(date) ${PROG}[${PID}] ${BLUE}DEBUG:${NC} $@" | tee -a ${LOGFILE}
}

warn() {
        echo -e "$(date) ${PROG}[${PID}] ${YELLOW}WARN:${NC} $@" | tee -a ${LOGFILE}
}

fatal() {
        log "Fatal error, ${@}, exit ${RES}"
        #cleanup
        exit ${RES}
}

# Error function for handling errors with a message and exit code
# Usage
# error "$DMG_PATH failed to be mounted, please have a look!" 2 true - will set exit code to 2 and show a dialog
# error "$DMG_PATH failed to be mounted, please have a look!" false - will keep exit to default 1 and won't show diaload
error() {
    local errorMsg="$1"
    local exitCode="${2:-}"
    local showDialog="${3:-false}"  # Default is not to show the dialog

    # If the exitCode is empty, set the default to 1
    if [[ -z "$exitCode" || "$exitCode" == "true" || "$exitCode" == "false" ]]; then
        showDialog="$exitCode"
        exitCode=1
    fi

    echo -e "$(date) ${PROG}[${PID}] ${RED}ERROR:${NC} $errorMsg" >&2 | tee -a ${LOGFILE}  # Log the error message, check commit history for older versions

    # Show dialog if specified
    if [[ "$showDialog" == "true" ]]; then
        display_error_dialog "$errorMsg"
    fi

    exit "$exitCode"
}

# Function to display error dialog using osascript
display_error_dialog() {
    local message="$1"
    osascript <<-EndOfScript
        display dialog "$message" with title "Failed to mount DMG.." giving up after 10
EndOfScript
}

# Example of a command that checks for errors
# Not used currently
# Usage: `run_command command -v bw`
run_command() {
    "$@"
    if [ $? -ne 0 ]; then
        error "Command '$*' failed."
    fi
}

cleanup() {
        log "Cleanup.."
        bw logout || log "Bitwarden: Not logged in, no action needed."
        unset BW_SESSION || log "BW_SESSION is not set, no action needed"
        [ -f ${LOCKFILE} ] && rm -f "${LOCKFILE}"
}

# Set global variables
SCRIPT_NAME=`basename $0`
LOCKFILE="/tmp/${SCRIPT_NAME}.lock"
[ -f ${LOCKFILE} ] && logger "$0 already running......" && error "Already running..." true
date >  "${LOCKFILE}"

PROG="$(basename $0 .sh)"
PID="$$"
LOGFILE="/tmp/${PROG}.log"
# In case script uses SCRIPTPATH, enable line which is path agnostic
SCRIPTPATH="$(dirname "$(realpath "$0")")"

# Trap for general errors (due to set -eE, exits on every unhandled error)
trap 'error "An unexpected error occurred at line $LINENO. See logs for details." 1 true' ERR

# Trap for cleanup on EXIT
trap cleanup EXIT

### REALSTART SCRIPT #########################################################

# Function to show usage
usage() {
  echo "-----------------------------------------------------------------------"
  echo -en "${RED}"
  echo "                            WARNING                                    "
  echo "In a fresh MacOS installation, run first with --install-packages option."
  echo "              eg  ./bootstrap --install-packages                       "
  echo "   and choose whether to continue or stop the bootstrap process        "
  echo "-----------------------------------------------------------------------"
  echo -en "${NC}"
  echo "-----------------------------------------------------------------------"
  echo "                      Available commands                               "
  echo "-----------------------------------------------------------------------"
  echo -en "${BLUE}"
  echo "Usage: bash $0 [--install-packages] [-t 'tag1','tag2'] [--no-ask-vault-pass] [--help]"
  echo
  echo "If no options are provided, the script will install all default packages and configurations."
  echo "Options:"
  echo "  --install-packages       Install required packages and choose whether to continue or stop the bootstrap process."
  echo "  -t, --tags 'tag1','tag2' Specify tags to pass to ansible-playbook,"
  echo "                           Available Tags:"
  echo "                           def    - Install default MacOS fonts, settings and configurations."
  echo "                           brew   - Install Homebrew and related packages."
  echo "                           krew   - Install Krew (kubectl plugin manager) and plugins."
  echo "                           bw     - Configure Gitlab Access Token via Bitwarden."
  echo "                           cz     - Install and configure Chezmoi."
  echo "                           bw_cfg - Install and configure Dotfiles."
  echo "                           bw_gpg - Import GPG Secret keys."
  echo "  --no-ask-vault-pass      Skip prompting for the Ansible Vault password."
  echo "  -h, --help               Display this help message"
  echo
  echo -en "${NC}"
}

welcome() {
echo -en "${GREEN}"
echo "======================================================="
echo "+           Welcome to your new environment!!🎉       +"
echo "======================================================="
echo -en "${NC}"
echo -en "${ALTERNATIVE_PURPLE}"
multiline_string="
# Not 100% there but you are close:
- Initialize variables in Keychain required by various scripts.
- Mandatory applications that need to be added to launch on login:
        * Command-x (homebrew)
        * Maccy (homebrew)
        * <add more>
- Optional applications that can be installed per need:
        * CleanShotX : Paid https://cleanshot.com/
        * Ice Menu Bar Manager : Free https://icemenubar.app/
        * Let It Snow Desktop : Free App Store
        * <add more>
- Copy major folders from your backup (ex. .kube, .gnupg , .config etc)
- Install DisplayManager related software.
- Software licenses (cleanshotx, updatest etc) can be found in OneDrive dmg backup or in hotmail.
"
echo "$multiline_string"
echo -en "${NC}"
}

# Default values for ansible playbook options
TAGS=""
ASK_VAULT_PASS="--ask-vault-pass"  # Enabled by default
INSTALL_ONLY=false
install_cask_bootsrap_packages=false
ZSH=~/.oh-my-zsh

# suppress node js warnings
export NODE_NO_WARNINGS=1

PACKAGES=(
    # Add more packages as needed
    "ansible"
    "bitwarden-cli"
    "ente-auth"
    "transcrypt"
    # brew via ansible is problematic
    "Azure/kubelogin/kubelogin"
    "abhimanyu003/sttr/sttr"
)

CASK_PACKAGES=(
    "iterm2"
    "onedrive"
    # Add more packages as needed
)

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -t|--tags)
      TAGS="--tags $2"
      shift 2
      ;;
    --no-ask-vault-pass)
      ASK_VAULT_PASS=""  # Disable asking for the vault pass
      shift
      ;;
    --install-packages)
      INSTALL_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "Unknown parameter: $1"
      usage
      exit 1
      ;;
  esac
done

install_brew()  {
# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
    log "Homebrew not found, installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    log "Homebrew already installed"
fi
}

bootstrap_apps() {
# Loop through each package and check if it is installed
log "Installing bootstrap packages via brew.."
for package in "${PACKAGES[@]}"; do
  if ! brew list "$package" &> /dev/null; then
    log "$package not found, installing..."
    brew install "$package"
  else
    log "$package already installed"
  fi
done
}

bootstrap_casks() {
# Loop through each cask package and check if it is installed
log "Installing bootstrap cask packages via brew.."
for cask_package in "${CASK_PACKAGES[@]}"; do
  if ! brew list "$cask_package" &> /dev/null; then
    log "$cask_package not found, installing..."
    brew install --cask "$cask_package"
  else
    log "$cask_package already installed"
  fi
done
}

# Check if only installing packages
if [ "$INSTALL_ONLY" = true ]; then
    log "Installing boostrap packages.."
    install_brew
    bootstrap_apps
    bootstrap_casks
    log "Bootstrap packages installed successfully, moving on to zsh related tools"

  # check if ultimate vim is present, else install it
  if [ ! -d ~/.vim_runtime ]; then
    log "Installing Ultimate vimrc.."
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
  else
    log "Ultimate vimrc is already installed"
  fi
  # check if oh-my-zsh is present, else install it
  if [ ! -d ~/.oh-my-zsh ]; then
    log "Installing Oh My Zsh framework and Powerlevel10k theme.."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH/custom/themes/powerlevel10k
    log "Installing Oh My Zsh plugins.."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH/custom/plugins/fast-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
  else
    log "Oh My Zsh is already installed"
  fi

  log "Do you want to continue with the bootsrap process ? (y/n)"
  read -p "> " continue_bootstrap
  if [[ "$continue_bootstrap" =~ ^[Nn]$ ]]; then
        log "All needed packages and configurations are successfully installed. Exiting without running the playbook."
        exit 0
  fi
fi

# Prompt for new installation check if "brew" tag is present
log "Is this a new installation ? (y/n)"
read -p "> " new_installation
if [[ "$new_installation" =~ ^[Yy]$ ]]; then
    log "Have you already installed needed boostrap packages ? (y/n)"
    read -p "> " package_installed
    if [[ "$package_installed" =~ ^[Yy]$ ]]; then
      log "This is a new installation.. Setting install_cask_bootsrap_packages flag to true."
      install_cask_bootsrap_packages=true
    else
      warn "Please run first 'bootsrap.sh --install-packages' and re run script with iTerm2 otherwise the setup will fail"
      exit 0;
    fi
else
  if [[ -z "$TAGS" ]];then
    log "Not a new installation, please re run with specific TAGS or use help function to find more information regarding execution options"
    exit 0;
  fi
fi

## TODO better handling with functions in general so as to not use same entries twice
# Handle BW_SESSION creation and Bitwarden export
if [[ -z "$TAGS" || "$TAGS" == *"bw"* ]]; then
  if [ -z "$BW_SESSION" ]; then
    echo -e "${BLUE}You need to login to Bitwarden, please enter your 2FA code:${NC}"
    read -p "> " BW_2FA_CODE
    if [ -n "$BW_2FA_CODE" ]; then
      echo -e "${GREEN}Using provided code for Bitwarden session creation.${NC}"
      export BW_SESSION=$(bw login --method 0 --code $BW_2FA_CODE --raw)
      if [ -z "$BW_SESSION" ]; then
        echo -e "${RED}Incorrect password or 2FA code. Exiting.${NC}"
        exit 1
      fi
    else
      echo -e "${RED}No token provided. Exiting.${NC}"
      exit 1
    fi
  fi
else
  log "Skipping BW_SESSION creation for specified tags: $TAGS"
fi

# Run main playbook based on tags and extra vars
extra_vars=""
  if [[ -z "$TAGS" || "$TAGS" == *"brew"* && "$install_cask_bootsrap_packages" == true ]]; then
      extra_vars="--extra-vars install_cask_bootsrap_packages=true"
  fi

# Run the Ansible playbook with the parsed options
log "Should I proceed by running: 'ansible-playbook main_playbook.yml $TAGS $extra_vars' ? (y/n)"
read -p "> " ansible_apply
if [[ "$ansible_apply" =~ ^[Yy]$ ]]; then
  ansible-playbook main_playbook.yml $TAGS $extra_vars $ASK_VAULT_PASS
  welcome
else
  log "You have chosen to stop, cleaning up and logging out from Bitwarden!"
fi

### Please do not write below this line.
#/bin/rm -f "${LOCKFILE}"
exit
