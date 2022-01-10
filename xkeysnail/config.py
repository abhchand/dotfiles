# -*- coding: utf-8 -*-
# autostart = true

#  ▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄▄▄ ▄▄    ▄ ▄▄▄▄▄▄
# █      █  ▄    █  █ █  █       █  █ █  █      █  █  █ █      █
# █  ▄   █ █▄█   █  █▄█  █       █  █▄█  █  ▄   █   █▄█ █  ▄    █
# █ █▄█  █       █       █     ▄▄█       █ █▄█  █       █ █ █   █
# █      █  ▄   ██   ▄   █    █  █   ▄   █      █  ▄    █ █▄█   █
# █  ▄   █ █▄█   █  █ █  █    █▄▄█  █ █  █  ▄   █ █ █   █       █
# █▄█ █▄▄█▄▄▄▄▄▄▄█▄▄█ █▄▄█▄▄▄▄▄▄▄█▄▄█ █▄▄█▄█ █▄▄█▄█  █▄▄█▄▄▄▄▄▄█
#
#
# OSX-like Key bindings for Ubuntu Linux
# Original: https://github.com/rbreaves/kinto/blob/master/linux/kinto.py
# Earlier lines take precedence over later lines.
#
#
# # TABLE OF CONTENTS
#   * APPLICATION LIST
#   * MODE MAPS
#   * GLOBAL BINDINGS
#   * FILE MANAGER BINDINGS
#   * BROWSERS BINDINGS
#   * APPLICATION BINDINGS
#   * TERMINAL BINDINGS
#   * GLOBAL FALLBACKS


import re
from xkeysnail.transform import *

import os

##############################################
### APPLICATION LIST #########################
##############################################

# To find the standardized name (`WM_CLASS`) for an application to add to
# this list, use `xprop`.
# See:
# https://github.com/mooz/xkeysnail#checking-an-applications-wm_class-with-xprop


# Remote desktops
# Ideally we'd only exclude the client window, but that may not be easily done.

remotes = [
    'Gnome-boxes',
    'org.remmina.Remmina',
    'remmina',
    'qemu-system-.*',
    'qemu',
    'Spicy',
    'Virt-manager',
    'VirtualBox',
    'VirtualBox Machine',
    'xfreerdp',
    ]
remotes = [client.casefold() for client in remotes]

# Terminals

terminals = ['gnome-terminal', 'konsole', 'tilix']
terminals = [term.casefold() for term in terminals]
termStr = '|'.join(str('^' + x + '$') for x in terminals)
terminals.extend(remotes)

# Browsers

browsers = ['Chromium', 'Firefox', 'Firefox Developer Edition',
            'Google-chrome']
browsers = [browser.casefold() for browser in browsers]
browserStr = '|'.join(str('^' + x + '$') for x in browsers)

# Chrome Browsers

chromes = ['Chromium', 'Chromium-browser', 'Google-chrome']
chromes = [chrome.casefold() for chrome in chromes]
chromeStr = '|'.join(str('^' + x + '$') for x in chromes)


##############################################
### MODE MAPS ################################
##############################################

# Global modemap

define_conditional_modmap(lambda wm_class: True, {

    # Mac/Win Keyboard Layout
    #
    #  [LCTRL]  [FN] [LMETA]  [LALT]   [   SPACE   ]  [RALT]   [RCTRL]  # Physical
    #  ---------------------------------------------------------------
    #  [LMETA]  [FN] [LALT]   [RCTRL]  [   SPACE   ]  [RCTRL]  [RMETA]  # Mapped

    Key.LEFT_CTRL:  Key.LEFT_META,
    Key.LEFT_META:  Key.LEFT_ALT,
    Key.LEFT_ALT:   Key.RIGHT_CTRL,
    Key.RIGHT_ALT:  Key.RIGHT_CTRL,
    Key.RIGHT_META: Key.RIGHT_ALT,
    Key.RIGHT_CTRL: Key.RIGHT_META,

    # Mac-only Keyboard Layout

    # Key.LEFT_META:  Key.RIGHT_CTRL,
    # Key.LEFT_CTRL:  Key.LEFT_META,
    # Key.RIGHT_META: Key.RIGHT_CTRL,
    # Key.RIGHT_CTRL: Key.RIGHT_META,

    })

# Terminal modmap

# define_conditional_modmap(re.compile(termStr, re.IGNORECASE), {

#     # Mac/Win Keyboard Layout
#     #
#     #  [LCTRL]  [FN] [LMETA]  [LALT]   [   SPACE   ]  [RALT]   [RCTRL]  # Physical
#     #  ---------------------------------------------------------------
#     #  [LCTRL]  [FN] [LALT]   [RCTRL]  [   SPACE   ]  [RCTRL]  [LCTRL]  # Mapped

#     Key.LEFT_CTRL:  Key.LEFT_CTRL,
#     Key.LEFT_META:  Key.LEFT_ALT,
#     Key.LEFT_ALT:   Key.RIGHT_CTRL,
#     Key.RIGHT_ALT:  Key.RIGHT_CTRL,
#     Key.RIGHT_META: Key.RIGHT_ALT,
#     Key.RIGHT_CTRL: Key.LEFT_CTRL,

#     # Mac-only Keyboard Layout

#     # Key.LEFT_META:  Key.RIGHT_CTRL,
#     # Key.LEFT_CTRL:  Key.LEFT_CTRL,
#     # Key.RIGHT_META: Key.RIGHT_CTRL,
#     # Key.RIGHT_CTRL: Key.LEFT_CTRL,

#     })

##############################################
### GLOBAL BINDINGS ##########################
##############################################

define_keymap(None, {
    # Move window to left half of screen
    K('RC-M-j'): [lambda : \
                  os.system('sleep 0.10 && wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && xdotool getactivewindow windowsize 50% 100% && xdotool getwindowfocus windowmove 0 0'
                  )],
    # Move window to right half of screen
    K('RC-M-l'): [lambda : \
                  os.system('sleep 0.10 && wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && xdotool getactivewindow windowsize 50% 100% && xdotool getwindowfocus windowmove 9999 0'
                  )],
    # Move window to top half of screen
    K('RC-M-i'): [lambda : \
                  os.system('sleep 0.10 && wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && xdotool getactivewindow windowsize 100% 50% && xdotool getwindowfocus windowmove 0 0'
                  )],
    # Move window to bottom half of screen
    K('RC-M-k'): [lambda : \
                  os.system('sleep 0.10 && wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz && xdotool getactivewindow windowsize 100% 50% && xdotool getwindowfocus windowmove 0 9999'
                  )],
    # Maximize screen
    K('RC-M-m'): [lambda : \
                  os.system('sleep 0.10 && wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz'
                  )],
    # Cycle active window to next desktop/workspace
    K('RC-M-h'): [lambda : \
                  os.system('sh /home/abhishek/git/abhishek/dotfiles/xkeysnail/mv_win_next_desktop.sh'
                  )],
    # Cycle all windows of active application to next desktop/workspace
    K('RC-M-Shift-h'): [lambda : \
                  os.system('sh /home/abhishek/git/abhishek/dotfiles/xkeysnail/mv_app_next_desktop.sh'
                  )],
    }, "Global Bindings - General")


##############################################
### FILE MANAGER BINDINGS ####################
##############################################

filemanagers = ["nautilus", "org.gnome.nautilus"]
filemanagers = [filemanager.casefold() for filemanager in filemanagers]
filemanagerStr = "|".join(str('^'+x+'$') for x in filemanagers)

define_keymap(re.compile("org.gnome.nautilus|nautilus", re.IGNORECASE),{

    # For this command to work, a custom shortcut must be set up in the Settings
    # app in GNOME to run command: "nautilus --new-window /home/<USER>"
    # K("RC-N"): K("C-M-Space"),                        # macOS Finder search window shortcut Cmd+Option+Space

    K("RC-KEY_1"):              K("C-KEY_2"),           # View as Icons
    K("RC-KEY_2"):              K("C-KEY_1"),           # View as List (Detailed)
    # K("RC-Super-o"):          K("Shift-Enter"),       # Open in new window
    # K("RC-Super-o"):          K("RC-Enter"),          # Open in new tab
    K("RC-comma"):              K("RC-comma"),          # Open preferences dialog
},"File Manager Bindings - Nautilus")


define_keymap(re.compile(filemanagerStr, re.IGNORECASE),{

    ###  General
    K("RC-i"):                  K("M-Enter"),           # File properties dialog (Get Info)
    K("RC-Shift-dot"):          K("RC-H"),              # Show/hide hidden files ("dot" files)
    K("RC-Backspace"):          K("Delete"),            # Move to Trash (delete)
    K("RC-Shift-Enter"):        K("F2"),                # Rename file

    ###  Tab Navigation
    K("RC-Shift-Left_Brace"):   K("C-Page_Up"),         # Go to prior tab
    K("RC-Shift-Right_Brace"):  K("C-Page_Down"),       # Go to next tab
    K("RC-Shift-Left"):         K("C-Page_Up"),         # Go to prior tab
    K("RC-Shift-Right"):        K("C-Page_Down"),       # Go to next tab

    # Folder Navigation
    K("RC-Left_Brace"):         K("M-Left"),            # Go Back
    K("RC-Right_Brace"):        K("M-Right"),           # Go Forward
    K("RC-Left"):               K("M-Left"),            # Go Back
    K("RC-Right"):              K("M-Right"),           # Go Forward
    K("RC-Up"):                 K("M-Up"),              # Go Up dir
    K("RC-Down"):               K("RC-O"),              # Go Down dir

    # File Navigation
    K("M-Up"):                  K("Home"),              # Go to first file
    K("M-Down"):                K("End"),               # Go to last file
    K("M-Shift-Up"):            K("Shift-Home"),        # Select up to first file
    K("M-Shift-Down"):          K("Shift-End"),         # Select down to last file

},"File Manager Bindings - General")

############################################
### BROWSERS BINDINGS ######################
############################################

define_keymap(re.compile("Firefox", re.IGNORECASE),{
    K("C-comma"): [
        K("C-T"),
        K("a"),K("b"),K("o"),
        K("u"),K("t"),
        K("Shift-SEMICOLON"),
        K("p"),K("r"),K("e"),
        K("f"),K("e"),K("r"),
        K("e"),K("n"),K("c"),
        K("e"),K("s"),
        K("Enter")
    ],                                                  # Open preferences
    K("RC-Shift-N"):            K("RC-Shift-P"),        # Open private window
}, "Browser Bindings - Firefox")

define_keymap(re.compile(chromeStr, re.IGNORECASE),{
    K("C-comma"): [K("M-e"), K("s"),K("Enter")],
}, "Browser Bindings - Chromium-Based")

define_keymap(re.compile(browserStr, re.IGNORECASE),{
    K("RC-Q"): K("RC-Q"),                           # Close all browsers Instances

    # Jump to tab
    K("RC-Key_1"): K("M-Key_1"),                    # Jump to to tabs #1 - #8
    K("RC-Key_2"): K("M-Key_2"),
    K("RC-Key_3"): K("M-Key_3"),
    K("RC-Key_4"): K("M-Key_4"),
    K("RC-Key_5"): K("M-Key_5"),
    K("RC-Key_6"): K("M-Key_6"),
    K("RC-Key_7"): K("M-Key_7"),
    K("RC-Key_8"): K("M-Key_8"),
    K("RC-Key_9"): K("M-Key_9"),                    # #9 jumps to last tab

    # Tab Navigation
    K("RC-Shift-Left_Brace"):   K("C-Page_Up"),     # Go to prior tab
    K("RC-Shift-Right_Brace"):  K("C-Page_Down"),   # Go to next tab
    K("RC-M-Left"):             K("C-Page_Up"),     # Go to prior tab
    K("RC-M-Right"):            K("C-Page_Down"),   # Go to next tab
    K("Super-Shift-Tab"):       K("C-Page_Up"),     # Go to prior tab
    K("Super-Tab"):             K("C-Page_Down"),   # Go to next tab

}, "General Web Browsers")

############################################
### APPLICATION BINDINGS ###################
############################################

define_keymap(re.compile("Ulauncher", re.IGNORECASE),{
    # Remap Ctrl+[1-9] and Ctrl+[a-z] to Alt+[1-9] and Alt+[a-z]
    K("RC-Key_1"):      K("M-Key_1"),
    K("RC-Key_2"):      K("M-Key_2"),
    K("RC-Key_3"):      K("M-Key_3"),
    K("RC-Key_4"):      K("M-Key_4"),
    K("RC-Key_5"):      K("M-Key_5"),
    K("RC-Key_6"):      K("M-Key_6"),
    K("RC-Key_7"):      K("M-Key_7"),
    K("RC-Key_8"):      K("M-Key_8"),
    K("RC-Key_9"):      K("M-Key_9"),
    K("RC-a"):          K("M-a"),
    K("RC-b"):          K("M-b"),
    K("RC-c"):          K("M-c"),
    K("RC-d"):          K("M-d"),
    K("RC-e"):          K("M-e"),
    K("RC-f"):          K("M-f"),
    K("RC-g"):          K("M-g"),
    K("RC-h"):          K("M-h"),
    K("RC-i"):          K("M-i"),
    K("RC-j"):          K("M-j"),
    K("RC-k"):          K("M-k"),
    K("RC-l"):          K("M-l"),
    K("RC-m"):          K("M-m"),
    K("RC-n"):          K("M-n"),
    K("RC-o"):          K("M-o"),
    K("RC-p"):          K("M-p"),
    # K("RC-q"):          K("M-q"),
    K("RC-r"):          K("M-r"),
    K("RC-s"):          K("M-s"),
    K("RC-t"):          K("M-t"),
    K("RC-u"):          K("M-u"),
    K("RC-v"):          K("M-v"),
    K("RC-w"):          K("M-w"),
    K("RC-x"):          K("M-x"),
    K("RC-y"):          K("M-y"),
    K("RC-z"):          K("M-z"),
}, "Application Bindings - Ulauncher")

define_keymap(re.compile("Sublime_text", re.IGNORECASE),{
    # K("Super-Space"):        K("C-Space"),         # Basic code completion
    K("Super-RC-f"):           K("F11"),             # toggle_full_screen
    # K("C-M-v"):              [K("C-k"), K("C-v")], # paste_from_history

    # Scroll / View
    # K("C-Super-up"):         K("M-o"),             # Switch file
    K("C-M-up"):               K("C-up"),            # scroll/peek lines up
    K("C-M-down"):             K("C-down"),          # scroll/peek lines down
    K("Super-Shift-up"):       K("M-Shift-up"),      # multi-cursor up
    K("Super-Shift-down"):     K("M-Shift-down"),    # multi-cursor down
    K("Super-C-up"):           K("C-Shift-up"),      # swap_line_up
    K("Super-C-down"):         K("C-Shift-down"),    # swap_line_down

    # Navigation
    K("C-Shift-left_brace"):   K("C-PAGE_UP"),       # prev_view
    K("C-Shift-right_brace"):  K("C-PAGE_DOWN"),     # next_view
    K("C-M-right"):            K("C-PAGE_DOWN"),     # next_view
    K("C-M-left"):             K("C-PAGE_UP"),       # prev_view

    K("C-M-o"):                K("insert"),          # toggle_overwrite

    # Find/Replace
    K("C-M-c"):                K("M-c"),             # toggle_case_sensitive
    K("C-g"):                  K("F3"),              # find_next
    K("C-Shift-g"):            K("Shift-f3"),        # find_prev
    K("C-M-f"):                K("C-h"),             # replace
    # K("C-M-e"):              K("C-Shift-h"),       # replace_next
    # K("Super-M-g"):          K("C-f3"),            # find_under
    # K("Super-M-Shift-g"):    K("C-Shift-f3"),      # find_under_prev
    # K("Super-C-g"):          K("M-f3"),            # find_all_under

    # K("Super-f5"):           K("Super-f9"),        # sort_lines (case_sensitive true)
    # K("f5"):                 K("f9"),              # sort_lines (case_sensitive false)
}, "Application Bindings - Sublime Text")

############################################
### TERMINAL BINDINGS ######################
############################################

define_keymap(re.compile("konsole", re.IGNORECASE),{

    # Tab Switching
    K("RC-Shift-Left_Brace"):   K("Shift-Left"),    # Switch tab left
    K("RC-Shift-Right_Brace"):  K("Shift-Right"),   # Switch tab right

    K("RC-Left_Brace"):         K("RC-Shift-Left"),     # Switch split pane left
    K("RC-Right_Brace"):        K("RC-Shift-Right"),    # Switch split pane right

    # Split Pane
    K("RC-D"):                  K("C-KPLEFTPAREN"), # New split pane

    K("RC-Backspace"):          K("M-Backspace"),   # Delete world left of cursor

    # Navigate history
    K("RC-K"):                  K("Up"),            # Previous command history
    K("RC-J"):                  K("Down"),          # Next command history

}, "Terminal Bindings - Konsole")

define_keymap(re.compile(termStr, re.IGNORECASE),{

    K("LC-RC-f"):           K("M-F10"),              # Toggle window maximized state
    # K("LC-Right"):        K("Super-Page_Up"),      # SL - Change workspace (ubuntu/fedora)
    # K("LC-Left"):         K("Super-Page_Down"),    # SL - Change workspace (ubuntu/fedora)

    # Converts Cmd to use Ctrl-Shift
    K("RC-MINUS"):          K("C-MINUS"),
    K("RC-EQUAL"):          K("C-Shift-EQUAL"),
    K("RC-BACKSPACE"):      K("C-Shift-BACKSPACE"),
    K("RC-W"):              K("C-Shift-W"),
    K("RC-E"):              K("C-Shift-E"),
    K("RC-R"):              K("C-Shift-R"),
    K("RC-T"):              K("C-Shift-t"),
    K("RC-Y"):              K("C-Shift-Y"),
    K("RC-U"):              K("C-Shift-U"),
    K("RC-I"):              K("C-Shift-I"),
    K("RC-O"):              K("C-Shift-O"),
    K("RC-P"):              K("C-Shift-P"),
    K("RC-LEFT_BRACE"):     K("C-Shift-LEFT_BRACE"),
    K("RC-RIGHT_BRACE"):    K("C-Shift-RIGHT_BRACE"),
    K("RC-A"):              K("C-Shift-A"),
    K("RC-S"):              K("C-Shift-S"),
    K("RC-D"):              K("C-Shift-D"),
    K("RC-F"):              K("C-Shift-F"),
    K("RC-G"):              K("C-Shift-G"),
    K("RC-H"):              K("C-Shift-H"),
    K("RC-J"):              K("C-Shift-J"),
    K("RC-K"):              K("C-Shift-K"),
    # K("RC-L"):              K("C-Shift-L"),           # Used for clearing Gnome terminal screens
    K("RC-SEMICOLON"):      K("C-Shift-SEMICOLON"),
    K("RC-APOSTROPHE"):     K("C-Shift-APOSTROPHE"),
    K("RC-GRAVE"):          K("C-Shift-GRAVE"),
    K("RC-Z"):              K("C-Shift-Z"),
    K("RC-X"):              K("C-Shift-X"),
    K("RC-C"):              K("C-Shift-C"),
    K("RC-V"):              K("C-Shift-V"),
    K("RC-B"):              K("C-Shift-B"),
    K("RC-N"):              K("C-Shift-N"),
    K("RC-M"):              K("C-Shift-M"),
    K("RC-COMMA"):          K("C-Shift-COMMA"),
    K("RC-Dot"):            K("LC-c"),
    K("RC-SLASH"):          K("C-Shift-SLASH"),
    K("RC-KPASTERISK"):     K("C-Shift-KPASTERISK"),
}, "Terminal Bindings - General")


############################################
### SHARED FALLBACKS #######################
############################################

define_keymap(lambda wm_class: wm_class.casefold() not in terminals,{
    # K("RC-Dot"): K("Esc"),                              # Cmd+dot = Escape key. Interferes with 1Password in browsers
}, "Global Fallbacks - non-Terminals")

define_keymap(lambda wm_class: wm_class.casefold() not in remotes,{

    K("RC-Super-J"):        K("NEXTSONG"),              # Next Track
    K("RC-Super-K"):        K("PREVIOUSSONG"),          # Previous Track

    # K("RC-Space"):        K("Alt-F1"),                # Default SL - Launch Application Menu (Already mapped using Ulauncher)

    K("RC-F3"):             K("Super-d"),               # Default SL - Show Desktop
    K("RC-Super-f"):        K("M-F10"),                 # Default SL - Maximize app

    K("RC-Q"):              K("M-F4"),                  # Default SL - not-popos
    K("RC-H"):              K("Super-h"),               # Default SL - Minimize app
    K("M-Tab"):             pass_through_key,           # Default - Cmd Tab - App Switching Default
    K("RC-Tab"):            K("M-Tab"),                 # Default - Cmd Tab - App Switching Default
    K("RC-Shift-Tab"):      K("M-Shift-Tab"),           # Default - Cmd Tab - App Switching Default
    K("RC-Grave"):          K("M-Grave"),               # Default not-xfce4 - Cmd ` - Same App Switching
    K("RC-Shift-Grave"):    K("M-Shift-Grave"),         # Default not-xfce4 - Cmd ` - Same App Switching

    K("Super-Up"):          K("Super-Page_Up"),         # SL - Change workspace (ubuntu/fedora)
    K("Super-Down"):        K("Super-Page_Down"),       # SL - Change workspace (ubuntu/fedora)

    # Word and line navigation
    K("Super-a"):           K("Home"),                  # Beginning of Line
    K("Super-e"):           K("End"),                   # End of Line
    K("RC-Left"):           K("Home"),                  # Beginning of Line
    K("RC-Right"):          K("End"),                   # End of Line
    K("RC-Shift-Left"):     K("Shift-Home"),            # Select all to Beginning of Line
    K("RC-Shift-Right"):    K("Shift-End"),             # Select all to End of Line

    K("RC-Up"):             K("C-Home"),                # Beginning of File
    K("RC-Down"):           K("C-End"),                 # End of File

    K("RC-Shift-Up"):       K("C-Shift-Home"),          # Select all to Beginning of File
    K("RC-Shift-Down"):     K("C-Shift-End"),           # Select all to End of File

    K("Super-Backspace"):   K("C-Backspace"),           # Delete Left Word of Cursor
    K("Super-Delete"):      K("C-Delete"),              # Delete Right Word of Cursor

    K("M-Backspace"):       K("C-Backspace"),           # Delete Left Word of Cursor (default/alternate)
    # K("Alt-Delete"):      K("C-Delete"),              # Delete Right Word of Cursor (default/alternate)

    K("RC-Backspace"):      K("C-Shift-Backspace"),     # Delete Entire Line Left of Cursor

}, "Global Fallbacks - GNOME")
