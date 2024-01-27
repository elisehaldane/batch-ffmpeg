#/bin/sh
set -e

# https://mango.blender.org/download/
curl -C - -LO https://ftp.nluug.nl/pub/graphics/blender/demo/movies/ToS/tearsofsteel_4k.mov

input=tearsofsteel_4k.mov
probe_input() {
    ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=codec_name \
        -of default=nokey=1:noprint_wrappers=1 $1
}

err=$(probe_input $input)
if [[ $(echo $err) != 'h264' ]]; then
    echo "[err] download appears corrupt"
    exit 1  # Bail
else
    echo "[info] download appears valid"
fi

benchmark_scales() {
    echo "[info] benchmarking $1 for $input at "$scale"p"
    ffmpeg -threads $(nproc) -benchmark -i $input -c:v $1 \
        -start_number 1 -vframes 1000 -vf scale="$scale" \
        -crf $2 -preset slow -c:a copy -f null out.null 2> \
        $(date +%s)-tos-"$scale"p-ffmpeg-$(nproc)-$1-slow.log
}

scales=(1920:1080 1280:720)
for scale in ${scales[@]}; do
    benchmark_scales libx264 23
    benchmark_scales libx265 28
    echo "[info] benchmarking completed for $input at "$scale"p"
done

echo "[info] all benchmarking completed"
