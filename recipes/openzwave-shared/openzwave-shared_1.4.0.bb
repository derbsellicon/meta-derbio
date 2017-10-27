# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

SUMMARY = "Node.JS bindings for OpenZWave including management and security functions"
# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
#
# NOTE: multiple licenses have been detected; they have been separated with &
# in the LICENSE value for now since it is a reasonable assumption that all
# of the licenses apply. If instead there is a choice between the multiple
# licenses then you should change the value to separate the licenses with |
# instead of &. If there is any doubt, check the accompanying documentation
# to determine which situation is applicable.
#
# The following license files were not able to be identified and are
# represented as "Unknown" below, you will need to check them yourself:
#   LICENSE.md
#   node_modules/nan/LICENSE.md
#
LICENSE = "ISC & MIT"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=a58c517a5ff3532757f361e43be06939 \
                    file://node_modules/nan/LICENSE.md;md5=d7425f79f415dec8f013aa2869dd7a4e"

SRC_URI = "npm://registry.npmjs.org;name=openzwave-shared;version=${PV}"

NPM_SHRINKWRAP := "${THISDIR}/${PN}/npm-shrinkwrap.json"
NPM_LOCKDOWN := "${THISDIR}/${PN}/lockdown.json"
DEPENDS := "openzwave" 

CXXFLAGS_prepend = "-I${WORKDIR}/recipe-sysroot/usr/include/openzwave \
                    -I${WORKDIR}/recipe-sysroot/usr/include/openzwave/value_classes "

inherit npm

# Must be set after inherit npm since that itself sets S
#S = "${WORKDIR}/npmpkg"
LICENSE_${PN}-nan = "MIT"
LICENSE_${PN} = "ISC"


