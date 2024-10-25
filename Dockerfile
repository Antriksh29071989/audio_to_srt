FROM python:3.11-slim

# Copy your Python script into the container
RUN apt-get update && apt-get install -y ffmpeg

COPY requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

COPY main.py /app/main.py
WORKDIR /app

CMD ["python", "main.py"]