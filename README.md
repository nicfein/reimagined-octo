# reimagined-octo

> [!WARNING]
> These scripts are all generated with AI, then edited manually by me to make sure they didn't nuke my library and did some things I wanted them to do. I know how to program, just was too lazy to dedicate time to scripts I knew AI could generate mostly without issue. Don't use AI, kids!

Scripts I personally use to do all my processing. There is no script to do the upload directly to any platform due to me preferring to do the upload manually. Slows me down, but lets me spot mistakes easily.

## Picard Rename Script

> [!WARNING]
> Can be destructive, be careful!

Made to comply with FNP music upload guidelines.

### Usage

1. [Download the script](https://github.com/nicfein/reimagined-octo/blob/main/FnP%20Music%20Upload%20Standard.ptsp).
2. Press `CTRL + SHIFT + S`.
3. Go to `File`, and `Import A Script File`.
4. Select the downloaded script.
5. Once added, select the script in the wide dropdown.
6. Press `Make it so!`, and in the toolbar go to `Options`, and enable `Rename Files` and `Move Files`
7. Now when you save your files, they will save like so: `/storage/Ken Carson/XTENDED (2022) - 24bit 44.1kHz/1-01 - Intro.flac`

## Upload Organizer [LINUX ONLY]

> [!NOTE]
> This does not modify files, only creates them at the specified directory using mkbrr and my description generating script.

Due to how my uploads are organized, I need a relatively structured setup. This script automatically runs mkbrr and my description generator, and moves the outputs to where I need them to be. I realise for mkbrr I could use their presets system, but decided on remaking the command every time so that if I need to change anything, all the variables are in one place (the script) and not all over the place.

### Usage

```
user@temp:~$ fnpcreate -h
Usage: fnpcreate.sh -d <album_directory> [-t <tracker>] [-c <comment>] [-s <source>]

Options:
  -d <path>     : Path to the music album directory (Required)
  -t <url>      : Tracker URL (Can use multiple times). Overrides default.
  -c <text>     : Comment. Overrides default: 'Created with fnpcreate.sh using mkbrr'
  -s <text>     : Source. Overrides default: 'FnP'
  -h            : Show this help
```

For example, if you are in a directory with the music files you want to upload (not folder to upload!) just run `fnpcreate -d .`

If you want to set multiple trackers in your command, just repeat the `-t` option as many times as required.

### Config [REQUIRED]

The first 3 options are optional, as they can be set via the command. The last 2 options are NOT optional. You will have to set them. 

```
# 1. Default Tracker URL
# Leave empty "" if you don't want a default. Only one tracker can be used. Using -t lets you override this, and -t can be set multiple times in one command. 
DEFAULT_TRACKER=""

# 2. Default Comment
# This will be used if you do not provide the -c flag. 
DEFAULT_COMMENT="Created with fnpcreate.sh using mkbrr"

# 3. Default Source
# This will be used if you do not provide the -s flag. Most trackers require or recommend you to add something here. 
DEFAULT_SOURCE="FnP"

# 4. Output Directory
# Where the .torrent, .txt, and .jpg files will be saved so you can more easily upload them.
OUTPUT_DIR="/firefox/toupload/torrent"

# 5. Qbit Watch Directory
# Set the path where you want the .torrent file copied for Qbit in case you have qbit watching a directory so you do not have to go in and upload the torrent itself manually.
# (you will however probably have to go in and reannounce the torrent when there is a moderation queue and you get accepted
QBIT_DIR="/structure/torrents/utorrents"
```

### Installation

> [!IMPORTANT]
> **READ THE CONFIG SECTION**. If you ask for help and its due to not editing the configuration part of the script, I will not help you.

1. Download the script
2. Edit the scripts configuration section to include all the necessary information. Check configuration section
3. Run `chmod +x ./fnpcreate.sh` in the directory where you downloaded the script
4. Run `alias fnpcreate='${pwd}/fnpcreate.sh'` so that you do not have to reference the entire script directory. **This is only a temporary alias, it will not persist past restarts**

## What if I need help?

If you found this repository, you probably know how to reach me. Just shoot me a DM or post in the forum. [Skim me if DMing me for help!](https://nohello.net/en/)
