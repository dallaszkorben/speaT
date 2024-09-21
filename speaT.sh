#!/usr/bin/bash

LANGUAGE_CODE=en
LANGUAGE_MODEL=small

TIME_LIMIT=10
SILENT_DURATION_TO_TRIGGER_RECORD=0.1
SILENT_LEVEL_TO_TRIGGER_RECORD=5%
SILENT_DURATION_TO_STOP_RECORD=1.5
SILENT_LEVEL_TO_STOP_RECORD=10%

SOUND_FILE_EXT=wav
SOUND_FOLDER=./sounds
WHISPER_FOLDER=./whispers

# extra info to the specific output (1->Standard, 2->Error)
ECHO_TO=2

SDTR=$SILENT_DURATION_TO_TRIGGER_RECORD
SLTR=$SILENT_LEVEL_TO_TRIGGER_RECORD
SDSR=$SILENT_DURATION_TO_STOP_RECORD
SLSR=$SILENT_LEVEL_TO_STOP_RECORD

# Gives back the size in B of the given ($1) file
# If the file does not exist, the return value is 0
get_size() {
    (ls --block-size=1 -s "$1" 2>/dev/null || echo "0") | grep -Po "^\d+"
}

# Starts recording with silence detection and waits until the end of the sentence (silence duration) or until the sentence takes the given length (TIME_LIMIT)
record_with_timeout() {

    # Start recording in the background
    command="rec -r 44100 -c 1 -b 16 $1 silence 1 $SDTR $SLTR 1 $SDSR $SLSR &"
    eval $command
    local rec_pid=$!

    echo Recording started... >&$ECHO_TO

    # Maximum recording time
    local max_duration=$TIME_LIMIT
    local duration_from_recording=0

    while true; do

        # If the rec process has exited by silence detection
        if ! kill -0 $rec_pid 2>/dev/null; then
            echo "Recording stopped by silence detection." >&$ECHO_TO
            return
        fi

        # If the audio file is bigger than 50B (empty wav=44B) then we want to limit the duration of the record to 10s
        if [ $(get_size "$1") -gt 50 ] && [ $duration_from_recording -ge $max_duration ]; then
            echo "Recording stopped by time limit. Size: $(get_size $1)B, Duration: $duration_from_recording s" >&$ECHO_TO
            return
        fi

        # Sleep for 1 second before checking again
        sleep 1

        if [ $(get_size "$1") -gt 50 ]; then
            ((duration_from_recording++))
        fi
    done

    # If the loop completes, the record stopped by silence or the max duration was reached
    echo "Abort the record anyway" >&$ECHO_TO
    kill $rec_pid
    wait $rec_pid
}

# Main loop to handle multiple recordings
while true; do
    timestamp=$(date +%Y%m%d-%H%M%S)
    sound_file_name="${timestamp}.$SOUND_FILE_EXT"
    sound_folder_file=$SOUND_FOLDER/$sound_file_name

    echo "Starting new recording: $sound_file_name" >&$ECHO_TO
    record_with_timeout "$sound_folder_file"
    echo "Recording completed: $sound_file_name" >&$ECHO_TO

    # If there was any record, then we try to translate it to text
    if [ $(get_size "$sound_folder_file") -gt 50 ]; then

        echo -n "Translated message: " >&$ECHO_TO
        whisper $sound_folder_file --language $LANGUAGE_CODE --model $LANGUAGE_MODEL --output_dir $WHISPER_FOLDER | grep -oP "(?<=\[.{23}\]  ).+"

    else
        echo "Skip whisper because there was no usable sound record. Something went wrong." >&$ECHO_TO
    fi
done