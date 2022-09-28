# steamdeck_tools

A repository for a random grouping of tools created for the Steam Deck.

# Install

Download or clone this repository onto your steam deck. Double-click the .desktop file for what action you wish to take

https://user-images.githubusercontent.com/31704955/192400391-af206162-b228-443e-ad3a-d5f5713fef7a.mp4

# Vidswap

Vidswap was created to replace the deck startup video file with a file of the user's choice.

When ./vidswap/vidswap.sh is run, it reads all files within the 'vids' folder and displays a numbered list of the files.

The user then enters the number corresponding to the video they want to put into place.

The selected video file should then play every time the steam deck enters gaming mode.

To run the script, you can either invoke it in terminal or double-click the vidswap.desktop file when in desktop mode.

# Randomizer

Randomizer builds on Vidswap and provides two features: individual random set and on-boot randomization.

If you'd like to set the next video randomly, execute randomizer.desktop (or run ./vidswap/randomzier.sh).

If you'd like to set a new random video for every boot, execute random_every_boot.desktop (or run ./vidswap/random_service_install.sh).

To stop the random every boot, execute uninstall_every_boot.desktop (or run ./vidswap/random_service_uninstall.sh).

# Credits

HUGE credit to /u/DerpinHerps for their amazing startup videos and work pioneering the process.

Vidswap is basically just a scripted version of the process they identified.

Video file credits:
| Filename | Author |
| -------- | ------ |
| BreakingBad.webm | /u/DerpinHerps |
| Frasier.webm | /u/DerpinHerps |
| Futurama.webm | /u/DerpinHerps |
| NeoGeo.webm | /u/TareXmd | 
| RickMorty.webm | /u/BeefyDragon |
| Seinfeld.webm | /u/DerpinHerps |
| TheCritic.webm | /u/TinyBruce |
| office.webm | /u/DerpinHerps |


# Known Issues

Video files must not have spaces in the names. Prefer underscores or camelCase or PascalCase to spaces.
