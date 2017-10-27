SUMMARY = "Python language"
HOMEPAGE = "https://github.com/OpenZWave/python-openzwave"
LICENSE = "BSD"
DEPENDS = "openzwave python3-native python3-cython python3-cython-native"
PYPI_SRC_URI = "https://raw.githubusercontent.com/OpenZWave/python-openzwave/master/archives/python_openzwave-0.4.0.35.zip"
LIC_FILES_CHKSUM = "file://PKG-INFO;md5=66f979a106466f7a141c4413c844f529"

SRC_URI[md5sum] = "12b64f48c4f31332792f5a65c796e644"
SRC_URI[sha256sum] = "7e810fc51da79e79b60dc9477ed96faeacc1cb678aba981015e89e810f0a0ce4"

#S = "${WORKDIR}/python_openzwave"

do_compile_prepend() {
   [ -d ${WORKDIR}/python_openzwave ] && { 
      rmdir ${S}
      mv ${WORKDIR}/python_openzwave ${S}
   }
   cd ${S} 
}
DISTUTILS_BUILD_ARGS +=   "--cleanozw --flavor=shared"
DISTUTILS_INSTALL_ARGS += "--flavor=shared"

inherit pypi setuptools3 
