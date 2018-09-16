BOARD = "dragonboard410c"
PACKAGECONFIG += "enableboardconfig"
PACKAGECONFIG += "python"

FILES_${PN} += "/usr/lib/libsoc.so"

do_install_append(){
   install -d ${D}/usr/lib
   cd ${D}/usr/lib
   ln -s ../lib64/libsoc.so.2 libsoc.so
}

INSANE_SKIP_${PN} = "dev-so"
