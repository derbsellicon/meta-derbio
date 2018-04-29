FILESEXTRAPATHS_prepend := "${THISDIR}/dnsmasq:"

SRC_URI += "file://dnsmasq.conf" 

do_install_prepend() {
   [ "1" -eq "0" ] && \
}

