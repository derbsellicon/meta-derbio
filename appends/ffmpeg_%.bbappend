PACKAGECONFIG = "sdl2 avdevice avfilter avcodec avformat swresample swscale postproc \
                   bzlib gpl lzma theora x264 \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xv', '', d)}"
