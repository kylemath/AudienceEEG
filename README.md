# AudienceEEG
 EEG files are .csv files from EEG 101 App on android

 5 columns, first is packet timestamp (need to convert to samples)

 Next four are 4 Muse/smith electrodes

 Video files are .mp4 files trimed to the start and stop of EEG with GoPro Quick.app for mac

 GoPro Hero 5

## Data Storage

Large data files are stored on [Google Drive](https://drive.google.com/drive/folders/1T9WHiysHzYrZhhKJGYEsCKH-1XQ_xx0Y). 

## Laughter Detection

Using [Laughter Detection](https://github.com/jrgillick/laughter-detection) we can naively pull out the timecode for audience reactions using the pretrained model from the repository.

```sh
# extract audio from the video
ffmpeg -i improbotics_closing2min_june16_2018_trimmed.mp4 -f wav -vn audio.wav
# extract laughter timecodes
python segment_laughter.py improbotics_closing2min_june16_2018_audio.wav models/model.h5 output 0.8 0.1
```
