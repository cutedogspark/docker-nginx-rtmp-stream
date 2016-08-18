# nginx-rtmp-docker
=====================

## How to use
----------
### Build
    docker build -t garychen/qnap-nginx-rtmp .

### Run


#### transcoding with FFmpeg
----------
#### OSX
    ffmpeg -re -framerate 30000/1001 -loop 1 -i black.png -vf drawtext="fontfile=/Library/Fonts/Arial Black.ttf:timecode='$(date +%H'\:'%M'\:'%S'\:'%S)':rate=29.97:text='TCR\:':fontsize=14:fontcolor='white':boxcolor=0x000000AA:box=1:x=100:y=100" -c:v libx264 -vcodec libx264 -pix_fmt yuv420p -preset veryfast  -f flv  rtmp://localhost:1935/encoder/test

#### LINUX
    ffmpeg -re -framerate 30000/1001 -loop 1 -i blue.png -vf drawtext="fontfile=/usr/share/fonts/truetype/droid/DroidSansFallbackFull.ttf:timecode='$(date +%H'\:'%M'\:'%S'\:'%02N)':rate=29.97:text='TCR\:':fontsize=72:fontcolor='white':boxcolor=0x000000AA:box=1:x=10:y=10" -c:v libx264 -vcodec libx264 -pix_fmt yuv420p -preset veryfast -f flv rtmp://localhost:1935/rtmp/live
