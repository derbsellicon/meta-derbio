#LINUX_LINARO_QCOM_GIT = "git://bitbucket.org/derbsellicon/linux-qcom.git;protocol=https"
LINUX_LINARO_QCOM_GIT = "git://github.com/derbsellicon/linux-qcom.git;protocol=https"
SRCBRANCH = "derbio/release/qcomlt-4.9"
SRCREV = "2057f2e13a0747358f8cfd438a6d8021b3695052"
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-linaro-qcomlt:"

#SRC_URI += "file://0001-qcom-dts-adding-spidev-on-BLSP.patch"
SRC_URI += "file://defconfig"
