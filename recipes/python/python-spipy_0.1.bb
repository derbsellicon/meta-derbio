SUMMARY = "Python language"
HOMEPAGE = "https://github.com/lthiery/SPI-Py"
LICENSE = "CLOSED"
DEPENDS = "python-native python-cython python-cython-native"
PYPI_SRC_URI = "git://github.com/lthiery/SPI-Py/"
SRCNAME = "SPI-Py-master"
LIC_FILES_CHKSUM = "file://README.md;md6=961d517867273265837f1f9024cb23e1"
SRCREV = "8cce26b9ee6e69eb041e9d5665944b88688fca68"

SRC_URI[md5sum] = "9cec3e8899c3a91bf901d30c58131167"
SRC_URI[sha256sum] = "97c07e766525d84106bef0cfb615a621fcc46fc8ab8a1a511b12c03843fd2990"

inherit pypi setuptools
