---
name: video-debug
description: Convert a video file to a temporary GIF for visual analysis, then describe what's happening and diagnose issues
argument-hint: "<path-to-video> [description of the issue]"
disable-model-invocation: false
---

# Video Debug

Convert a video file to a GIF so it can be visually inspected, then analyze the contents to diagnose UI bugs, rendering issues, or other visual problems.

**Input:** {{arguments}}

## Process

1. Parse the input to extract the video file path and any issue description
2. Convert the video to a temporary GIF using ffmpeg:
   ```
   ffmpeg -i <video-path> -vf "fps=10,scale=800:-1:flags=lanczos" -t 15 /tmp/video-debug.gif
   ```
   - Use fps=10 for reasonable file size
   - Scale to 800px wide
   - Limit to first 15 seconds (adjust with -t if needed)
   - If the video is longer than 15s, ask the user which segment to capture
3. Read the generated GIF using the Read tool to visually inspect it
4. Describe what you observe in the recording - focus on:
   - UI elements and their behavior
   - Any visual glitches, lag, or unexpected behavior
   - Timing and sequence of events
5. If an issue description was provided, diagnose the root cause based on what you see
6. If you can identify relevant code, suggest a fix

## Notes

- Requires `ffmpeg` to be installed
- The GIF is written to /tmp and can be cleaned up after analysis
- For longer videos, you can adjust the start time with `-ss <seconds>` before `-i`
- If the GIF is too large or unclear, try reducing fps or scale
