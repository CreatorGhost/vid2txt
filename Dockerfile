# Use an official Python runtime as a parent image
FROM python:3.10-slim
# Set the working directory in the container
WORKDIR /usr/src/app

# Install FFmpeg
RUN apt-get update && \
    apt-get install -y ffmpeg \
    build-essential \
    python3-dev \
    libasound2-dev \ 
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Use ENTRYPOINT to make the container run your script like an executable
ENTRYPOINT ["python", "main.py"]