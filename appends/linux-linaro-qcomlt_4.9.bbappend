LINUX_LINARO_QCOM_GIT = "git://bitbucket.org/derbsellicon/linux-qcom.git;protocol=https"
SRCBRANCH = "derbio/release/qcomlt-4.9"
#SRCREV ?= "fd91ff439322a7cf41cc12cf0a5ad389d433fade"
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-linaro-qcomlt:"

#SRC_URI += "file://0001-qcom-dts-adding-spidev-on-BLSP.patch"
SRC_URI += "file://defconfig"
