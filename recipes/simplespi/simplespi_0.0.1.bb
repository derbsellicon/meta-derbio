# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "a simple and easy to use SPI interface for node.js (for raspberry pi etc)"
HOMEPAGE = "https://github.com/fjw/node-simplespi"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c075242a6091f7719cab60a1d1b232b8"

SRC_URI = "npm://registry.npmjs.org;name=simplespi;version=${PV}"

NPM_SHRINKWRAP := "${THISDIR}/${PN}/npm-shrinkwrap.json"
NPM_LOCKDOWN := "${THISDIR}/${PN}/lockdown.json"

inherit npm

# Must be set after inherit npm since that itself sets S
#S = "${WORKDIR}/npmpkg"
LICENSE_${PN} = "MIT"


