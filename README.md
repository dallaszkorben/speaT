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

