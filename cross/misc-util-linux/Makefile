PKG_NAME = misc-util-linux
PKG_REAL_NAME = util-linux
PKG_VERS = 2.41.1
PKG_VERS_MAJOR = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/linux/utils/$(PKG_REAL_NAME)/v$(PKG_VERS_MAJOR)
# use dedicated folder to build independent of other libraries built from util-linux (i.e. libuuid, libmount, libblkid)
PKG_DIR = $(PKG_NAME)/$(PKG_REAL_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)

DEPENDS = cross/ncursesw

HOMEPAGE = https://github.com/karelzak/util-linux
COMMENT  = Random collection of Linux utilities. We use this only to build ... out of util-linux.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = misc-util-linux_post_install

ADDITIONAL_CFLAGS = -Wno-unused-parameter
CONFIGURE_ARGS = --without-python

# fails to build sys-utils/eject.c
CONFIGURE_ARGS += --disable-eject
# avoid chgrp on install (bin/wall):
CONFIGURE_ARGS += --disable-use-tty-group
# avoid chown on install (bin/mount):
CONFIGURE_ARGS += --disable-makeinstall-chown

# disable unused tools
CONFIGURE_ARGS += --disable-libuuid --disable-uuidd
CONFIGURE_ARGS += --disable-losetup
CONFIGURE_ARGS += --disable-hwclock
CONFIGURE_ARGS += --disable-agetty
CONFIGURE_ARGS += --disable-fallocate
CONFIGURE_ARGS += --disable-cramfs
CONFIGURE_ARGS += --disable-bfs
CONFIGURE_ARGS += --disable-mkfs 
CONFIGURE_ARGS += --disable-minix
CONFIGURE_ARGS += --disable-wipefs
CONFIGURE_ARGS += --disable-mountpoint
CONFIGURE_ARGS += --disable-plymouth_support
CONFIGURE_ARGS += --disable-unshare
CONFIGURE_ARGS += --disable-irqtop
CONFIGURE_ARGS += --disable-ul
CONFIGURE_ARGS += --disable-more

# depends on sqlite3
CONFIGURE_ARGS += --disable-liblastlog2

# fails to build for: evansport (DSM 6 only), ARMv7_ARCHS (except for SRM-1.2), ARMv7L_ARCHS
CONFIGURE_ARGS += --disable-enosys

# OLD_PPC_ARCHS
# misc-utils/pipesz.c:128: error: 'F_SETPIPE_SZ' undeclared
CONFIGURE_ARGS += --disable-pipesz

# fails to build for: hi3535-6.1
CONFIGURE_ARGS += --disable-schedutils

# fails to build for: armv7-1.2
CONFIGURE_ARGS += --disable-lsfd

# fails to build for: 88f6281-6.1, 88f6281-5.2, qoriq-6.1
# taken from <linux/fiemap.h> for toolchains without this header file
ADDITIONAL_CFLAGS += -DFIEMAP_EXTENT_SHARED=0x00002000
### disk-utils/mkswap.c:294:22: error: 'FIEMAP_EXTENT_SHARED' undeclared (first use in this function)

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ifeq ($(call version_lt, $(TCVERSION), 7.2),1) 
CONFIGURE_ARGS += --disable-year2038
endif
endif

ifeq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
# Does not support lsblk, libblkid and dependencies (libmount, findmnt)
CONFIGURE_ARGS += --disable-scriptutils
CONFIGURE_ARGS += --disable-libblkid --disable-blkid
PLIST_TRANSFORM = sed -e '/bin\/lsblk/d' -e '/bin\/findmnt/d' -e '/lib\/libmount/d' -e '/lib\/libblkid/d'
endif

# for clock_gettime
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
ADDITIONAL_LDFLAGS = -lrt
endif

# for lsblk and others: ncurses must be built with tinfo
# this seems to be a bug in util-linux, as most of other libraries fail to find ncurses/termlib
# dependencies when ncurses is build with lib tinfo
# https://github.com/util-linux/util-linux/issues/2416
# This is a workaround to use ncursesw without tinfo:
# - still required for util-linux v2.41.1
COMPILE_MAKE_OPTIONS = NCURSES_LIBS="-lncursesw"

include ../../mk/spksrc.cross-cc.mk

.PHONY: misc-util-linux_post_install
misc-util-linux_post_install:
	@$(MSG) Use tools in bin for DSM 7 compatibility
	@install -m 755 $(STAGING_INSTALL_PREFIX)/sbin/zramctl $(STAGING_INSTALL_PREFIX)/bin/zramctl
