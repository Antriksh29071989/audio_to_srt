from datetime import timedelta
import whisper
import os
from pathlib import Path

# Access the environment variables
model_version = os.getenv('MODEL')
audio_path = os.getenv('AUDIO_PATH')
print("Loading model {}", model_version)
print("audio_path {}", audio_path)

model = whisper.load_model(model_version)
print("Whisper model loaded.")
print("Transcribing audio...")

transcribe = model.transcribe(audio=audio_path)
segments = transcribe['segments']
srtFilename = f"/app/{Path(audio_path).stem}.srt"
for segment in segments:
    startTime = str(0) + str(timedelta(seconds=int(segment['start']))) + ',000'
    endTime = str(0) + str(timedelta(seconds=int(segment['end']))) + ',000'
    text = segment['text']
    segmentId = segment['id'] + 1
    segment = f"{segmentId}\n{startTime} --> {endTime}\n{text[1:] if text[0] is ' ' else text}\n\n"
    with open(srtFilename, 'a', encoding='utf-8') as srtFile:
        srtFile.write(segment)

print("Process completed. Saved in container on path {}", srtFilename)
