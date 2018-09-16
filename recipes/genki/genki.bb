DESCRIPTION = "Genki Specific files"
LICENSE = "CLOSED"
PN = 'genki'
PV = '0.0.1'
RDEPENDS_${PN} = "mosquitto-clients"

inherit systemd

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://genki-val.sh \
    file://genki-wifi-ap.sh \
    file://rgbled-control.py \
    file://genki-kiosk.sh \
    file://genki-kiosk.service \
    file://genki-firstrun.sh \
    file://snips-feedback.sh \
    file://genki-snips-feedback.service \
    file://genki-firstrun.service \
    file://genki.mhtml \
    file://genki2.jpg \
    file://genki-intro.wav \
"

S = "${WORKDIR}"

FILES_${PN} += " \
  /opt/genki/bin/genki-wifi-ap.sh \
  /opt/genki/bin/rgbled-control.py \
  /opt/genki/bin/genki-val.sh \
  /opt/genki/bin/genki-kiosk.sh \
  /opt/genki/bin/snips-feedback.sh \
  /opt/genki/bin/genki-firstrun.sh \
  /opt/genki/data/genki.mhtml \
  /opt/genki/data/genki2.jpg \
  /opt/genki/data/genki-intro.wav \
"

PROVIDES_${PN}   += "${PN}-systemd"
RREPLACES_${PN}  += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"

SYSTEMD_SERVICE_${PN}  = "genki-kiosk.service"
SYSTEMD_SERVICE_${PN} += "genki-firstrun.service"
SYSTEMD_SERVICE_${PN} += "genki-snips-feedback.service"

do_install() {
  install -d ${D}/opt/genki/bin
  install -d ${D}/opt/genki/data
  install -d ${D}${systemd_unitdir}/system

  install -m 755 genki-val.sh ${D}/opt/genki/bin/ 
  install -m 755 genki-wifi-ap.sh ${D}/opt/genki/bin/
  install -m 755 rgbled-control.py ${D}/opt/genki/bin/
  install -m 755 genki-kiosk.sh ${D}/opt/genki/bin/
  install -m 755 snips-feedback.sh ${D}/opt/genki/bin/
  install -m 755 genki-firstrun.sh ${D}/opt/genki/bin/
  install -m 755 genki.mhtml ${D}/opt/genki/data/
  install -m 0644 genki-kiosk.service ${D}${systemd_unitdir}/system/genki-kiosk.service
  install -m 0644 genki-snips-feedback.service ${D}${systemd_unitdir}/system/genki-snips-feedback.service
  install -m 0644 genki-firstrun.service ${D}${systemd_unitdir}/system/genki-firstrun.service
  install -m 0644 genki2.jpg ${D}/opt/genki/data/
  install -m 0644 genki-intro.wav ${D}/opt/genki/data/
}
