PKG_NAME = pango
PKG_VERS = 1.38.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/pango/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fontconfig cross/cairo cross/glib
OPTIONAL_DEPENDS = cross/harfbuzz cross/harfbuzz_2

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# REMARKS: we must build glib before harfbuzz to get harbuzz glib integration (hb-glib.h)
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/harfbuzz_2
else
DEPENDS += cross/harfbuzz
endif
endif

HOMEPAGE = https://pango.gnome.org/
COMMENT  = Pango is a library for layout and rendering of text, with an emphasis on internationalization.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-cc.mk
