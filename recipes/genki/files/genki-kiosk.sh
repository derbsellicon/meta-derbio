#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/1000
google-chrome --disable-session-crashed-bubble --kiosk --disable-infobars https://gen.ki
layer-add-surfaces 0 1000 1
LayerManagerControl set surface 7001 destination region 0 0 1920 1080
