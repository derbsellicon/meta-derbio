#!/bin/bash

#URL="http://gen.ki"
URL="file:///opt/genki/data/genki.mhtml"

export XDG_RUNTIME_DIR=/run/user/1000
sleep 5
#LayerManagerControl get screen 0
sleep 5
google-chrome --disable-session-crashed-bubble --kiosk --disable-infobars $URL &
sleep 5
#layer-add-surfaces 0 1000 2
#LayerManagerControl set surface 7001 destination region 0 0 1920 1080
