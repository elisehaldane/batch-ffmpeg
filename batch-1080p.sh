#/bin/sh
set -e

# https://mango.blender.org/download/
curl -C - -LO https://ftp.nluug.nl/pub/graphics/blender/demo/movies/ToS/tearsofsteel_4k.mov

probe_input() {
    ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=codec_name \
        -of default=nokey=1:noprint_wrappers=1 $1
}

err=$(probe_input tearsofsteel_4k.mov)
if [[ $(echo $err) != 'h264' ]]; then
    echo "[err] download appears corrupt"
    exit 1  # Bail
else
    echo "[info] download appears valid"
fi

benchmark_1080p() {
    echo "[info] benchmarking the $1 encoder for $input"
    ffmpeg -threads $(nproc) -benchmark -i $input -c:v $1 \
        -start_number 1 -vframes 1000 -vf scale="-2:1080" \
        -crf $2 -preset slow -c:a copy -f null out.null 2> \
        $(date +%s)-tos-ffmpeg-$(nproc)-$1-slow.log
}

for input in *.mov; do
    benchmark_1080p libx264 23
    benchmark_1080p libx265 28
    echo "[info] benchmarking completed for $input"
done

echo "[info] all benchmarking completed"
