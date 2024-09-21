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
(env) $ sudo apt-get install sax
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
(env) $ whisper ./sounds/output.wav --language en --model small --output_dir ./whispers | grep -oP "(?<\[.{23}\]  ).+"
```
You can see the translated text on your screen.

Just for the record about rec. You can run it continuously, it will stop recording after the silent time limit was reached and then it starts a new record with a new file:
```sh
(env) $ rec -r 44100 -c 1 -b 16 ./sounds/output.wav silence 1 0.1 5% 1 1.2 10% : newfile : restart
```
