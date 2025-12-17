#!env bash

# Strongly inspired by and copy-pasting from
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos.

# Some settings require full disk access.
#!/usr/bin/env bash
PROTECTED_SETTINGS="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist"
[ -r "$PROTECTED_SETTINGS" ] \
  || {
    echo "Full Disk Access is NOT enabled for this terminal."
    echo "Grant it in: System Settings → Privacy & Security → Full Disk Access"
    exit 1
  }

# Close any open System Preferences panes, to prevent them from overriding
# settings we are about to change.
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

################################################################################
# General UI/UX                                                                #
################################################################################

# Expand save panel by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Clock
# Display date and 24-hour time.
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  H:mm"

################################################################################
# Keyboard                                                                     #
################################################################################

# Typing
# Disable automatic capitalization.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable smart dashes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable automatic period substitution.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable smart quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable auto-correct.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls.
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

################################################################################
# Finder                                                                       #
################################################################################

# Display full POSIX path as Finder window title.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

################################################################################
# Trackpad                                                                     #
################################################################################

# Trackpad: enable tap to click for this user and for the login screen.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable extra multifinger gestures.
defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showDesktopGestureEnabled -bool true
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

# Enable trackpad dragging.
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

################################################################################
# Dock, Dashboard, and hot corners                                             #
################################################################################

# Do not automatically rearrange Spaces based on most recent use.
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock.
defaults write com.apple.dock autohide -bool true

# Do not show recent applications in Dock.
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Safari                                                                      #
###############################################################################

# Prevent Safari from opening ‘safe’ files automatically after downloading.
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable the Develop menu and the Web Inspector in Safari.
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Enable “Do Not Track”.
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "Done. Note that some of these changes require a logout/restart to take effect."
