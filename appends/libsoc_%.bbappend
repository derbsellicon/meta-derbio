BOARD = "dragonboard410c"
PACKAGECONFIG += "enableboardconfig"
PACKAGECONFIG += "python"

#do_install_append(){
#   install -d ${D}/usr/lib
#   install -m 755 ${D}/usr/lib64/libsoc.so.2 ${D}/usr/lib/libsoc.so
#}
