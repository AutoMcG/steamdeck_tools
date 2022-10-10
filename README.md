# steamdeck_tools

A repository for a random grouping of tools created for the Steam Deck.

# Install

Download or clone this repository onto your steam deck. Double-click the .desktop file for what action you wish to take. 

It is highly recommended that you place this folder in /home/deck/ for greatest chance for success!

https://user-images.githubusercontent.com/31704955/192400391-af206162-b228-443e-ad3a-d5f5713fef7a.mp4

# Vidswap

Vidswap was created to replace the deck startup video file with a file of the user's choice. 

When ./vidswap/vidswap.sh is run, it reads all files within the 'vids' folder and displays a numbered list of the files. To add new files to the list, simply drop a .webm file into the /vidswap/vids folder and the script should take care of the rest. 

The user then enters the number corresponding to the video they want to put into place.

The selected video file should then play every time the steam deck enters gaming mode.

To run the script, you can either invoke it in terminal or double-click the vidswap.desktop file when in desktop mode.

This has been updated to use the new `/home/deck/.steam/root/config/uioverrides/movies/` location and no longer changes or truncates any other files. 

# Randomizer

Randomizer builds on Vidswap and provides two features: individual random set and on-boot randomization.

If you'd like to set the next video randomly, execute randomizer.desktop (or run ./vidswap/randomzier.sh).

If you'd like to set a new random video for every boot, execute random_every_boot.desktop (or run ./vidswap/random_service_install.sh).

To stop the random every boot, execute uninstall_every_boot.desktop (or run ./vidswap/random_service_uninstall.sh).

### Randomizer invokes Vidswap. This means any webms added to /vidswap/vids will be part of the random rotation.

# Credits

HUGE credit to /u/DerpinHerps for their amazing startup videos and work pioneering the process.

Vidswap is basically just a scripted version of the process they identified.

Video file credits:
| Filename | Author |
| -------- | ------ |
| BreakingBad.webm | /u/DerpinHerps |
| BetterCallSaul.webm | /u/Minkarii |
| CowboyBebop.webm | /u/MatPaget |
| Frasier.webm | /u/DerpinHerps |
| Futurama.webm | /u/DerpinHerps |
| HandheldHistory.webm | /u/TareXmd |
| NeoGeo.webm | /u/TareXmd |
| office.webm | /u/DerpinHerps |
| PipBoy.webm | /u/trentwebr |
| RickMorty.webm | /u/BeefyDragon |
| Seinfeld.webm | /u/DerpinHerps |
| StarWars.webm | /u/BetterCallSal |
| TheCritic.webm | /u/TinyBruce |
| WarGames.webm | /u/BetterCallSal |

The tools in this repo would be meaningless without all these talented video creators. Show them some love by donating!

| User | Donation link |
| ---- | ------------- |
| [/u/BetterCallSal](https://www.reddit.com/user/BetterCallSal) | [Streamlabs](https://streamlabs.com/thesilverhairedgamer/tip) |
| [/u/BeefyDragon](https://www.reddit.com/user/BeefyDragon) | [Paypal](https://www.paypal.me/Shaktimus) |
| [/u/DerpinHerps](https://www.reddit.com/user/DerpinHerps) | Venmo:@HayPopp |
| [/u/Minkarii](https://www.reddit.com/user/Minkarii) | [Mermaids](https://mermaidsuk.org.uk/donate/) |
| [/u/TareXmd](https://www.reddit.com/user/TareXmd) | [Paypal](https://paypal.me/tghazaly) |
| [/u/TinyBruce](https://www.reddit.com/user/TinyBruce) | [Venmo](https://venmo.com/code?user_id=3273879153803264234&created=1664456024) (Justin-Perkins-113)|
| [/u/trentwebr](https://www.reddit.com/user/trentwebr) | [Paypal](https://www.paypal.com/donate/?business=7RMYLBR9YG22N) |
