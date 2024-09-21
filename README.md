# speaT
Speak Translate To Text

## Preparations

### Clone this project on your Ubuntu

### Create virtual environment for Python
```sh
$ cd speaT
$ python3 -m venv env
$ source env/bin/activate
(env) $
```

### Install some other apps
```sh
(env) $ sudo apt-get install sox
```

### Install Whisper
The Whisper project can be found here: https://github.com/openai/whisper

```sh
(env) $ python -m pip install -U pip
(env) $ pip install -U openai-whisper
(env) $ pip install setuptools-rust
(env) $ mkdir sounds
(env) $ mkdir whispers
```
Now the Whisper is ready to be used.

When you run the whisper, it will automatically download the needed model, if it had not been downloaded, to `~/.cache/whisper` folder, or to `$XDG_CACHE_HOME`

Here I show which models worked for me: ❌tiny, ✅base, ✅small, ❌medium, ❓large

### Test Whisper
```sh
# create a record of a short sentence in English using your connected microphone
(env) $ rec -r 44100 -c 1 -b 16 ./sounds/output.wav silence 1 0.1 5% 1 1.2 10%

# now translate your recorded voice
(env) $ whisper ./sounds/output.wav --language en --model small --output_dir ./whispers | grep -oP "(?<=\[.{23}\]  ).+"
```
You can see the translated text on your screen.

Just for the record about `rec`. You can run it continuously, it will stop recording after the silent time limit was reached and then it starts a new record with a new file:
```sh
(env) $ rec -r 44100 -c 1 -b 16 ./sounds/output.wav silence 1 0.1 5% 1 1.2 10% : newfile : restart
```

### Test speaT console version
```sh
(env) $ ./speaT.sh
```
After you started the application, you can see a timer running on the left side of the screen.
It is waiting for your voice in the microphone. If you start to talk, a horizontal gauge will indicate that it received it.
<image src="https://github.com/user-attachments/assets/68d2def4-1907-4c74-8e0d-820781e326d5" width="500">

Record will stop if the first stop condition is met:
- stop to talk for 1.5 seconds (configurable)
- talk is longer than 10 seconds\

After the record stopped, the Whisper tries to translate the generated audio file. It takes about 20 seconds. The translated text will appear on your screen, and the application goes back to listen to you.
<image src="https://github.com/user-attachments/assets/77663fff-7c01-44a7-a406-f27e4adb4b85" width="500">

```sh
(env) $ ./speaT.sh 2>/div/null
```
If you redirect all error outputs to the /dev/null and you have already redirected all information messages to the error output in the shell script (`$ECHO_TO`), then only the translations will be shown on your screen.


### Configuration of the shell script
- `LANGUAGE_CODE`    
  the language code, you will speak. It can be for example `en`, `sv` ...  
  default value: `en`
- `LANGUAGE_MODEL`  
  the language model, you want to use for speak to text  
  default value: `small`
- `TIME_LIMIT`  
  the max length of the recorded audio file in seconds  
  default value: `10`  
- `SOUND_DURATION_TO_TRIGGER_RECORD`  
  the duration of the sound in second which will trigger the sound record  
  default value: `0.1`  
- `SOUND_LEVEL_TO_TRIGGER_RECORD`  
  the level of the noise which will taken as a sound  
  default value: `5%`  
- `SILENT_DURATION_TO_STOP_RECORD`  
  the duration of the silent which will be taken as a trigger to stop the record  
  default value: `1.5`  
- `SILENT_LEVEL_TO_STOP_RECORD`  
  the level of the noise which will be taken as a silent  
  default value: `10%`  
- `SOUND_FILE_EXT`  
  the extention of the generated sound files  
  default value: `wav`  
- `SOUND_FOLDER`  
  the folder where the sound files will be stored  
  default value: `./sounds`
- `WHISPER_FOLDER`
  the folder where the whisper files will be stored  
  default value: `./whispers`
- `ECHO_TO`  
  the number of the output where you want to redirect the script informaton-messages. 1->standard output, 2->error output
  default value: `2`  
  
  
