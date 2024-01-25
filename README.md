# Batch FFmpeg

This repository is intended to provide scripts to benchmark a range of
CPUs with comparable features, taking inspiration from AWS' analysis of
[optimised encoding performance][1] on Graviton instances. That
benchmarking used a 2012 short [_Tears of Steel_][2] by the Blender
Foundation, using both x264 and x265 encoders against an FFmpeg
development build optimised for Neoverse chips. To begin replicating
the AWS tests, the initial script, `batch-1080p.sh` uses all available
threads to re-encode 1,000 frames from the 4K version of the film at
1080p with FFmpeg's slow preset.

<!-- Links -->
[1]: https://aws.amazon.com/blogs/opensource/optimized-video-encoding-with-ffmpeg-on-aws-graviton-processors/
[2]: https://en.wikipedia.org/wiki/Tears_of_Steel
