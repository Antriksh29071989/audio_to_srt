#!/bin/bash

# Check if the required parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <MODEL> <AUDIO_PATH>"
    exit 1
fi

MODEL=$1
AUDIO_PATH=$2

echo "$MODEL"
echo "$AUDIO_PATH"

AUDIO_DIR=$(dirname "$AUDIO_PATH")
echo "AUDIO_DIR: $AUDIO_DIR"

docker rm -f audio_to_srt_container > /dev/null 2>&1

# Download the model
mkdir -p app/models
whisper download "$MODEL_VERSION" --output_dir app/models

# Run the Docker container with the provided parameters
docker run --name audio_to_srt_container -e MODEL="$MODEL" -e AUDIO_PATH="/app/vol/$(basename "$AUDIO_PATH")" -v "${AUDIO_DIR}:/app/vol" -v "$(pwd)/app/models:/app/models" audio_to_srt

AUDIO_NAME=$(basename "$AUDIO_PATH" | cut -f 1 -d '.')

# Copy the output file from the container to the local machine
docker cp audio_to_srt_container:/app/vol/"${AUDIO_NAME}".srt /Users/antriksh/PycharmProjects/prometheus_demo/"${AUDIO_NAME}".srt

# Clean up the container
docker rm audio_to_srt_container


#docker build -t audio_to_srt .
#docker run --name audio_to_srt_container2 -e MODEL="tiny.en" -e AUDIO_PATH="/app/vol/loca.m4a" -v "/Users/antriksh/PycharmProjects/prometheus_demo:/app/vol" audio_to_srt
#docker cp audio_to_srt_container2:/app/loca.srt /Users/antriksh/PycharmProjects/prometheus_demo/loca.srt
