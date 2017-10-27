# Recipe created by recipetool
# This is the basis of a recipe and may need further editing in order to be fully functional.
# (Feel free to remove these comments when editing.)

# WARNING: the following LICENSE and LIC_FILES_CHKSUM values are best guesses - it is
# your responsibility to verify that the values are complete and correct.
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=a23a74b3f4caf9616230789d94217acb"

SRC_URI = "git://github.com/rm-hull/spidev-test;protocol=https"

# Modify these as desired
PV = "1.0+git${SRCPV}"
SRCREV = "0b7ecd60c56de6eb36ed553cfa9ebecf34aea8c1"

S = "${WORKDIR}/git"

# NOTE: no Makefile found, unable to determine what needs to be done

do_configure () {
	# Specify any needed configure commands here
	:
}

do_compile () {
	# Specify compilation commands here
	${CC} spidev_test.c -o  spidev_test
}

do_install () {
	# Specify install commands here
	:
}

