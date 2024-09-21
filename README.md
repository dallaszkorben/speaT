# speaT
Speak Translate To Text
✅	

## Preparations

### Clone this project on your Ubuntu

### Create virtual environment for Pythong
```sh
$ cd speaT
$ python3 -m venv env
$ source env/bin/activate
(env) $
```

### Install Whisper
The Whisper project can be found here: https://github.com/openai/whisper

```sh
$ python -m pip install -U pip
$ pip install -U openai-whisper
$ pip install setuptools-rust
```
Now the Whisper is ready to be used
Here I show which models worked for me: ❌tiny, ✅base, ✅small, ❌medium, ❓large
