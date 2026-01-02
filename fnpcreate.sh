#!/bin/bash

# --- Configuration ---

# 1. Default Tracker URL
# Leave empty "" if you don't want a default and want to select a new tracker url every time. 
DEFAULT_TRACKER=""

# 2. Default Comment
# This will be used if you do not provide the -c flag.
DEFAULT_COMMENT="Created with fnpcreate.sh using mkbrr"

# 3. Default Source
# This will be used if you do not provide the -s flag.
DEFAULT_SOURCE="FnP"

# 4. Output Directory
# Where the .torrent, .txt, and .jpg files will be saved.
OUTPUT_DIR=""

# 5. Qbit Watch Directory
# Set the path where you want the .torrent file copied for Qbit.
QBIT_DIR=""

# --- End Configuration ---

# Function to display usage
usage() {
  echo "Usage: $(basename "$0") -d <album_directory> [-t <tracker>] [-c <comment>] [-s <source>]"
  echo ""
  echo "Options:"
  echo "  -d <path>     : Path to the music album directory (Required)"
  echo "  -t <url>      : Tracker URL (Can use multiple times). Overrides default."
  echo "  -c <text>     : Comment. Overrides default: '$DEFAULT_COMMENT'"
  echo "  -s <text>     : Source. Overrides default: '$DEFAULT_SOURCE'"
  echo "  -h            : Show this help"
}

# Initialize variables to empty
ALBUM_DIR=""
USER_COMMENT=""
USER_SOURCE=""
declare -a USER_TRACKERS

# Parse arguments
while getopts ":d:t:c:s:h" opt; do
  case ${opt} in
    d ) ALBUM_DIR="$OPTARG" ;;
    t ) USER_TRACKERS+=("$OPTARG") ;;
    c ) USER_COMMENT="$OPTARG" ;;
    s ) USER_SOURCE="$OPTARG" ;;
    h ) usage; exit 0 ;;
    \? ) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
    : ) echo "Option -$OPTARG requires an argument." >&2; usage; exit 1 ;;
  esac
done

# Check required argument
if [ -z "$ALBUM_DIR" ]; then
  echo "Error: Album directory (-d) is required."
  exit 1
fi

if [ ! -d "$ALBUM_DIR" ]; then
  echo "Error: Directory '$ALBUM_DIR' does not exist."
  exit 1
fi

# Ensure output directories exist
mkdir -p "$OUTPUT_DIR"
if [ -n "$QBIT_DIR" ]; then
    mkdir -p "$QBIT_DIR"
fi

# --- Naming Logic ---
# Extract folder name, stripping trailing slashes if present
ALBUM_NAME=$(basename "${ALBUM_DIR}")
echo "Processing Album: $ALBUM_NAME"

# Define output filenames
REPORT_FILE="${OUTPUT_DIR}/${ALBUM_NAME}.txt"
COVER_FILE="${OUTPUT_DIR}/${ALBUM_NAME}.jpg"

# --- Step 1: MusicMeta ---
echo "Running musicmeta..."
musicmeta_cmd=(
  musicmeta
  -d "$ALBUM_DIR"
  -o "$REPORT_FILE"
  -c "$COVER_FILE"
)

"${musicmeta_cmd[@]}"

if [ $? -eq 0 ]; then
    echo "Report generated: $REPORT_FILE"
    echo "Cover generated: $COVER_FILE"
else
    echo "Error running musicmeta"
    exit 1
fi

# --- Step 2: Mkbrr ---
echo "Running mkbrr..."

mkbrr_cmd=(
  mkbrr create
  "$ALBUM_DIR"
  --output-dir "$OUTPUT_DIR"
  --private
  --quiet
  --no-creator
)

# 1. Handle Trackers (User flags OR Default)
if [ ${#USER_TRACKERS[@]} -gt 0 ]; then
    for t in "${USER_TRACKERS[@]}"; do
        mkbrr_cmd+=(-t "$t")
    done
elif [ -n "$DEFAULT_TRACKER" ]; then
    echo "Using default tracker."
    mkbrr_cmd+=(-t "$DEFAULT_TRACKER")
else
    echo "Warning: No tracker provided and no default configured."
fi

# 2. Handle Comment (User flag OR Default)
FINAL_COMMENT="${USER_COMMENT:-$DEFAULT_COMMENT}"
if [ -n "$FINAL_COMMENT" ]; then
    mkbrr_cmd+=(-c "$FINAL_COMMENT")
fi

# 3. Handle Source (User flag OR Default)
FINAL_SOURCE="${USER_SOURCE:-$DEFAULT_SOURCE}"
if [ -n "$FINAL_SOURCE" ]; then
    mkbrr_cmd+=(-s "$FINAL_SOURCE")
fi

# Execute mkbrr
"${mkbrr_cmd[@]}"

if [ $? -eq 0 ]; then
    echo "Torrent generated in: $OUTPUT_DIR"

    # --- Step 3: Copy to Qbit Directory ---
    if [ -n "$QBIT_DIR" ]; then
        echo "Copying torrent to $QBIT_DIR..."
        # We target the .torrent file specifically using the album name
        cp "${OUTPUT_DIR}/${ALBUM_NAME}.torrent" "$QBIT_DIR/"
        
        if [ $? -eq 0 ]; then
            echo "Successfully copied to Qbit directory."
        else
            echo "Error: Failed to copy torrent to $QBIT_DIR"
        fi
    fi
else
    echo "Error running mkbrr"
    exit 1
fi

echo "Done."
