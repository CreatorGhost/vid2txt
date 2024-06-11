from moviepy.editor import VideoFileClip
import whisper
import os
import argparse
def extract_audio_from_video(video_path, audio_path):
    """
    Extracts audio from a video file and saves it as an audio file.
    """
    video = VideoFileClip(video_path)
    video.audio.write_audiofile(audio_path)
    print(f"Audio extracted and saved to {audio_path}")

def transcribe_audio_with_whisper(audio_path):
    """
    Transcribes audio to text using OpenAI's Whisper model.
    """
    model = whisper.load_model("base")  # You can choose different model sizes based on your needs
    result = model.transcribe(audio_path)
    return result["text"]

def video_to_text(video_path, output_text_file):
    """
    Extracts audio from a video file, transcribes it to text using Whisper, and saves the text to a file.
    """
    audio_path = "temp_audio.mp3"
    extract_audio_from_video(video_path, audio_path)
    text = transcribe_audio_with_whisper(audio_path)
    os.remove(audio_path)  # Optionally remove the temporary audio file
    
    # Save the transcribed text to a file
    with open(output_text_file, "w") as file:
        file.write(text)
    print(f"Transcribed text saved to {output_text_file}")

# Example usage
if __name__ == "__main__":
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='Transcribe video to text.')
    parser.add_argument('video_path', type=str, help='Path to the video file')
    parser.add_argument('output_text_file', type=str, help='Path to save the transcribed text')
    args = parser.parse_args()

    # Use the provided arguments
    video_to_text(args.video_path, args.output_text_file)