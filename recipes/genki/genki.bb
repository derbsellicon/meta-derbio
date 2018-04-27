DESCRIPTION = "Genki Specific files"
LICENSE = "CLOSED"
PN = 'genki'
PV = '0.0.1'

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://genki-val.sh \
    file://genki-wifi-ap3.sh \
    file://tlc5947_libsoc3.py \
"

S = "${WORKDIR}"

FILES_${PN} = " \
  /opt/genki/bin/genki-wifi-ap3.sh \
  /opt/genki/bin/tlc5947_libsoc3.py \
  /opt/genki/bin/genki-val.sh \
"

do_install() {
  install -d ${D}/opt/genki/bin
  install -m 755 genki-val.sh ${D}/opt/genki/bin/ 
  install -m 755 genki-wifi-ap3.sh ${D}/opt/genki/bin/ 
  install -m 755 tlc5947_libsoc3.py ${D}/opt/genki/bin/ 
}
