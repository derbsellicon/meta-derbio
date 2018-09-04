DESCRIPTION = "Genki Specific files"
LICENSE = "CLOSED"
PN = 'genki'
PV = '0.0.1'

inherit systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://genki-val.sh \
    file://genki-wifi-ap3.sh \
    file://tlc5947_libsoc3.py \
    file://genki-kiosk.sh \
    file://genki-kiosk.service \
    file://genki.mhtml \
"

S = "${WORKDIR}"

FILES_${PN} += " \
  /opt/genki/bin/genki-wifi-ap3.sh \
  /opt/genki/bin/tlc5947_libsoc3.py \
  /opt/genki/bin/genki-val.sh \
  /opt/genki/bin/genki-kiosk.sh \
  /opt/genki/data/genki.mhtml \
"

PROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "genki-kiosk.service"

do_install() {
  install -d ${D}/opt/genki/bin
  install -d ${D}/opt/genki/data
  install -d ${D}${systemd_unitdir}/system

  install -m 755 genki-val.sh ${D}/opt/genki/bin/ 
  install -m 755 genki-wifi-ap3.sh ${D}/opt/genki/bin/ 
  install -m 755 tlc5947_libsoc3.py ${D}/opt/genki/bin/ 
  install -m 755 genki-kiosk.sh ${D}/opt/genki/bin/
  install -m 755 genki.mhtml ${D}/opt/genki/data/
  install -m 0644 genki-kiosk.service ${D}${systemd_unitdir}/system/genki-kiosk.service
}
